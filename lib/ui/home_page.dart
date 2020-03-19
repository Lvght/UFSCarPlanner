import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'package:ufscarplanner/ui/pagina_ru.dart';
import 'package:ufscarplanner/ui/pagina_noticias.dart';
import 'package:ufscarplanner/ui/login_page.dart';
import 'login_page.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  int _currentIndex = 0;

  // A lista abaixo guarda os Widgets que serão usados como páginas
  List<Widget> _pages = [
    PaginaRu(),
    PaginaAgenda(),
    PaginaNoticias(),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("UFSCar Planner"),
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.redAccent,
      ),
      drawer: new Drawer(

            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 15, bottom: 60),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset("_assets/brasil.png", width: MediaQuery.of(context).size.width * 25 / 100,),
                      SizedBox(height: 10,),
                      Text("Defenda a ciência brasileira.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
                    ],
                  ),
                ),
                RaisedButton(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
                  child: Text("Fazer login"),
                ),
                RaisedButton(
                  child: Text("Imprimir texto do arquivo"),
                  onPressed: () async {
                    final userHelper = UserHelper();
                    debugPrint(await userHelper.readRawData());
                  },
                )
              ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedIconTheme: IconThemeData(
          color: Color.fromRGBO(200, 200, 200, 1),
        ),
        selectedIconTheme: Theme.of(context).iconTheme,
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() {
          _currentIndex = index;
        }),
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.fastfood),
              title: Text("Cardápio RU")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today),
              title: Text("Agenda")
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment),
              title: Text("Notícias")
          ),

        ],
      ),
    );
  }
}
