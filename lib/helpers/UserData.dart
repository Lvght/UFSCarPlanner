import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:intl/intl.dart';
import 'package:ufscarplanner/ui/pagina_agenda.dart';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'package:async/async.dart';

/*
 * As string abaixo são definidas como constantes para evitar problemas
 * envolvendo erros de digitação.
 */
const String userDataFilename = "userdata.json";
const String nameField = "Nome";
const String iraField = "IRA";
const String raField = "RA";
const String passwordField = "Senha";
const String subjectsField = "Materias";

/*
 * Estas outras servem para o mapa das matérias
 */
const String codigoMateria = "codigo";
const String nomeMateria = "nome";
const String diaMateria = "dia";
const String horaInicioMateria = "horaI";
const String horaTerminoMateria = "horaF";
const String turmaMateria = "turma";
const String ministrantesMateria = "ministrantes";
const String localMateria = "local";

class User {

  String nome;
  String ira;
  String ra;
  String senha;

  // Define os construtores
  User.internal();

  User.completeInit(this.nome, this.ira, this.ra, this.senha, this.mat);

  List<Map<String, String>> materias;
  List<List<Materia>> mat;

  @override
  String toString() => "Instance of user\n"
      "Nome:     $nome\n"
      "IRA:      $ira\n"
      "RA:       $ra\n"
      "Materias: ${materias.toString()}\n";

  String toJson() => {
        "Nome": this.nome,
        "IRA": this.ira,
        "RA": this.ra,
        "Materias": this.materias.toString()
      }.toString();
  void UpdateSubjectMap(){
    List<Map<String,String>> novaLista = new List<Map<String,String>>();
    for(int i=0;i<this.mat.length;i++){
      for(int j =0;j<this.mat[i].length;j++) {
        Materia newMat =this.mat[i][j];
        Map<String, String> aux = {
          "Aula": newMat.codigo+" - "+newMat.nome,
          "Turma":newMat.turma,
          "Dias/Horarios": newMat.dia+". "+newMat.horaI+" às "+newMat.horaF +" ("+newMat.local+")",
          "Ministrantes": newMat.ministrantes,
          "Operacoes":""
        };
        novaLista.add(aux);
      }
    }
    this.materias = novaLista;
  }
  Map toMap() {
    return {
      nameField: this.nome,
      iraField: this.ira,
      raField: this.ra,
      passwordField: this.senha,
      subjectsField: this.materias.toString()
    };
  }

  List<Materia> _stringToMateria() {
    Map m = json.decode(this.materias.toString());
    List<Materia> output = List();

    print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa");

    return output;
  }

  void agendamento() {

    print("Ponto AA");

//    List<Materia> listaDeMaterias = _stringToMateria();
    List<Materia> listaDeMaterias = List();

    listaDeMaterias
        .sort((Materia A, Materia B) => A.toint() > B.toint() ? 1 : 0);

    List<String> weekDays = ["Dom", "Seg", "Ter", "Qua", "Qui", "Sex", "Sab"];

    List<List<Materia>> listaDeMateriasPorDiaDaSemana = [
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>()
    ];

    print("Ponto A1");

    // Povoa a lista de matérias por dia da semana
    for (int i = 0; i < listaDeMaterias.length; i++)
      listaDeMateriasPorDiaDaSemana[weekDays.indexOf(listaDeMaterias[i].dia)]
          .add(listaDeMaterias[i]);

    print("Ponto A2");

    MateriaHelper.lista_materias = listaDeMateriasPorDiaDaSemana;
    MateriaHelper.lista_dias = new List<String>();
    MateriaHelper.lista_dias.addAll(weekDays.sublist(0, 7));
    MateriaHelper.lista_materias
        .removeAt(MateriaHelper.lista_dias.indexOf("Dom"));
    MateriaHelper.lista_dias.remove("Dom");
  }

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

class listlist {
  List<Materia> list;

  listlist(List<Materia> this.list);

  factory listlist.fromJson(Map<String, dynamic> json) {
    return new listlist(
        (jsonDecode(json['lista']) as List<dynamic>).cast<Materia>());
  }

  Map toJson() => {"lista": jsonEncode(list)};
}

class UserHelper {
  /*
   * Retorna uma string com apenas as primeiras letras maiúsculas.
   * A função não irá capitalizar palavras com 2 caracteres ou menos (i.e: "De", "E", Etc.)
   */
  String _stringDecapitalizer(String str) {
    List<String> splittedString = str.toLowerCase().split(" ");
    String output = "";

    // Coloca apenas a primeira letra como maiúscula e copia o resto
    for (int i = 0; i < splittedString.length; i++) {
      if (splittedString[i].length > 3)
        output += splittedString[i].substring(0, 1).toUpperCase() +
            splittedString[i].substring(1) +
            " ";
      else
        output += splittedString[i] + " ";
    }

    // Remove o espaço desnecessário do final
    output = output.substring(0, output.length - 1);

    return output;
  }

