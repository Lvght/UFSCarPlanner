import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';
import 'package:async/async.dart';

class PaginaRu extends StatefulWidget {
  @override
  _PaginaRuState createState() => _PaginaRuState();
}

class _PaginaRuState extends State<PaginaRu> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  DataScrapper d1 = DataScrapper(

      //TODO TRATAR FALTA DE INTERNET
      'https://www2.ufscar.br/restaurantes-universitario/cardapio');

  TextStyle _boldTextStyle() => TextStyle(fontWeight: FontWeight.bold, fontSize: 18);

  TextStyle _regularText() => TextStyle(
        color: Colors.black,
        fontSize: 18, // FIXME Usar tamanho relativo seria preferível?
      );

  Container _getContainingModule(String title, String content, {bool isLast = false}) => Container(
        margin: isLast ? EdgeInsets.only(top: 10) : EdgeInsets.only(top: 10, bottom: 10),
        child: Column(
          children: <Widget>[Text(title, style: _boldTextStyle()), Text(content, style: _regularText())],
        ),
      );

  Widget _assembleText(Meal m) {
    List<Widget> output = List<Widget>();
    bool hasTwoOptions = m.lista[1].split("/").length > 1;
    List<String> titles = ["Prato principal", "Guarnição", "Arroz", "Feijão", "Saladas", "Sobremesa", "Bebida"];

    // Mostra informações sobre a data e refeição
    output.add(RichText(
        text: TextSpan(style: _regularText(), children: <TextSpan>[
      TextSpan(text: m.type[1].toUpperCase() + m.type.substring(2).toLowerCase(), style: _boldTextStyle()),
      TextSpan(text: " | " + m.day + "," + m.date)
    ])));

    // Adiciona uma linha divisória
    output.add(Container(
      height: 15,
      margin: EdgeInsets.only(top: 10),
      decoration: m.type.contains("ALMOÇO")
      // FIXME As cores DEFINITIVAMENTE precisam ser alteradas
          ? BoxDecoration(gradient: LinearGradient(colors: [Color.fromRGBO(210, 30, 30, 1), Color.fromRGBO(250, 80, 80, 1)]))
          : BoxDecoration(gradient: LinearGradient(colors: [Color.fromRGBO(30, 30, 210, 1), Color.fromRGBO(80, 80, 250, 1)])),
    ));

    // Verifica se o cardápio ainda não está indefinido
    if (m.lista[1].contains("Não Definido")) {
      output.add(Container(
          margin: EdgeInsets.only(top: 15, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.error,
                size: 30,
              ),
              Text(
                "Cardápio ainda não informado!",
                style: _regularText(),
              )
            ],
          )));
    } else {
      // Caso haja duas opções, o app fará distinção entre convencional e vegano
      if (hasTwoOptions) {
        output.add(_getContainingModule("Opção convencional", m.lista[1].split("/")[0]));
        output.add(_getContainingModule("Opção vegana", m.lista[1].split("/")[1]));
      } else
        output.add(_getContainingModule("Opção principal", m.lista[1]));

      // Este for adiciona os elementos restantes da lista, como Guarnição, arroz, feijão, etc
      for (int i = 3, j = 1; i < m.lista.length; i += 2, j += 1) output.add(_getContainingModule(titles[j], m.lista[i]));
    }

    return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
        decoration:
            BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(color: Color.fromRGBO(230, 230, 230, 1), offset: Offset(0, 2), blurRadius: 5)]),
        child: Column(
          children: output,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _memoizer.runOnce(() => d1.initiate()),
      builder: (context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(),
            );

          default:
            return ListView.builder(
                itemCount: snapshot.data.length,
                shrinkWrap: false,
                itemBuilder: (context, index) => Container(
                      child: this._assembleText(snapshot.data[index]),
                    ));
        }
      },
    );
  }
}
