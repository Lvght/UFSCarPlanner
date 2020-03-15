import 'dart:io';
import 'package:path_provider/path_provider.dart';

const String userDataFilename = "userdata.json";

class User {
  String _nome;
  String _ira;
  String _ra;
  List<String> _materias;

  String _toJson() => {"Nome": this._nome, "IRA": this._ira, "RA": this._ra, "Materias": this._materias.toString()}.toString();
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