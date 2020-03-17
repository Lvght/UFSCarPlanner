import 'package:flutter/material.dart';

class NewsPage extends StatelessWidget {
  NewsPage(this.titulo, this.autor, this.data, this.corpo);

  String titulo;
  String autor;
  String data;
  String corpo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(data + " | " + autor, style: TextStyle(fontSize: 15),),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () => print("hahaha"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(MediaQuery.of(context).size.width * 5 / 100),
        child: Column(
          children: <Widget>[
            Text(
              titulo,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10,),
            Text(data + " | " + autor, style: TextStyle(color: Colors.black26, fontSize: 15),),
            Container(
              height: 1,
              color: Colors.black26,
              margin: EdgeInsets.only(top: 10, bottom: 15),
            ),
            Text(
              corpo,
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 18, height: 1.5),
            )
          ],
        ),
      ),
    );
  }
}
