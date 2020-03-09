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
              shrinkWrap: true,
              itemBuilder: (context, index) => SingleChildScrollView(
                child: Container( decoration: BoxDecoration(color:widgets.Color.fromARGB(225, 200, 50, 50),border: Border.all(
                  width: 3.0,

                  color: widgets.Color.fromARGB(225, 200, 50, 50),
                ),
                  borderRadius: BorderRadius.all(
                      Radius.circular(10.0) //         <--- border radius here
                  ),),
                  padding: EdgeInsets.all(10),
                  margin: EdgeInsets.all(10),

                  child: Row(

                    children: <Widget>[
                     /* Image.network(
                        'https://img.gentside.com.br/article/entretenimento/rato-maconha_54f642e714000fd7b75b1a042efc840c504999dc.jpg',
                        fit: BoxFit.cover,
                        width: MediaQuery.of(context).size.width * 30 / 100,
                        height: MediaQuery.of(context).size.width * 30 / 100,
                      ),*/
                    Container(
                      decoration: BoxDecoration(color: Colors.deepOrangeAccent,border: Border.all(
                          width: 3.0,

                        color:Colors.deepOrangeAccent,
                      ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0) //         <--- border radius here
                        ),),

                      padding: EdgeInsets.all(15),

                      width: MediaQuery.of(context).size.width * 30 / 100,
                      child: Column(
                        children: <Widget>[
                          widgets.Text(snapshot.data[index].day,textAlign: TextAlign.center,  style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                          widgets.Text(snapshot.data[index].date,textAlign: TextAlign.start,  style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),
                          widgets.Text(snapshot.data[index].type,textAlign: TextAlign.start,  style: new TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),),


                        ],

                      ),
                    ),

                      Container(decoration: BoxDecoration(color: Colors.deepOrangeAccent,border: Border.all(
                        width: 10.0,
                        color:Colors.black,
                      ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(15.0) //         <--- border radius here
                        ),),
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width * 58 / 100,
                          height: MediaQuery.of(context).size.width * 60 / 100,

                          child: ListView.builder(

                            shrinkWrap: false,
                            itemBuilder: (context, index2) =>
                                SingleChildScrollView(

                                    child: Container(

                              padding: EdgeInsets.all(1.0),
                              width:MediaQuery.of(context).size.width * 57 / 100,
                                        height:
                                        MediaQuery.of(context).size.width * 20 / 100,
                              color: Colors.deepOrangeAccent,

                              child: widgets.Column(

                                    children: <Widget>[

                                      widgets.Text(
                                        snapshot.data[index].lista[index2 * 2],
                                        style: new TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      widgets.Flexible(
                                        child: widgets.Text(
                                          snapshot.data[index]
                                              .lista[index2 * 2 + 1].replaceAll("/", "\n"),
                                          style: new TextStyle(
                                            fontSize: 13.0,
                                          ),textAlign: TextAlign.justify,
                                        ),
                                      ),
                                    ],
                                  )

                            )),
                            itemCount: snapshot.data[index].lista.length ~/ 2,
                          ))
                      //
                    ],
                  ),
                ),
              ),
              itemCount: snapshot.data.length,
            );
        }
      },
    );
  }
}
