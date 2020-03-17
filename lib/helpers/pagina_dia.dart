import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
class PaginaDia extends StatefulWidget {
  @override
  _PaginaDiaState createState() => _PaginaDiaState();
}

class _PaginaDiaState extends State<PaginaDia> {

  User user = new User();
  List<Materia> tarefas = List<Materia>();
  @override
  void initState() {
    super.initState();

    _AgendarTarefas();
  }



  _AgendarTarefas(){
    //TODO FAZER ESSE TRECO
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("Página da agenda2"),
      //TODO FAZER NAVIGATION BAR DA SEMANA
      //TODO FAZER A ORGANIZAÇÃO DE HORARIOS
      //TODO CARREGAR DADOS DE B,SE EXISTENTES
    );
  }
}