  Future<File> get _file async {
    var directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/$userDataFilename");
  }

  Future<void> deleteFile() async {
    File file = await _file;
    file.delete();
  }

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

  /*
   * Salva os dados do usuário como uma string codificada em JSON.
   * Retorna [TRUE] se a operação for bem-sucedida
   * Retorna [FALSE], caso contrário.
   */
  Future<bool> saveUser(User user) async {

    String jsonEncodedData = json.encode(user.toMap());
    final file = await _file;
    return await file.writeAsString(jsonEncodedData) == null;
  }

  int _weekDecode(String s) {
    switch (s.toLowerCase()) {
      case "seg": return 0;
      case "ter": return 1;
      case "qua": return 2;
      case "qui": return 3;
      case "sex": return 4;
      case "sab":
      case "sáb": return 5;
      default:    return 6;
    }
  }

  /*
   * Corrige os dados das matérias.
   * Este método recebe uma string única com "dados sujos" (mal-formatados)
   * e então os corrige, passando-os para o formato adequado.
   */
  List< List<Materia> > subjectParser(String raw) {
    /*
     * Aviso /!\
     * Note que as variáveis nomeadas com 'raw' representam "dados sujos".
     * Para entender o processamento que está sendo feito com elas, é preciso
     * olhar os "dados sujos". Use funções de print caso isso se faça necessário.
     */

    // Uma lista para cada dia da semana
    List< List<Materia> > outList = [
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
      new List<Materia>(),
    ];

    List<Map<String, String>> output = List();
    final int totalDeMaterias = RegExp("\\{(.*?)\\}").allMatches(raw.replaceAll("\\n", "")).length;
    int ocorrenciaDaMateria;

    Materia materia = Materia.internal();
    List<String> rawMateria = raw.split("}");
    List<String> rawOcorrenciasDasMaterias = List();

    for (int i = 0; i < totalDeMaterias; i++) {

      // Reinicia a matéria
      materia = Materia.internal();

      // Separa as propriedades repetíveis
      rawOcorrenciasDasMaterias = rawMateria[i]
          .split("Dias/Horarios: ")[1]
          .split(", Ministrantes:")[0]
          .split(")");

      ocorrenciaDaMateria = RegExp("(.*?)\\,")
          .allMatches(rawOcorrenciasDasMaterias.toString())
          .length;

      // Algumas matérias se repetem em mais de um dia da semana.
      for (int j = 0; j < ocorrenciaDaMateria; j++) {
        materia = Materia.internal();

        materia.codigo = rawMateria[i].replaceAll("\\n", "").split(" - ")[0].split("Aula: ")[1];
        materia.nome = _stringDecapitalizer(rawMateria[i].replaceAll("\\n", "").split(" - ")[1].split(",")[0]);
        materia.turma = rawMateria[i].split("Turma: ")[1].replaceAll("\\n", "").split(",")[0];
        materia.ministrantes = rawMateria[i].split("Ministrantes: ")[1].replaceAll("\\n", "\n").split(",")[0].trim();

        materia.dia = rawOcorrenciasDasMaterias[j].replaceAll("\\n", "").split(".")[0];
        materia.horaI = rawOcorrenciasDasMaterias[j].replaceAll("\\n", "").split(". ")[1].split(" às ")[0];
        materia.horaF = rawOcorrenciasDasMaterias[j].replaceAll("\\n", "").split(" às ")[1].split(" (")[0];

        // Normaliza o tamanho dos horários
        if (materia.horaI.length < 5)
          materia.horaI = "0" + materia.horaI;
        if (materia.horaF.length < 5)
          materia.horaF = "0" + materia.horaI;

        materia.local = rawOcorrenciasDasMaterias[j]
            .substring(rawOcorrenciasDasMaterias[j].toString().indexOf("("))
            .replaceAll("(", "");

        // Insere na lista, no índice adequado ao dia da semana
        outList[_weekDecode(materia.dia)].add(materia);
      }
    }

    // Faz a ordenação da lista
    for (int i = 0; i < outList.length; i++) {
      outList[i].sort( (a, b) {
        return int.parse(a.horaI.substring(0, 2)) > int.parse(b.horaI.substring(0, 2)) ? 1 : 0;
      } );
    }

    return outList;
  }

  /*
   * Lê os dados do usuário a partir do arquivo de dados.
   * Retorna [null] caso seja encontrado algum erro.
   */
  Future<User> readUser() async {
    User output;

    try {
      final file = await _file;
      if (file == null) return null;

      String rawDataFromFile = await file.readAsString();

      final jsonEncodedData = json.decode(rawDataFromFile);

      final String rawMaterias =
          json.encode(jsonEncodedData[subjectsField]);

      output = User.completeInit(
          jsonEncodedData[nameField],
          jsonEncodedData[iraField],
          jsonEncodedData[raField],
          jsonEncodedData[passwordField],
          subjectParser(rawMaterias));

      return output;
    } catch (e) {
      return null;
    }
  }
}
