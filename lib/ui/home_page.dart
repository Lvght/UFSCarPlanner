import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'package:ufscarplanner/ui/pagina_ru.dart';
import 'package:ufscarplanner/ui/pagina_noticias.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'about_page.dart';
import 'package:async/async.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 1;
  User _currentUser;
  UserHelper _userHelper = UserHelper();
  AsyncMemoizer _memoizer = AsyncMemoizer();

  // A lista abaixo guarda os Widgets que serão usados como páginas
  List<Widget> _pages = [PaginaRu(), PaginaNoticias()];

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
                decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.red, Colors.redAccent])),
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "_assets/ufscar.png",
                        height: 100,
                      ),
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
                drawer: _getDrawer(),
                body: IndexedStack(
                  index: _currentIndex,
                  children: <Widget>[
                    PaginaRu(),
                    PaginaAgenda(userData.data != null ? userData.data.mat : null),
                    PaginaNoticias()
                  ],
                ),
                bottomNavigationBar: _getBottomNavigationBar(),
              );
          }
        });
  }

  GradientAppBar _getAppBar(String title) => GradientAppBar(
//        actions: <Widget>[
//          IconButton(
//            icon: Icon(Icons.bug_report),
//            onPressed: () async {
//              print("Botão pressionado :)");
//            },
//          ),
//          IconButton(
//            icon: Icon(Icons.delete),
//            onPressed: () {
//              _userHelper.deleteFile();
//
//              setState(() {
//                _currentUser = null;
//              });
//            },
//          )
//        ],
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.redAccent,
        title: Row(
          children: <Widget>[
            Expanded(
              child: Text(title),
            ),
            Image.asset(
              "_assets/ufscar.png",
              height: MediaQuery.of(context).size.height * 0.06,
            )
          ],
        ),
      );

  Drawer _getDrawer() => Drawer(
          child: Container(
        width: MediaQuery.of(context).size.width,
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text(
                "UFSCar App",
                textAlign: TextAlign.center,
              ),
            ),
            ListTile(
              title: Text(
                "Este app ainda está em desenvolvimento! Não compartilhe seu arquivo APK.",
                textAlign: TextAlign.center,
              ),
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
        unselectedIconTheme: IconThemeData(
          color: Color.fromRGBO(200, 200, 200, 1),
        ),
        selectedIconTheme: Theme.of(context).iconTheme,
        showSelectedLabels: false,
        currentIndex: _currentIndex,
        onTap: (int index) => setState(() => _currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.fastfood), title: Text("Cardápio RU")),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), title: Text("Agenda")),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), title: Text("Notícias")),
        ],
      );
}
