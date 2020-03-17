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
        title: Text(this.titulo),
      ),

      body:SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text("Autor: $autor"),
            Text("Data: $data"),
            Text(corpo)
          ],
        ),
      ),
    );
  }
}
