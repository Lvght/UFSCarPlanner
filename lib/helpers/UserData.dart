import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

const String userDataFilename = "userdata.json";

class User {
  String nome;
  String ira;
  String ra;
  List<Map<String, String>> materias;

  String _toJson() => {
        "Nome": this.nome,
        "IRA": this.ira,
        "RA": this.ra,
        "Materias": this.materias.toString()
      }.toString();

  Map<String,List<Materia>> agendamento(User user) {
    List<Materia> aux = new List<Materia>();
    for (int i = 0; i < user.materias.length; i++) {
      for (int j = 0;
          j <
              user.materias[i]["Dias/Horarios"]
                      .replaceAll("\n", "")
                      .replaceAll(") ", ")")
                      .split(")")
                      .length -
                  1;
          j++) {
        Materia a = Materia(user.materias[i], j);
        aux.add(a);
      }
    }
    aux.sort((Materia A,Materia B){
        return   A.toint()>B.toint()?1:0;
    });

    Map<String,List<Materia>> map = {"Dom":new List<Materia>(), "Seg": new List<Materia>(), "Ter": new List<Materia>(),
      "Qua": new List<Materia>(), "Qui": new List<Materia>(), "Sex": new List<Materia>(), "Sab": new List<Materia>()};
    for(int i=0;i<aux.length;i++)
      map[aux[i].dia].add(aux[i]);

    return map;
  }
}

class Materia {
  Materia(Map<String, String> map, int indiceDia) {
    // mapaDasAulas = {"Aula": "", "Turma": "", "Dias/Horarios": "", "Ministrantes": "", "Operacoes": ""};
    this.codigo = map["Aula"].split("-")[0].replaceAll(' ', '');
    this.nome = map["Aula"].split("- ")[1].replaceAll("\n", "");
    this.turma = map["Turma"].replaceAll("\n", "").replaceAll(" ", "");
    this.ministrantes = map["Ministrantes"];
    var aux = map["Dias/Horarios"].split(")")[indiceDia] + ")";
    this.dia = aux.split(".")[0].replaceAll(" ", "").replaceAll("\n", "");
    this.horaI = aux.split(".")[1].split(" às ")[0].replaceAll(" ", "").replaceAll("\n", "");
    this.horaF = aux.split(" às ")[1].split(" (")[0].replaceAll(" ", "").replaceAll("\n", "");
    this.local = aux.split("(")[1].split(")")[0].replaceAll("\n", "");
  }

  String codigo, nome, dia, horaI, horaF, turma, ministrantes, local;

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
    DateTime today = DateTime.now();
    String f = new DateFormat('EEEE').format(today);
    return  (y.indexOf(this.dia.replaceAll(" ", ""))- x.indexOf(f))*10000+int.parse(this.horaI.split(":")[0]) * 100 +
        int.parse(this.horaI.split(":")[1]);
  }

  @override
  String toString() {
    // TODO: implement toString
    return codigo +
        " - " +
        nome +
        "\n" +
        dia +
        " - " +
        horaI +
        " às " +
        horaF +
        "\nlocal: " +
        local +
        "\n turma " +
        turma +
        "\n ministrantes :\n" +
        ministrantes +
        "\n";
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
