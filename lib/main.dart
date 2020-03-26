import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';

void main() async {
/*
  DataScrapper d = DataScrapper("https://www2.ufscar.br/restaurantes-universitario/cardapio");
  await d.initiate();
  String pag="";
  for (int i=0;i<d.meals.length;i++){
    pag+=d.meals[i].toString()+"\n\n\n";
  }
  print(pag);
*/
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.red,
      iconTheme: IconThemeData(
        color: Colors.red,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        color: Colors.pink,
      ),
      bottomAppBarColor: Colors.greenAccent
    ),
    home: HomePage(),
  ));


}
