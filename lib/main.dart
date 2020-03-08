import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';

void main() async {

  DataScrapper d = DataScrapper("https://www2.ufscar.br/restaurantes-universitario/cardapio");

  print("1teste");
  await d.initiate();
  print("teste");

  /*runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  )); */
}
