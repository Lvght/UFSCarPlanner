import 'package:flutter/material.dart';
import 'package:ufscarplanner/models/meal.dart';

class MenuCard extends StatelessWidget {
  MenuCard(this._meal);

  final Meal _meal;

  @override
  Widget build(BuildContext context) {
    final List<String> titles = ["Prato principal", "Guarnição", "Arroz", "Feijão", "Saladas", "Sobremesa", "Bebida"];
    final bool isLunch = _meal.type.contains("ALMOÇO");
    final bool isUndefined = _meal.lista[1].contains("Não Definido");
    final bool hasTwoOptions = _meal.lista[1].split("/").length > 1;

    Container _getPart(String title, String content) {
      return Container(
        margin: const EdgeInsets.only(bottom: 15),
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(content)
          ],
        ),
      );
    }

    List<Widget> _getRestOfContent() {
      List<Widget> listOfWidgets = [];
      for (int i = 3, j = 1; i < _meal.lista.length - 1; i += 2, j += 1)
        listOfWidgets.add(_getPart(titles[j], _meal.lista[i]));
      return listOfWidgets;
    }

    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 10, 15, 10),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  isLunch
                      ? Icon(
                          Icons.wb_sunny,
                          color: Color(0xFFFF7777),
                        )
                      : Icon(
                          Icons.brightness_3,
                          color: Color(0xFF7777FF),
                        ),
                  Text("${isLunch ? "Almoço" : "Jantar"} | ${_meal.day}, ${_meal.date}"),
                  Icon(
                    Icons.brightness_3,
                    color: Colors.transparent,
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: isLunch ? Color(0xFFFF7777) : Color(0xFF7777FF),
              ),
              SizedBox(
                height: 10,
              ),
              isUndefined
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.info,
                          color: isLunch ? Color(0xFFFF7777) : Color(0xFF7777FF),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text("Cardápio ainda não informado")
                      ],
                    )
                  : Column(
                      children: <Widget>[
                        hasTwoOptions
                            ? Column(
                                children: <Widget>[
                                  _getPart("Opção convencional", _meal.lista[1].split("/")[0]),
                                  _getPart("Opção vegana", _meal.lista[1].split("/")[1]),
                                ],
                              )
                            : _getPart("Prato principal", _meal.lista[1]),
                        Column(
                          children: _getRestOfContent(),
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
