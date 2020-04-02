import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/constants.dart';

part 'meal.g.dart';

@HiveType(typeId: mealTypeId)
class Meal {
  
  @HiveField(0)
  String day;

  @HiveField(1)
  String date;
  
  @HiveField(2)
  String type;

  @HiveField(3)
  List<String> lista;

  Meal(this.date, this.day, this.type, this.lista);
  Meal.internal();
  @override
  String toString() {
    String listagem = "";
    for (int i = 0; i < lista.length; i++) listagem += lista[i] + '\n';
    return this.date + "\n" + this.day + "\n" + this.type + "\n" + listagem;
  }

}