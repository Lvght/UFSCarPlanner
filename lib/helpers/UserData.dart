import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:intl/intl.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:async/async.dart';

const String userDataFilename = "userdata.json";

class User {
  static final User _instance = User.internal();
  String nome;
  String ira;
  String ra;
  String senha;
  User.internal();
  List<Map<String, String>> materias;

  String toJson() => {
        "Nome": this.nome,
        "IRA": this.ira,
        "RA": this.ra,
        "Materias": this.materias.toString()
      }.toString();


  User.fromJson(Map<String, dynamic> json)
      : nome = json['name'],
        ira = json['IRA'],
        ra = json['RA'],
        materias = json['Materias'];


 List<List<Materia>> agendamento(){
    List<Materia> aux = new List<Materia>();
    for (int i = 0; i < this.materias.length; i++) {
      for (int j = 0;
      j <
          this.materias[i]["Dias/Horarios"]
              .replaceAll("\n", "")
              .replaceAll(") ", ")")
              .split(")")
              .length -
              1;
      j++) {
        Materia a = Materia(this.materias[i], j);
        aux.add(a);
      }
    }

    aux.sort((Materia A,Materia B){
      return   A.toint()>B.toint()?1:0;
    });

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


    List<List<Materia>> list =  [new List<Materia>(),new List<Materia>(),new List<Materia>(),new List<Materia>()
      ,new List<Materia>(),new List<Materia>(),new List<Materia>() ];

    for(int i=0;i<aux.length;i++) {
      list[ y.indexOf(aux[i].dia)].add(aux[i]);
      // print(aux[i].toString());
    }

    MateriaHelper.lista_materias=list;
    MateriaHelper.lista_dias = new List<String>();
    MateriaHelper.lista_dias.addAll(y.sublist( 0,7));
    MateriaHelper.lista_materias.removeAt(MateriaHelper.lista_dias.indexOf("Dom"));
    MateriaHelper.lista_dias.remove("Dom");

      print("\n\n\n\nTEM NET GENTE\n\n\n\n\n");
        writeRawData(json.encode( MateriaHelper.lista_materias));
         readRawData().then((data) {
          Iterable l = json.decode(data);
          Map<String, dynamic> a = new Map<String, dynamic>();
          List<listlist> c = l.map(( a)=> listlist.fromJson(a)).toList();
           print("----------------------------------------------------\n\n\n\n\n"+c.toString());
           MateriaHelper.lista_materias = new List<List<Materia>>();
          /* for(int i=0 ;i<c.length;i++)
             MateriaHelper.lista_materias.add(c[i].list);*/
          print(MateriaHelper.lista_materias.toString());
        });


      return list;
  }

  String  userDataFilename = "Materiadata.json";




  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _file async =>
      File(await _filePath + "/" + userDataFilename);

  Future<File> writeRawData(String rawData) async {
    final file = await _file;
    return await file.writeAsString(rawData);
  }
  Future<String> readRawData() async {
    try {
      final file = await _file;
      return await file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }
}

class listlist{
  List<Materia> list;
  listlist(List<Materia> this.list);
  factory listlist.fromJson(Map<String, dynamic> json) {
    return new listlist((jsonDecode(json['lista']) as List<dynamic>).cast<Materia>());
  }

  Map toJson() => {
    "lista": jsonEncode(list)
  };

}

class UserHelper {
  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async =>
      File(await _filePath + "/" + userDataFilename);

  Future<File> writeRawData(String rawData) async {
    final file = await _file;
    return await file.writeAsString(rawData);
  }

  Future<String> readRawData() async {
    try {
      final file = await _file;
      return await file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
  }
}
