import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/constants.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:ufscarplanner/models/meal.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MealAdapter());
  final newsBox = Hive.openBox("news");
  final mealsBox = Hive.openBox("meals");
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
