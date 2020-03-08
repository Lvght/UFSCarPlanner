import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';

class PaginaRu extends StatefulWidget {
  @override
  _PaginaRuState createState() => _PaginaRuState();
}

class _PaginaRuState extends State<PaginaRu> {
  DataScrapper d1 = DataScrapper(
      'https://www2.ufscar.br/restaurantes-universitario/cardapio');

  Widget cardTextBuilder(AsyncSnapshot<List<Meal>> snapshot, int index) {
    String out = "";
    for (int i = 0; i < snapshot.data[index].lista.length; i++)
      out += snapshot.data[index].lista[i];

    return Container(
      child: Text(out),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: d1.initiate(),
      builder: (context, AsyncSnapshot<List<Meal>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(),
            );

          default:
            return ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),
                  color: Colors.greenAccent,
                  child: Row(
                    children: <Widget>[
                      Image.network(
                        'https://img.gentside.com.br/article/entretenimento/rato-maconha_54f642e714000fd7b75b1a042efc840c504999dc.jpg',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 30 / 100,
                        height: MediaQuery.of(context).size.width * 30 / 100,
                      ),
                      // todo Adicionar texto
                    ],
                  ),
                ),
              ),
              itemCount: snapshot.data.length,
            );
        }
      },
    );
  }
}
