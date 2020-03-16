import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String userDataFilename = "userdata.json";

class User {
  String nome;
  String ira;
  String ra;
  List< Map<String, String> > materias;

  String _toJson() => {"Nome": this.nome, "IRA": this.ira, "RA": this.ra, "Materias": this.materias.toString()}.toString();
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