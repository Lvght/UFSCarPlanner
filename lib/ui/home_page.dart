import 'package:flutter/material.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'package:ufscarplanner/ui/pagina_ru.dart';
import 'package:ufscarplanner/ui/pagina_configuracoes.dart';
import 'package:ufscarplanner/ui/pagina_noticias.dart';

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
    PaginaConfiguracoes()

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("UFSCar Planner"),
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.redAccent,
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
          BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              title: Text("Configurações")
          ),
        ],
      ),
    );
  }
}
