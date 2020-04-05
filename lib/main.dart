import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:ufscarplanner/models/user.dart';
import 'package:ufscarplanner/models/materia.dart';
import 'package:ufscarplanner/models/meal.dart';
import 'package:ufscarplanner/ui/pagina_game.dart';

void main() async {
  MyGame().widget;
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(MateriaAdapter());
  Hive.registerAdapter(UserAdapter());
  Hive.openBox("news");
  Hive.openBox("meals");
  Hive.openBox("user");
  Hive.openBox('preferences');

  runApp(UfscarApp());
}

class UfscarApp extends StatefulWidget {
  @override
  _UfscarAppState createState() => _UfscarAppState();
}

class _UfscarAppState extends State<UfscarApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primaryColor: Colors.red,
          iconTheme: IconThemeData(
            color: Colors.red,
          ),
          bottomAppBarTheme: BottomAppBarTheme(
            color: Colors.pink,
          ),
          bottomAppBarColor: Colors.greenAccent),
      home: HomePage(),
    );
  }
}
