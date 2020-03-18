import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
class PaginaAgenda extends StatefulWidget {
  @override
  _PaginaAgendaState createState() => _PaginaAgendaState();
}

DefaultTabController getTabs(context){

  List<Widget> wids=List<Widget>();
  List<List<Widget>> views=List<List<Widget>>();
  List<Widget> columns=List<Widget>();
  for(int i=0;i<MateriaHelper.lista_dias.length;i++){
    wids.add(Text(MateriaHelper.lista_dias[i],style: TextStyle(fontSize: 15,),));
    views.add(new List<Widget>());
    for(int j=0;j<MateriaHelper.lista_materias[i].length;j++){
      views[i].add(Card(color: Colors.white,margin: EdgeInsets.fromLTRB(16,16,16,0),child:Container(width:  MediaQuery.of(context).size.width*0.80,child:Text(MateriaHelper.lista_materias[i][j].toString()))));
    }
    columns.add(Column(children: views[i],));
  }
  return DefaultTabController(length: MateriaHelper.lista_dias.length,child: Scaffold(
    appBar:PreferredSize(
    preferredSize: Size.fromHeight(50.0), // here the desired height
  child:   AppBar(bottom: TabBar(
      tabs:wids,
    ),),),
    body: TabBarView(
      children: columns,
    ),
  ),);
}


class _PaginaAgendaState extends State<PaginaAgenda> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: getTabs(context),
    );
  }
}
