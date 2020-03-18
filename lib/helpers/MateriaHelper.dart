import 'package:intl/intl.dart';

class MateriaHelper{
  static final MateriaHelper _instance = MateriaHelper.internal();
  static List<List<Materia>> lista_materias = new List<List<Materia>>();
  static List<String> lista_dias=new List<String>();
  MateriaHelper.internal();
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
    return  (y.indexOf(this.dia.replaceAll(" ", "")))*10000+int.parse(this.horaI.split(":")[0]) * 100 +
        int.parse(this.horaI.split(":")[1]);
  }
  int hI() {
    return int.parse(this.horaI.split(":")[0]) * 100 +
        int.parse(this.horaI.split(":")[1]);
  }
  int hF(){    return int.parse(this.horaF.split(":")[0]) * 100 +
  int.parse(this.horaF.split(":")[1]);}
  @override
  String toString() {
    // TODO: implement toString
    return codigo +
        " - " +
        nome.trim() +
        "\n" +
        dia.trim() +
        " - " +
        horaI.trim() +
        " às " +
        horaF.trim() +
        "\nlocal: " +
        local.trim() +
        "\nTurma " +
        turma.trim() +
        "\nMinistrantes :\n" +
        ministrantes.trim() +
        "\n";
  }


}
