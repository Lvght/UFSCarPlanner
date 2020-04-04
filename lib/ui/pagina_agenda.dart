import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/materia_editor.dart';
import 'package:ufscarplanner/models/materia.dart';
import 'package:ufscarplanner/ui/login_page.dart';
import 'package:ufscarplanner/models/user.dart';
import 'home_page.dart';
import 'package:hive/hive.dart';
import 'package:flutter_radio/flutter_radio.dart';

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

  Future<void> saveData() async {
    _userHelper.readUser().then((value) async {
      _currentUser = value;
      _currentUser.mat = widget._materias;
      _currentUser.updateSubjectMap();

      await _userHelper.saveUser(_currentUser).then((value) {
        String auxSubjectParser = value.materias.toString();
        _currentUser.mat = _userHelper.subjectParser(auxSubjectParser);
      });
    });
  }

  @override
  void initState() {
    super.initState();
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
                      color: Colors.red,
                      textColor: Colors.white,
                      onPressed: () async {
                        await FlutterRadio.stop();
                        Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()))
                            .then((value) async {
                          if (value != null) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                          }
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
      output += splittedString[i].length > 3
          ? splittedString[i].substring(0, 1).toUpperCase() +
              splittedString[i].substring(1) +
              " "
          : splittedString[i] + " ";

    // Remove o espaço desnecessário do final
    output = output.substring(0, output.length - 1);

    return output;
  }

  TextStyle _getWeekLabelsStyle() => TextStyle(
        fontSize: MediaQuery.of(context).size.width * 0.024,
      );

  List<Widget> _getWeekLabels() {
    List<Widget> output = List<Widget>();
    for (int i = 0; i < 7; i++)
      output.add(Text(
        _diasDaSemana[i],
        style: _getWeekLabelsStyle(),
      ));
    return output;
  }

  Container _getFreeDayIndicator() => Container(
        padding: EdgeInsets.only(top: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
      );

  Container _getCard(Materia materia) => Container(
      width: MediaQuery.of(context).size.width * 0.95,
      child: new GestureDetector(
        onLongPress: () {
          // configura o button
          Widget okButton = FlatButton(
            child: Text("Remover"),
            onPressed: () async {
              print(materia.toString());
              widget._materias[_diasDaSemana.indexOf(materia.dia.trim())]
                  .remove(materia);
              await saveData().then((onValue) {
                setState(() => null);
                Navigator.pop(context);
              });
            },
          );
          Widget cancelButton = FlatButton(
            child: Text("Cancelar"),
            onPressed: () {
              Navigator.pop(context);
            },
          );

          Widget editButton = FlatButton(
            child: Text("Editar"),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MateriaEditor(materia: materia)));
            },
          );

          // configura o  AlertDialog
          AlertDialog alerta = AlertDialog(
            actions: [
              okButton,
              cancelButton,
              editButton,
            ],
          );

          // exibe o dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alerta;
            },
          );
        },
        child: Card(
          // Change the color of the container beneath
          margin: EdgeInsets.only(top: 15),
          child: Padding(
              padding: EdgeInsets.all(12),
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
                      this._stringDecapitalizer(materia.nome),
                      style: _titleTextStyle(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    materia.ministrantes.trim().replaceAll("\\n", "\n").isEmpty
                        ? "(ministrante não informado)"
                        : materia.ministrantes.replaceAll("\\n", "\n").trim(),
                    style: TextStyle(
                      fontSize: 17,
                      color: Color(0xAA000000),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  // Horários
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
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
                        child: Text(
                          materia.horaI.length < 5
                              ? "0" + materia.horaI
                              : materia.horaI,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        width: 13,
                      ),
                      Container(
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
                        child: Text(
                          materia.horaF.length < 5
                              ? "0" + materia.horaF
                              : materia.horaF,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 30,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[Icon(Icons.place), Text(materia.local)],
                  ),
                ],
              )),
        ),
      ));

  List<Widget> _getPages() {
    method();
    List<List<Widget>> cardsDasMaterias = List<List<Widget>>();
    List<Widget> paginas = List<Widget>();

    for (int i = 0; i < 7; i++) {
      // Inicializa uma nova lista vazia.
      // Nela serão inseridas as informações das matérias do dia
      cardsDasMaterias.add(new List<Widget>());

      if (widget._materias[i].length != 0) {
        for (int j = 0; j < widget._materias[i].length; j++) {
          cardsDasMaterias[i].add(_getCard(widget._materias[i][j]));
        }

        paginas.add(SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 15),
          child: Column(
            children: cardsDasMaterias[i],
          ),
        ));
      } else {
        paginas.add(Center(
          child: _getFreeDayIndicator(),
        ));
      }
    }

    return paginas;
  }

  /*
   * Fornece as tabs para a página de agenda
   */
  DefaultTabController getTabs() => DefaultTabController(
        initialIndex: DateTime.now().weekday - 1,
        length: 7,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(30.0), // here the desired height
            child: AppBar(
              bottom: TabBar(
                tabs: _getWeekLabels(),
                indicatorColor: Colors.white,
                indicatorWeight: 5,
              ),
            ),
          ),
          body: TabBarView(children: _getPages()),
          // Todo reimplementar o FloatingActionButton
        ),
      );

  void method() async {
    final userBox = Hive.box("user");
    if (userBox.length != 0) {
      List<List<Materia>> c = userBox.getAt(0).mat;
      widget._materias = new List<List<Materia>>();
      for (int i = 0; i < c.length; i++) widget._materias.add(c[i]);
      print(widget._materias.toString());
    } else {
      print("\n\n\n\n\n\n\n não existe");
    }
  }
}
