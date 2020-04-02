import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/constants.dart';
import 'dart:convert';
part 'materia.g.dart';

@HiveType(typeId: subjectTypeId)
class Materia {

  @HiveField(0)
  String codigo;
  @HiveField(1)
  String nome;
  @HiveField(2)
  String dia;
  @HiveField(3)
  String horaI;
  @HiveField(4)
  String horaF;
  @HiveField(5)
  String turma;
  @HiveField(6)
  String ministrantes;
  @HiveField(7)
  String local;


  Materia.internal();
  Materia(Map<String, String> map, int indiceDia) {
    // mapaDasAulas = {"Aula": "", "Turma": "", "Dias/Horarios": "", "Ministrantes": "", "Operacoes": ""};
    this.codigo = map["Aula"].split("-")[0].replaceAll(' ', '');
    this.nome = map["Aula"].split("- ")[1].replaceAll("\n", "");
    this.turma = map["Turma"].replaceAll("\n", "").replaceAll(" ", "");
    this.ministrantes = map["Ministrantes"];
    var aux = map["Dias/Horarios"].split(")")[indiceDia] + ")";
    this.dia = aux.split(".")[0].replaceAll(" ", "").replaceAll("\n", "");
    this.horaI = aux
        .split(".")[1]
        .split(" às ")[0]
        .replaceAll(" ", "")
        .replaceAll("\n", "");
    this.horaF = aux
        .split(" às ")[1]
        .split(" (")[0]
        .replaceAll(" ", "")
        .replaceAll("\n", "");
    this.local = aux.split("(")[1].split(")")[0].replaceAll("\n", "");
  }

  Materia.another(this.codigo, this.nome, this.dia, this.horaI, this.horaF,
      this.turma, this.ministrantes, this.local);


  bool compare(Materia other){
    return codigo == other.codigo &&other.nome== nome && dia==other.dia && other.horaI==horaI &&
        other.horaF== horaF &&other.turma== turma && other.ministrantes ==ministrantes &&other.local== local;
  }

  factory Materia.fromJson(Map<String, dynamic> json) {
    return new Materia.another(
        json["codigo"],
        json["nome"],
        json["dia"],
        json["horaI"],
        json["horaF"],
        json["turma"],
        json["ministrantes"],
        json["local"]);
  }

  Map toJson() => {
        "codigo": codigo,
        "nome": nome,
        "dia": dia,
        "horaI": horaI,
        "horaF": horaF,
        "turma": turma,
        "ministrantes": ministrantes,
        "local": local
      };

  int toint() {
    var x = [
      "Sunday",
      "Monday",
      "Tuesday",
      "Wednesday",
      "Thursday",
      "Friday",
      "Saturday"
    ];
    var y = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];
    return (y.indexOf(this.dia.replaceAll(" ", ""))) * 10000 +
        int.parse(this.horaI.split(":")[0]) * 100 +
        int.parse(this.horaI.split(":")[1]);
  }

  int hI() {
    return int.parse(this.horaI.split(":")[0]) * 100 +
        int.parse(this.horaI.split(":")[1]);
  }

  int hF() {
    return int.parse(this.horaF.split(":")[0]) * 100 +
        int.parse(this.horaF.split(":")[1]);
  }

  @override
  String toString() {
    return
      "Instance of 'Materia'\n"
      "codigo: $codigo\n"
      "nome: $nome\n"
      "turma: $turma\n"
      "dia: $dia\n"
      "ministrantes: $ministrantes\n"
      "horaI: $horaI\n"
      "horaF: $horaF\n"
      "local: $local\n";
  }
}
