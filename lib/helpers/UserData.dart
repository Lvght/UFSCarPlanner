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

  static final User _instance = User.internal();

  String nome;
  String ira;
  String ra;
  String senha;

  // Define os construtores
  User.internal();
  User.completeInit(this.nome, this.ira, this.ra, this.senha, this.materias);

  List<Map<String, String>> materias;


  @override
  String toString() =>
  "Instance of user\n"
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

  Map toMap() {
    return {
      nameField: this.nome,
      iraField: this.ira,
      raField: this.ra,
      passwordField: this.senha,
      subjectsField: this.materias.toString()
    };
  }

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
        output += splittedString[i].substring(0, 1).toUpperCase() + splittedString[i].substring(1) + " ";
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

  /*
   * Corrige os dados das matérias.
   * Este método recebe uma string única com "dados sujos" (mal-formatados)
   * e então os corrige, passando-os para o formato adequado.
   */
  List<Map<String, String>> subjectParser(String raw) {

    /*
     * Aviso /!\
     * Note que as variáveis nomeadas com 'raw' representam "dados sujos".
     * Para entender o processamento que está sendo feito com elas, é preciso
     * olhar os "dados sujos". Use funções de print caso isso se faça necessário.
     */

    List< Map<String, String> > output = List();
    final int totalDeMaterias = RegExp("\\{(.*?)\\}").allMatches(raw).length;
    int ocorrenciaDaMateria;

    Map<String, String> materia;
    List<String> rawMateria = raw.split("}");
    List<String> rawOcorrenciasDasMaterias = List();
    List<String> listaDeDiasDaSemana = List();
    List<String> listaDeHorariosInicio = List();
    List<String> listaDeHorariosTermino = List();
    List<String> listaDeLocais = List();

    for (int i = 0; i < totalDeMaterias; i++) {
      // Reinicia a matéria
      materia = Map();

      // Separa as propriedades repetíveis
      rawOcorrenciasDasMaterias = rawMateria[i].split("Dias/Horarios: ")[1].split(", Ministrantes:")[0].split(")");

      materia[codigoMateria] = rawMateria[i].split(" - ")[0].split("Aula: ")[1];
      materia[nomeMateria] = _stringDecapitalizer(rawMateria[i].split(" - ")[1].split(",")[0]);
      materia[turmaMateria] = rawMateria[i].split("Turma: ")[1].split(",")[0];
      materia[diaMateria] = rawMateria[i].split("Dias/Horarios: ")[1].split(", Ministrantes:")[0];

      ocorrenciaDaMateria = RegExp("(.*?)\\,").allMatches(rawOcorrenciasDasMaterias.toString()).length;

      /*
       * Algumas matérias se repetem em mais de um dia da semana. O Loop abaixo
       * monta listas com as propriedades que se repetem:
       * - Dias da semana
       * - Horários de início
       * - Horários de término
       * - Local
       */
      for (int j = 0; j < ocorrenciaDaMateria; j++) {
        listaDeDiasDaSemana
            .add(rawOcorrenciasDasMaterias[j].split(".")[0]);

        listaDeHorariosInicio
            .add(rawOcorrenciasDasMaterias[j].split(". ")[1].split(" às ")[0]);

        listaDeHorariosTermino
            .add(rawOcorrenciasDasMaterias[j].split(" às ")[1].split(" (")[0]);

        listaDeLocais
            .add(rawOcorrenciasDasMaterias[j].substring(rawOcorrenciasDasMaterias[j].toString().indexOf("(")).replaceAll("(", ""));
      }

      /*
       * As propriedades são convertidas novamente para String, a fim de
       * satisfazer o formato especificado para o arquivo em *decisão de projeto*.
       *
       * Todavia, decodificar estes dados posteriormente é trivial.
       */
      materia[diaMateria] = listaDeDiasDaSemana.toString();
      materia[horaInicioMateria] = listaDeHorariosInicio.toString();
      materia[horaTerminoMateria] = listaDeHorariosTermino.toString();
      materia[localMateria] = listaDeLocais.toString();

      // Reinicia as listas
      listaDeDiasDaSemana = List();
      listaDeHorariosInicio = List();
      listaDeHorariosTermino = List();
      listaDeLocais = List();

      // Adiciona a matéria à lista de resultados
      output.add(materia);

      // Descomente as linhas abaixo se for preciso depurar
//      debugPrint("Código da matéria    = ${materia[codigoMateria]}");
//      debugPrint("Nome da matéria      = ${materia[nomeMateria]}");
//      debugPrint("Turma da matéria     = ${materia[turmaMateria]}");
//      debugPrint("Dias da matéria      = ${materia[diaMateria]}");
//      debugPrint("Horários de início   = ${materia[horaInicioMateria]}");
//      debugPrint("Horários de término  = ${materia[horaTerminoMateria]}");
//      debugPrint("Locais               = ${materia[localMateria]}");
//      debugPrint("\n--------------------------\n\n");

    }

    debugPrint(output.toString());
    return output;
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
      final String rawMaterias = json.encode(jsonEncodedData[subjectsField]).replaceAll("\\n", "");

      output = User.completeInit(jsonEncodedData[nameField], jsonEncodedData[iraField], jsonEncodedData[raField], jsonEncodedData[passwordField], subjectParser(rawMaterias));

      return output;

    } catch(e) {
      return null;
    }
  }


}
