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
import 'about_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  User _currentUser;
  UserHelper _userHelper;

  // A lista abaixo guarda os Widgets que serão usados como páginas
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _userHelper = UserHelper();

    _userHelper.readUser().then((u) {
      _currentUser = u;

      _pages = [
        PaginaRu(),
        PaginaAgenda(_currentUser != null ? _currentUser.mat : null),
        PaginaNoticias(),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text(_currentUser == null ? "UFSCar App" : "Olá, ${_currentUser.nome.split(" ")[0]}"),
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.redAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () async {
              print("Botão pressionado :)");
            },
          ),
          IconButton(
            icon: Icon(Icons.restore_from_trash),
            onPressed: () {
              _userHelper.deleteFile();

              setState(() {
                _currentUser = null;
              });
            },
          )
        ],
      ),
      drawer: new Drawer(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              ListTile(
                title: Text("UFSCar App", textAlign: TextAlign.center,),
              ),
              ListTile(
                title: Text("Este app ainda está em desenvolvimento! Não compartilhe seu arquivo APK.", textAlign: TextAlign.center,),
              ),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("_assets/brasil.png", height: 10,),
                    SizedBox(width: 5,),
                    Text("Defenda a ciência brasileira")
                  ],
                ),
              ),
              Divider(),
              ListTile(
                title: Text("Sobre este app"),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage() )).then((value) => Navigator.pop(context)),
              ),
            ],
          ),
        )
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
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
              icon: Icon(Icons.fastfood), title: Text("Cardápio RU")),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today), title: Text("Agenda")),
          BottomNavigationBarItem(
              icon: Icon(Icons.assignment), title: Text("Notícias")),
        ],
      ),
    );
  }
}
