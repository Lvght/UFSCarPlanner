import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:ufscarplanner/helpers/themes.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:ufscarplanner/models/user.dart';
import 'package:ufscarplanner/models/materia.dart';
import 'package:ufscarplanner/models/meal.dart';
import 'package:ufscarplanner/ui/pagina_game.dart';

void main() async {
  MyGame();
  WidgetsFlutterBinding.ensureInitialized();
  final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter(MealAdapter());
  Hive.registerAdapter(MateriaAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox("news");
  await Hive.openBox("meals");
  await Hive.openBox("user");
  await Hive.openBox('preferences');
  await Hive.openBox("gameConfig");

  runApp(UfscarApp());
}

class UfscarApp extends StatefulWidget {
  @override
  _UfscarAppState createState() => _UfscarAppState();
}

class _UfscarAppState extends State<UfscarApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: Hive.box('preferences').listenable(),
      builder: (context, box, widget) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: Hive.box('preferences').get('darkMode', defaultValue: false) as bool
              ? buildDarkTheme()
              : buildLightTheme(),
          home: HomePage(),
        );
      },
    );
  }
}
