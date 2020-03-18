import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:intl/intl.dart';

const String userDataFilename = "userdata.json";

class User {
  String nome;
  String ira;
  String ra;
  String senha;
  List<Map<String, String>> materias;

  String toJson() => {
        "Nome": this.nome,
        "IRA": this.ira,
        "RA": this.ra,
        "Materias": this.materias.toString()
      }.toString();

  List<List<Materia>> agendamento() {
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
    DateTime today = DateTime.now();
    String f = new DateFormat('EEEE').format(today);

    List<List<Materia>> list =  [new List<Materia>(),new List<Materia>(),new List<Materia>(),new List<Materia>()
      ,new List<Materia>(),new List<Materia>(),new List<Materia>() ];

    for(int i=0;i<aux.length;i++) {
      list[ y.indexOf(aux[i].dia)- x.indexOf(f)<0? y.indexOf(aux[i].dia)- x.indexOf(f)+7: y.indexOf(aux[i].dia)- x.indexOf(f)].add(aux[i]);

      // print(aux[i].toString());
    }

    print(list.toString());


    return list;
  }
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
