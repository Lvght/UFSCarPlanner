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

  @override
  String toString() {
    String listagem = "";
    for (int i = 0; i < lista.length; i++) listagem += lista[i] + '\n';
    return this.date + "\n" + this.day + "\n" + this.type + "\n" + listagem;
  }
  factory Meal.fromJson(Map<String, dynamic> json) {
  return new Meal(json['date'],json['day'],json['type'],(jsonDecode(json['lista']) as List<dynamic>).cast<String>());
  }

  Map toJson() => {
  "day":day, "date":date,"type": type,
  "lista": jsonEncode(lista)
  };
}