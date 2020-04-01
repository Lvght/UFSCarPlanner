import 'package:flutter/material.dart';
import 'dart:async';

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/home_page.dart';

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
  final TextEditingController horaITextController = TextEditingController();
  final TextEditingController horaFTextController = TextEditingController();
  final TextEditingController minutoITextController = TextEditingController();
  final TextEditingController minutoFTextController = TextEditingController();
  final TextEditingController ministrantesTextController = TextEditingController();
  int horaI, horaF, minI, minF;
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
      materias = _currentUser.mat;
      if (materia != null) {
        materias[_diasDaSemana.indexOf(materia.dia.trim())].remove(materia);

        codigoTextController.text=materia.codigo;
        nomeTextController.text=materia.nome;
        turmaTextController.text=materia.turma;
        localTextController.text=materia.local;
        horaITextController.text=(materia.hI()~/100).toString();
        horaFTextController.text=(materia.hF()~/100).toString();
        minutoITextController.text=(materia.hI()%100).toString();
        minutoFTextController.text=(materia.hF()%100).toString() ;
        ministrantesTextController.text=materia.ministrantes;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initUser();


  }

  Map<int, List<int>> getInitHour(String dia) {
    Map<int, List<int>> mapa = new Map<int, List<int>>();
    if (dia != null) {
      int diaDaSemana = _diasDaSemana.indexOf(dia);
      for (int iterador = 0; iterador < materias[diaDaSemana].length; iterador++) {
        for (int hora = 0; hora < 24; hora++) {
          for (int minuto = 0; minuto < 60; minuto += 15) {
            if (materias[diaDaSemana][iterador].hI() > 100 * hora + minuto) {
              if (mapa[hora] == null) mapa[hora] = new List<int>();
              if (iterador == 0) {
                if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
              } else {
                if (materias[diaDaSemana][iterador - 1].hF() <= 100 * hora + minuto) {
                  if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
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
              if (mapa[hora] == null) mapa[hora] = new List<int>();
              if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
            }
          }
        }
      }
      if(0==materias[diaDaSemana].length){
        for (int hora =0; hora < 24; hora++) {
          if (mapa[hora] == null) mapa[hora] = new List<int>();
          for (int minuto = 0;minuto<( 60);minuto+=15){
            if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
          }
        }
      }
    }
    return mapa;
  }

  Map<int, List<int>> getEndHour(String dia, int horaI) {
    Map<int, List<int>> mapa = new Map<int, List<int>>();
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
                if (mapa[hora] == null) mapa[hora] = new List<int>();

                if (hora * 100 + minuto <= materias[diaDaSemana][iterador].hI()) if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
              }
            }
          }
        } else if (horaI < materias[diaDaSemana][iterador].hI() && horaI >= materias[diaDaSemana][iterador - 1].hF()) {
          //adicionar horas na lista
          for (int hora = horaI ~/ 100; hora < 24; hora++) {
            if (mapa[hora] == null) mapa[hora] = new List<int>();
            for (int minuto = (hora == horaI ~/ 100 ? horaI % 100 : 0);
            minuto <= (hora == materias[diaDaSemana][iterador].hI() ~/ 100 ? materias[diaDaSemana][iterador].hI() % 100 : 59);
            minuto += 15) {
              if (iterador < materias[diaDaSemana].length) {
                if (hora * 100 + minuto <= materias[diaDaSemana][iterador].hI()) if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
              } else {
                //se for o último
                //if()
                if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
              }
            }
          }
        }
        if(iterador==materias[diaDaSemana].length-1){
          if(horaI>= materias[diaDaSemana][iterador].hF()){
            for (int hora = horaI ~/ 100; hora < 25; hora++) {
              if(hora!=24) {
                if (mapa[hora] == null)
                  mapa[hora] = new List<int>();
                for (int minuto = horaI % 100; minuto < 60; minuto += 15) {
                  if (!mapa[hora].contains(minuto) && hora * 100 + minuto > horaI) mapa[hora].add(minuto);
                }
              }else{
                if (mapa[0] == null)
                  mapa[0] = new List<int>();
                if (!mapa[0].contains(0)) mapa[0].add(0);
              }
            }

          }
        }
      }
      if(0==materias[diaDaSemana].length){
        for (int hora = horaI ~/ 100; hora < 24; hora++) {
          if (mapa[hora] == null) mapa[hora] = new List<int>();
          for (int minuto = (hora == horaI ~/ 100 ? horaI % 100 : 0);minuto<( 60);minuto+=15){
            if (!mapa[hora].contains(minuto)) mapa[hora].add(minuto);
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
                  children: <Widget>[
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
                              horaI = null;
                              minI=null;
                              horaF = null;
                              minF=null;
                              _chosenValue = value;
                            });
                          },
                        ),Text(" Horário: "),
                        _chosenValue != null
                            ? DropdownButton<int>(
                          value: horaI,
                          items: getIndices(getInitHour(_chosenValue)).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int value) {
                            setState(() {
                              minI=null;
                              horaF = null;
                              minF=null;
                              horaI = value;
                            });
                          },
                        )
                            : Text("HH"),Text(":"),
                        horaI != null
                            ? DropdownButton<int>(
                          value: minI,
                          items: getInitHour(_chosenValue)[horaI].map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int value) {
                            setState(() {
                              horaF = null;
                              minF=null;
                              minI = value;
                            });
                          },
                        )
                            : Text("MM"),Text(" às "),
                        minI != null
                            ? DropdownButton<int>(
                          value: horaF,
                          items: getIndices(getEndHour(_chosenValue, horaI * 100 + minI)).map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int value) {
                            setState(() {
                              minF=null;
                              horaF = value;
                            });
                          },
                        )
                            : Text("HH"),Text(":"),
                        horaF != null
                            ? DropdownButton<int>(
                          value: minF,
                          items: getEndHour(_chosenValue, horaI * 100 + minI)[horaF].map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString()),
                            );
                          }).toList(),
                          onChanged: (int value) {
                            setState(() {
                              minF = value;
                            });
                          },
                        )
                            : Text("MM")
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
                      onPressed: () {
                        if(minF!=null) {
                          Materia newMateria = new Materia.another(
                              codigoTextController.text,
                              nomeTextController.text,
                              _chosenValue,
                              horaI.toString().padLeft(2, '0') + ":" + minI.toString().padLeft(2, '0'),
                              horaF.toString().padLeft(2, '0') + ":" + minF.toString().padLeft(2, '0'),
                              turmaTextController.text,
                              ministrantesTextController.text,
                              localTextController.text);

                          print(newMateria.toString());
                          if (materia != null)
                            _currentUser.mat[_diasDaSemana.indexOf(materia.dia)].remove(materia);
                          _currentUser.mat[_diasDaSemana.indexOf(newMateria.dia)].add(newMateria);
                          _currentUser.UpdateSubjectMap();
                          _userHelper.saveUser(_currentUser);
                          String auxSubjectParser =
                          json.encode(_currentUser.materias.toString()).replaceAll("\\n", "");
                          _currentUser.mat = _userHelper.subjectParser(auxSubjectParser);
                          setState(() {

                          });
                          print(auxSubjectParser);

                          setState(() {
                            _chosenValue = null;
                            horaI = null;
                            minI=null;
                            horaF = null;
                            minF=null;
                            Navigator.pop(context);
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));
                          });
                        }
                      },
                    ),RaisedButton(
                      child: Text("Cancel"),
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => HomePage()));

                      },
                    )
                  ],
                ))),
      ),
    );
  }
}
