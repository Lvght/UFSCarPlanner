import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'package:ufscarplanner/ui/pagina_ru.dart';
import 'package:ufscarplanner/ui/pagina_noticias.dart';
import 'package:ufscarplanner/ui/radio_page.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/settings_page.dart';
import 'about_page.dart';
import 'package:async/async.dart';
import 'package:ufscarplanner/ui/pagina_game.dart';
import 'package:ufscarplanner/models/user.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 2;
  User _currentUser;
  UserHelper _userHelper = UserHelper();
  AsyncMemoizer _memoizer = AsyncMemoizer();

  // A lista abaixo guarda os Widgets que serão usados como páginas
  List<Widget> _pages = [PaginaRu(), PaginaNoticias(), RadioPage()];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _memoizer.runOnce(() => Future.delayed(Duration(seconds: 1)).then((value) => _userHelper.readUser())),
        builder: (context, userData) {
          switch (userData.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
            case ConnectionState.active:
              return Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor])),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      /*Image.asset(
                        "_assets/ufscar.png",
                        height: 100,
                      ),*/
                      SizedBox(
                        height: 20,
                      ),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ],
                  ),
                ),
              );
            default:
              return Scaffold(
                appBar: _getAppBar(userData.data != null ? "Olá, ${userData.data.nome.split(" ")[0]}" : "UFSCar App"),
                body: IndexedStack(
                  index: _currentIndex,
                  children: <Widget>[
                    PaginaRu(),
                    PaginaNoticias(),
                    PaginaAgenda(userData.data != null ? userData.data.mat : null),
                    RadioPage(),
                    SettingsPage(userData.data != null ? true : false)
                  ],
                ),
                bottomNavigationBar: _getBottomNavigationBar(),
              );
          }
        });
  }

  GradientAppBar _getAppBar(String title) => GradientAppBar(
        /* MANTENHA PARA FINS DE DEPURAÇÃO! actions: <Widget>[
          IconButton(
            icon: Icon(Icons.bug_report),
            onPressed: () async {
              print("Botão pressionado :)");
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _userHelper.deleteFile();

              setState(() {
                _currentUser = null;
              });
            },
          )
        ],*/
        backgroundColorStart: Theme.of(context).primaryColor,
        backgroundColorEnd: Theme.of(context).accentColor,
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(title),
            ),
          ],
        ),
      );

  Drawer _getDrawer() => Drawer(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            GestureDetector(
              child: ListTile(
                title: Text(
                  "UFSCar App",
                  textAlign: TextAlign.center,
                ),
              ),
              onLongPress: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyGame()));
                setState(() {});
              },
            ),
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    "_assets/brasil.png",
                    height: 10,
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text("Defenda a ciência brasileira")
                ],
              ),
            ),
            Divider(),
            ListTile(
              title: Text("Sobre este app"),
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => AboutPage()))
                  .then((value) => Navigator.pop(context)),
            ),
          ],
        ),
      ));

  BottomNavigationBar _getBottomNavigationBar() => BottomNavigationBar(
        showSelectedLabels: true,
        selectedItemColor: Theme.of(context).accentColor,
        unselectedIconTheme: IconThemeData(
          color: Theme.of(context).disabledColor
        ),
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), title: Text("Cardápio RU")),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), title: Text("Notícias")),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text("Agenda")),
          BottomNavigationBarItem(icon: Icon(Icons.radio), title: Text("Rádio")),
          BottomNavigationBarItem(icon: Icon(Icons.more_horiz), title: Text("Configurações")),
        ],
      );
}
