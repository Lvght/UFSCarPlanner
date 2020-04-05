import 'package:ufscarplanner/models/materia.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/constants.dart';
part 'user.g.dart';
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


@HiveType(typeId: userTypeId)
class User {
  @HiveField(0)
  String nome;
  @HiveField(1)
  String ira;
  @HiveField(2)
  String ra;
  @HiveField(3)
  String senha;
  @HiveField(4)
  List<Map<String, String>> materias;
  @HiveField(5)
  List<List<Materia>> mat;

  // Define os construtores
  User.internal();
  User();
  User.completeInit(this.nome, this.ira, this.ra, this.senha, this.mat);

  @override
  String toString() => "Instance of user\n"
      "Nome:     $nome\n"
      "IRA:      $ira\n"
      "RA:       $ra\n"
      "Materias: ${materias.toString()}\n";


  void updateSubjectMap(){
    List<Map<String,String>> novaLista = new List<Map<String,String>>();
    for(int i=0;i<this.mat.length;i++){
      for(int j =0;j<this.mat[i].length;j++) {
        Materia newMat =this.mat[i][j];
        Map<String, String> aux = {
          "Aula": newMat.codigo+" - "+ newMat.nome,
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

  void agendamento() {
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


}
