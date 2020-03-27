import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io' as io;
import 'package:path_provider/path_provider.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'dart:convert';

import 'package:ufscarplanner/ui/login_page.dart';

class PaginaAgenda extends StatefulWidget {
  PaginaAgenda(this._materias);

  List<List<Materia>> _materias = [
    new List<Materia>(),
    new List<Materia>(),
    new List<Materia>(),
    new List<Materia>(),
    new List<Materia>(),
    new List<Materia>(),
    new List<Materia>(),
  ];

  var msg = "Faça login no SIGA e veja a sua agenda acadêmica nesta tela.";

  @override
  _PaginaAgendaState createState() => _PaginaAgendaState();
}

class _PaginaAgendaState extends State<PaginaAgenda> {
  UserHelper _userHelper = UserHelper();
  User _currentUser;

  @override
  void initState() {
    if (widget._materias == null) {
      _userHelper.readUser().then((value) {
        _currentUser = value;

        if (_currentUser != null) widget._materias = _currentUser.mat;
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget._materias == null
          ? Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.autorenew,
                      size: 60,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      widget.msg,
                      style: TextStyle(fontSize: 20),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                            .then((value) {
                              print("Val: " + value.mat[1].toString());
                              setState(() {
                                widget._materias = value.mat;
                              });
                        });
                      },
                      child: Text("Entrar no SIGA"),
                    )
                  ],
                ),
              ),
            )
          : getTabs(),
    );
  }

  TextStyle _titleTextStyle() =>
      TextStyle(fontSize: 20, fontWeight: FontWeight.bold);
  List<String> _diasDaSemana = [
    "Seg",
    "Ter",
    "Qua",
    "Qui",
    "Sex",
    "Sab",
    "Dom",
  ];

  /*
   * Retorna uma string com apenas as primeiras letras maiúsculas.
   * A função não irá capitalizar palavras com 2 caracteres ou menos (i.e: "De", "E", Etc.)
   */
  String _stringDecapitalizer(String str) {
    List<String> splittedString = str.toLowerCase().split(" ");
    String output = "";

    // Coloca apenas a primeira letra como maiúscula e copia o resto
    for (int i = 0; i < splittedString.length; i++)
      output += splittedString[i].substring(0, 1).toUpperCase() +
          splittedString[i].substring(1) +
          " ";

    // Remove o espaço desnecessário do final
    output = output.substring(0, output.length - 1);

    return output;
  }

  /*
   * Fornece as tabs para a página de agenda
   */
  DefaultTabController getTabs() {
    method();
    List<Widget> labelDiasDaSemana = List<Widget>();
    List<List<Widget>> cardsDasMaterias = List<List<Widget>>();
    List<Widget> paginas = List<Widget>();

    // Insere o "label" dos dias da semana, que se observa na parte superior da interface
    debugPrint("${MateriaHelper.lista_dias.length}");
    for (int i = 0; i < 7; i++) {
      labelDiasDaSemana.add(Text(
        _diasDaSemana[i],
        style: TextStyle(
          // Este valor (fontSize), se fixo, pode ser facilmente quebrado pelas dimensões do dispositivo.
          // Disto parte a necessidade de calculá-lo com base no contexto.
          // O valor que se observa foi *obtido por experimentação*, e é arbitrário.
          fontSize: MediaQuery.of(context).size.width * 0.024,
        ),
      ));

      // Inicializa uma nova lista vazia.
      // Nela serão inseridas as informações das matérias do dia
      cardsDasMaterias.add(new List<Widget>());

      // verifica se há matérias no dia
      if (widget._materias[i].length == 0)
        cardsDasMaterias[i].add(Container(
          padding: EdgeInsets.only(top: 40),
          child: Column(
            children: <Widget>[
              Icon(
                Icons.wb_sunny,
                size: 80,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Dia livre",
                style: TextStyle(fontSize: 30),
              )
            ],
          ),
        ));
      else
        for (int j = 0; j < widget._materias[i].length; j++) {
          cardsDasMaterias[i].add(Container(
            width: MediaQuery.of(context).size.width * 0.95,
            child: Card(
                margin: EdgeInsets.only(top: 15),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(bottom: 10),
                        margin: EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Color(0xFF000000)))),
                        child: Text(
                          this._stringDecapitalizer(
                              widget._materias[i][j].nome),
                          style: _titleTextStyle(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Text(
                        widget._materias[i][j].ministrantes.trim().isEmpty
                            ? "(ministrante não informado)"
                            : widget._materias[i][j].ministrantes.trim(),
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xAA000000),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      // Chips de horário
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            child: Text(
                              // O ternário abaixo garante que os horários sempre tenham a mesma
                              // quantidade de caracteres
                              widget._materias[i][j].horaI.length < 5
                                  ? "0" + widget._materias[i][j].horaI
                                  : widget._materias[i][j].horaI,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 1,
                                      offset: Offset(0, 1))
                                ],
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(150, 255, 150, 1),
                                  Color.fromRGBO(175, 255, 175, 1)
                                ]),
                                borderRadius: BorderRadius.circular(2)),
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Container(
                            child: Text(
                              // O ternário abaixo garante que os horários sempre tenham a mesma
                              // quantidade de caracteres
                              widget._materias[i][j].horaF.length < 5
                                  ? "0" + widget._materias[i][j].horaF
                                  : widget._materias[i][j].horaF,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(0x22000000),
                                      blurRadius: 1,
                                      offset: Offset(0, 1))
                                ],
                                gradient: LinearGradient(colors: [
                                  Color.fromRGBO(255, 150, 150, 1),
                                  Color.fromRGBO(255, 175, 175, 1)
                                ]),
                                borderRadius: BorderRadius.circular(2)),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 30,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Icon(Icons.place),
                          Text(widget._materias[i][j].local)
                        ],
                      )
                    ],
                  ),
                )),
          ));
        }
      paginas.add(SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 15),
        child: Column(
          children: cardsDasMaterias[i],
        ),
      ));
    }

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(30.0), // here the desired height
          child: AppBar(
            bottom: TabBar(
              tabs: labelDiasDaSemana,
              indicatorColor: Colors.white,
              indicatorWeight: 5,
            ),
          ),
        ),
        body: TabBarView(
          children: paginas,
        ),
      ),
    );
  }

  String userDataFilename = "Materiadata.json";

  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<io.File> get _file async =>
      io.File(await _filePath + "/" + userDataFilename);

  Future<io.File> writeRawData(String rawData) async {
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

  void method() async {
    String path = _file.toString();
    if (await io.File(path).exists()) {
      readRawData().then((data) {
        Iterable l = json.decode(data);
        Map<String, dynamic> a = new Map<String, dynamic>();
        List<listlist> c = l.map((a) => listlist.fromJson(a)).toList();
        widget._materias = new List<List<Materia>>();
        for (int i = 0; i < c.length; i++) widget._materias.add(c[i].list);
        print(widget._materias.toString());
      });
    } else {
      print("\n\n\n\n\n\n\n não existe");
    }
  }
}
