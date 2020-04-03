import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ufscarplanner/models/materia.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:ufscarplanner/models/user.dart';

class MateriaEditor extends StatefulWidget {
  @override
  _MateriaEditorState createState() => _MateriaEditorState(materia);

  MateriaEditor({Materia materia = null}) {
    this.materia = materia;
  }

  Materia materia;
}

class _MateriaEditorState extends State<MateriaEditor> {
  InputDecoration _getInputDecoration(String labelText) => InputDecoration(
        hintText: labelText,
      );
  Materia materia;
  UserHelper _userHelper = UserHelper();
  User _currentUser;
  List<List<Materia>> materias;

  _MateriaEditorState(Materia this.materia);

  final TextEditingController codigoTextController = TextEditingController();
  final TextEditingController nomeTextController = TextEditingController();
  final TextEditingController turmaTextController = TextEditingController();
  final TextEditingController localTextController = TextEditingController();
  final TextEditingController ministrantesTextController = TextEditingController();
  String horaI, horaF;
  List<String> _diasDaSemana = [
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom",
  ];

  Future<void> initUser() async {
    await _userHelper.readUser().then((value) {
      _currentUser = value;
      if (_currentUser == null) {
        _currentUser = new User.internal();
        _currentUser.mat = new List<List<Materia>>();
      }
      materias = new List<List<Materia>>();
      materias.addAll( _currentUser.mat);
      if (materia != null) {
        for(int i=0 ;i< materias[_diasDaSemana.indexOf(materia.dia)].length ;i++ )
          if(materia.compare(materias[_diasDaSemana.indexOf(materia.dia)][i])) {
            materias[_diasDaSemana.indexOf(materia.dia)].removeAt(i);

          }


        codigoTextController.text = materia.codigo;
        nomeTextController.text = materia.nome;
        turmaTextController.text = materia.turma;
        localTextController.text = materia.local;

        ministrantesTextController.text = materia.ministrantes;
        //TODO PRECARREGAMENTO DAS VARIAVEIS DO DROPDOWNLIST
        /*
        _chosenValue = materia.dia;
        horaI=(materia.horaI);
        horaF=(materia.horaF);
        */
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();

  }

  List<String> getInitHour(String dia) {
    List<String> listaDeHoras = new List<String>();
    if (dia != null) {
      int diaDaSemana = _diasDaSemana.indexOf(dia);
      for (int iterador = 0; iterador < materias[diaDaSemana].length; iterador++) {
        for (int hora = 0; hora < 24; hora++) {
          for (int minuto = 0; minuto < 60; minuto += 15) {
            if (materias[diaDaSemana][iterador].hI() > 100 * hora + minuto) {
              if (iterador == 0) {
                if (!listaDeHoras.contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')))
                  listaDeHoras.add((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')));
              } else {
                if (materias[diaDaSemana][iterador - 1].hF() <= 100 * hora + minuto) {
                  if (!listaDeHoras.contains((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'))))
                    listaDeHoras.add((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')));
                } else {
                  hora++;
                }
              }
            } else {
              hora++;
            }
          }
        }
        if (iterador == materias[diaDaSemana].length - 1) {
          for (int hora = materias[diaDaSemana][iterador].hF() ~/ 100; hora < 24; hora++) {
            for (int minuto = hora == materias[diaDaSemana][iterador].hF() ~/ 100 ? materias[diaDaSemana][iterador].hF() % 100 : 0;
                minuto < 60;
                minuto += 15) {
              if (!listaDeHoras.contains((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'))))
                listaDeHoras.add((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')));
            }
          }
        }
      }
      if (0 == materias[diaDaSemana].length) {
        for (int hora = 0; hora < 24; hora++) {
          for (int minuto = 0; minuto < (60); minuto += 15) {
            if (!listaDeHoras.contains((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'))))
              listaDeHoras.add((hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')));
          }
        }
      }
    }
    return listaDeHoras;
  }

  List<String> getEndHour(String dia, int horaI) {
    List<String> mapa = new List<String>();
    if (dia != null && horaI != null) {
      int diaDaSemana = _diasDaSemana.indexOf(dia);
      for (int iterador = 0; iterador < materias[diaDaSemana].length; iterador++) {
        if (iterador == 0) {
          if (horaI < materias[diaDaSemana][iterador].hI()) {
            //adicionar horas na lista
            for (int hora = horaI ~/ 100; hora <= materias[diaDaSemana][iterador].hI() ~/ 100; hora++) {
              for (int minuto = (hora == horaI ~/ 100 ? horaI % 100 : 0);
                  minuto <= (hora == materias[diaDaSemana][iterador].hI() ~/ 100 ? materias[diaDaSemana][iterador].hI() % 100 : 59);
                  minuto += 15) {
                if (hora * 100 + minuto <= materias[diaDaSemana][iterador].hI()) if (!mapa
                    .contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')))
                  mapa.add(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'));
              }
            }
          }
        } else if (horaI < materias[diaDaSemana][iterador].hI() && horaI >= materias[diaDaSemana][iterador - 1].hF()) {
          //adicionar horas na lista
          for (int hora = horaI ~/ 100; hora < 24; hora++) {
            for (int minuto = (hora == horaI ~/ 100 ? horaI % 100 : 0);
                minuto <= (hora == materias[diaDaSemana][iterador].hI() ~/ 100 ? materias[diaDaSemana][iterador].hI() % 100 : 59);
                minuto += 15) {
              if (iterador < materias[diaDaSemana].length) {
                if (hora * 100 + minuto <= materias[diaDaSemana][iterador].hI()) if (!mapa
                    .contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')))
                  mapa.add(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'));
              } else {
                //se for o último
                //if()
                if (!mapa.contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')))
                  mapa.add(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'));
              }
            }
          }
        }
        if (iterador == materias[diaDaSemana].length - 1) {
          if (horaI >= materias[diaDaSemana][iterador].hF()) {
            for (int hora = horaI ~/ 100; hora < 25; hora++) {
              if (hora != 24) {
                for (int minuto = horaI % 100; minuto < 60; minuto += 15) {
                  if (!mapa.contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')) && hora * 100 + minuto > horaI)
                    mapa.add(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'));
                }
              } else {
                if (!mapa.contains("00:00")) mapa.add("00:00");
              }
            }
          }
        }
      }
      if (0 == materias[diaDaSemana].length) {
        for (int hora = horaI ~/ 100; hora < 24; hora++) {
          for (int minuto = (hora == horaI ~/ 100 ? horaI % 100 : 0); minuto < (60); minuto += 15) {
            if (!mapa.contains(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0')))
              mapa.add(hora.toString().padLeft(2, '0') + ":" + minuto.toString().padLeft(2, '0'));
          }
        }
      }
    }
    return mapa;
  }

  List<int> getIndices(Map<int, List<int>> map) {
    List<int> list = new List<int>();
    for (int i = 0; i < 24; i++) {
      if (map[i] != null) if ((map[i].length > 0)) list.add(i);
    }
    return list;
  }

  String _chosenValue;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[materia!=null?Row(
                    children: <Widget>[Text("Informações antigas :  ${materia.dia} das ${materia.horaI} às ${materia.horaF}")],
                  ):Text(""),
                    Row(
                      children: <Widget>[
                        DropdownButton<String>(
                          value: _chosenValue,
                          items: _diasDaSemana.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (String value) {
                            setState(() {

                              _chosenValue = value;
                              if(!getInitHour(_chosenValue).contains(horaI));
                              horaI = null;
                              if( horaI==null){
                              horaF = null;
                              }else{
                                if(!getEndHour(_chosenValue, int.parse(horaI.split(":")[0]) * 100 + int.parse(horaI.split(":")[1])).contains(horaF))
                                  horaF=null;
                              }
                            });
                          },
                        ),
                        Text(" Horário: "),
                        _chosenValue != null
                            ? DropdownButton<String>(
                                value: horaI,
                                items: getInitHour(_chosenValue).map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    horaI = value;
                                    if( horaI==null){
                                      horaF = null;
                                    }else{
                                      if(!getEndHour(_chosenValue, int.parse(horaI.split(":")[0]) * 100 + int.parse(horaI.split(":")[1])).contains(horaF))
                                        horaF=null;
                                    }
                                  });
                                },
                              )
                            : Text(""),horaI != null?Text(" às "):Text(""),
                        horaI != null
                            ? DropdownButton<String>(
                                value: horaF,
                                items: getEndHour(_chosenValue, int.parse(horaI.split(":")[0]) * 100 + int.parse(horaI.split(":")[1]))
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String value) {
                                  setState(() {
                                    horaF = value;
                                  });
                                },
                              )
                            : Text(""),
                      ],
                    ),
                    TextFormField(
                      validator: (str) => str.isEmpty ? "Insira o Código da Matéria" : null,
                      decoration: _getInputDecoration('Código'),
                      controller: codigoTextController,
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      validator: (str) => str.isEmpty ? "Insira o Nome da Matéria" : null,
                      decoration: _getInputDecoration('Nome'),
                      controller: nomeTextController,
                    ),
                    TextFormField(
                      validator: (str) => str.isEmpty ? "Insira a turma" : null,
                      decoration: _getInputDecoration('Turma'),
                      controller: turmaTextController,
                    ),
                    TextFormField(
                      validator: (str) => str.isEmpty ? "Insira o local" : null,
                      decoration: _getInputDecoration('Local'),
                      controller: localTextController,
                    ),
                    TextField(
                      maxLines: 8,
                      decoration: InputDecoration.collapsed(hintText: "Insira os nomes dos ministrantes"),
                      controller: ministrantesTextController,
                    ),
                    RaisedButton(
                      child: Text("Ok"),
                      onPressed: () async{
                        Materia newMateria = new Materia.another(codigoTextController.text, nomeTextController.text, _chosenValue, horaI, horaF,
                            turmaTextController.text, ministrantesTextController.text, localTextController.text);
                       // print((materia != null).toString()+"   "+_currentUser.mat[_diasDaSemana.indexOf(materia.dia)].toString());
                        if (materia != null) {
                          for(int i=0 ;i< _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].length ;i++ )
                            if(materia.compare(_currentUser.mat[_diasDaSemana.indexOf(materia.dia)][i]))
                              _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].removeAt(i);
                        }

                        _currentUser.mat[_diasDaSemana.indexOf(newMateria.dia)].add(newMateria);
                        _currentUser.mat[_diasDaSemana.indexOf(newMateria.dia)].sort((a,b){
                          return a.hI() > b.hI()?1:0;
                        });
                        _currentUser.UpdateSubjectMap();
                        _userHelper.saveUser(_currentUser);
                        setState(() {
                          _chosenValue = null;
                          horaI = null;
                          horaF = null;
                          while (Navigator.canPop(context)) Navigator.pop(context);
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));

                      });

                      },
                    ),
                    RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        if (materia != null) {

                          for (int i = 0; i < _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].length; i++)
                            if (materia.compare(_currentUser.mat[_diasDaSemana.indexOf(materia.dia)][i]))
                              _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].removeAt(i);
                          _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].add(materia);
                          _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].sort((a, b) {
                            return a.hI() > b.hI() ? 1 : 0;
                          });
                          _currentUser.UpdateSubjectMap();
                          _userHelper.saveUser(_currentUser);
                        }
                        while (Navigator.canPop(context)) Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                      },
                    )
                  ],
                ))),
      ),
    );
  }
}
