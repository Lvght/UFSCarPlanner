import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';
import 'package:flutter/widgets.dart' as widgets;

class PaginaRu extends StatefulWidget {
  @override
  _PaginaRuState createState() => _PaginaRuState();
}

class _PaginaRuState extends State<PaginaRu> {
  DataScrapper d1 = DataScrapper(
      'https://www2.ufscar.br/restaurantes-universitario/cardapio');

  /*Widget cardTextBuilder(AsyncSnapshot<List<Meal>> snapshot, int index) {
    String out = "";
    for (int i = 0; i < snapshot.data[index].lista.length; i++)
      out += snapshot.data[index].lista[i];

    return Container(
        // child: Text(out),
        );
  }*/

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: d1.initiate(),
      builder: (context, AsyncSnapshot<List<Meal>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.none:
            return Center(
              child: CircularProgressIndicator(),
            );

          default:
            return ListView.builder(
              shrinkWrap: false,
              itemBuilder: (context, index) => Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(0, 1),
                          blurRadius: 2
                        )
                      ],
                      border: Border.all(color: Colors.black, width: 1)),
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.data[index].type.toLowerCase() + " |",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(snapshot.data[index].day +
                              ", " +
                              snapshot.data[index].date),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10, bottom: 15),
                        height: 5,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Colors.red, Colors.blueAccent],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Opção convencional",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              snapshot.data[index].lista[1].split('/')[0],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Opção vegana",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[1].split('/')[1],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Guarnição",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[3],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Arroz",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[5],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Feijão",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[7],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Saladas",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[9],
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(bottom: 10),
                        child: Column(
                          children: <Widget>[
                            Text("Sobremesa",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            Text(
                              snapshot.data[index].lista[11],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
              itemCount: snapshot.data.length,
            );
        }
      },
    );
  }
}
