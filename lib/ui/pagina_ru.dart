import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ufscarplanner/components/menu_card.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/models/meal.dart';
import 'package:hive/hive.dart';

class PaginaRu extends StatefulWidget {
  @override
  _PaginaRuState createState() => _PaginaRuState();
}

class _PaginaRuState extends State<PaginaRu> {
  final AsyncMemoizer _memoizer = AsyncMemoizer();

  DataScrapper d1 = DataScrapper(

      //TODO TRATAR FALTA DE INTERNET
      'https://www2.ufscar.br/restaurantes-universitario/cardapio');

  TextStyle _boldTextStyle() => TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  TextStyle _regularText() => TextStyle(
        color: Colors.black,
        fontSize: 18, // FIXME Usar tamanho relativo seria preferível?
      );

  String userDataFilename = "Mealsdata.json";

  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<List<Meal>> iniciar() async {
    List<Meal> listMeals = new List<Meal>();
    final mealsBox = Hive.box("meals");
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
      await d1.initiate().then((valor) async {
        await mealsBox.clear();
        await mealsBox.addAll(valor);
        listMeals.addAll(valor);
      });
    } else {
//      print("\n\n\n\n N TEM NET GENTE\n\n\n\n\n");
      if (mealsBox.length != 0)
        for (int i = 0; i < mealsBox.length; i++) {
          Meal meal = await mealsBox.getAt(i);
          listMeals.add(meal);
        }
      else {
        listMeals.add(new Meal.internal());
      }
    }
//    print("iiiiiiiii\ni\nii\niiii\niiii\niiiiiiiiii\n\n\n\n\n\n");
    setState(() {});
    return listMeals;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memoizer.runOnce(() => iniciar()),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
              ),
            );

          default:
            return Container(
              child: ListView.builder(
                  itemCount: snapshot.data == null ? 0 : snapshot.data.length,
                  shrinkWrap: false,
                  itemBuilder: (context, index) => Container(
                        child: MenuCard(snapshot.data[index]),
                      )),
            );
        }
      },
    );
  }
}
