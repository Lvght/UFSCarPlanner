import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';

void main() async {

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
