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

  String toJson() => {"Nome": this.nome, "IRA": this.ira, "RA": this.ra, "Materias": this.materias.toString()}.toString();

  User.fromJson(Map<String, dynamic> json)
      : nome = json['name'],
        ira = json['IRA'],
        ra = json['RA'],
        materias = json['Materias'];

  List<List<Materia>> agendamento() {
    List<Materia> aux = new List<Materia>();
    for (int i = 0; i < this.materias.length; i++) {
      for (int j = 0; j < this.materias[i]["Dias/Horarios"].replaceAll("\n", "").replaceAll(") ", ")").split(")").length - 1; j++) {
        Materia a = Materia(this.materias[i], j);
        aux.add(a);
      }
    }

    aux.sort((Materia A, Materia B) {
      return A.toint() > B.toint() ? 1 : 0;
    });

    var x = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    var y = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];

    List<List<Materia>> list = [
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>()
    ];

    for (int i = 0; i < aux.length; i++) {
      list[y.indexOf(aux[i].dia)].add(aux[i]);
      // print(aux[i].toString());
    }

    MateriaHelper.lista_materias = list;
    MateriaHelper.lista_dias = new List<String>();
    MateriaHelper.lista_dias.addAll(y.sublist(0, 7));
    MateriaHelper.lista_materias.removeAt(MateriaHelper.lista_dias.indexOf("Dom"));
    MateriaHelper.lista_dias.remove("Dom");

    print("\n\n\n\nTEM NET GENTE\n\n\n\n\n");

    saveMateriaHelper();
    return list;
  }


  saveMateriaHelper()async{
    await writeRawData(jsonEncode(MateriaHelper.lista_materias));
    await readMateriaHelper();
  }

  readMateriaHelper()async{

    print("---------------------------cheguei ate aqui-------------------------\n\n\n\n\n");
    await readRawData().then((data) {
      print("---------------------------não é isso-------------------------\n\n\n\n\n");
      var x = json.decode(data);

      print("---------------------------${x.toString()}-------------------------\n\n\n\n\n");
      Map<String, dynamic> a = new Map<String, dynamic>();

      var c = (json.decode(data) as List<dynamic>).toList();
      print("cccccccccccccccccccccccccccccccc${c.toString()}ccccccccccccccccccccccccccccccccc\n\n\n\n");
      MateriaHelper.lista_materias = new List<List<Materia>>();
      for (int i = 0; i < c.length; i++) {
        // String d =json.decode(c[i]);

        listlist d = listlist.fromString(c[i].toString());
        print("ddddddddddddddddddddddddddddddddddd${d.toString()}ddddddddddddddddddddddddddddddddddddddd\n\n\n");
        MateriaHelper.lista_materias.add(d.list);
      }
    });
  }

  String userDataFilename = "Materiadata.json";

  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async => File(await _filePath + "/" + userDataFilename);

  Future<File> writeRawData(String rawData) async {
    final file = await _file;
    return await file.writeAsString(rawData);
  }

  Future<String> readRawData() async {
    try {

      print("---------------------------cheguei aqui-------------------------\n\n\n\n\n");
      final file = await _file;

      print("---------------------------cheguei-------------------------\n\n\n\n\n");
      await file.readAsString().then((s){

        print("chegu "+s);
        return s;
      });
    } catch (e) {
      print(e);
      print("deu ruim amigao");
      return null;
    }
  }
}

class listlist {
  List<Materia> list;
  listlist.fromString(String s){

    list=new List<Materia>();
    if(s.contains("{")){
      for(int i=1;i<s.split("{").length;i++){
       list.add(new Materia.another(

           s.split("{")[i].split("codigo:")[1].split(",")[0].trim(),
           s.split("{")[i].split("nome:")[1].split(",")[0].trim(),
           s.split("{")[i].split("dia:")[1].split(",")[0].trim(),
           s.split("{")[i].split("horaI:")[1].split(",")[0].trim(),
           s.split("{")[i].split("horaF:")[1].split(",")[0].trim(),
           s.split("{")[i].split("turma:")[1].split(",")[0].trim(),
           s.split("{")[i].split("ministrantes:")[1].split(",")[0].trim(),
           s.split("{")[i].split("local:")[1].split("}")[0].trim()));
      }
    }else{

    }
  }
  listlist(List<Materia> this.list);

  factory listlist.fromJson(Map<String, dynamic> json) {
    print("lista codada:${jsonDecode(json['lista']).toString()}");
    return new listlist((jsonDecode(json['lista']) as List<dynamic>).cast<Materia>());
  }

  Map toJson() => {
        "lista": list != null ? list.map((i) => i.toJson()).toList() : null,
      };
}

class UserHelper {
  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _file async => File(await _filePath + "/" + userDataFilename);

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
