import 'dart:ui';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsPage extends StatelessWidget {
  NewsPage(titulo, autor, data, corpo) {
    this.titulo = titulo;
    this.autor = autor;
    this.data = data;
    this.corpo = corpo;
    teste = copo(corpo);
  }

  String titulo;
  String autor;
  String data;
  String corpo;
  RichText teste;

  RichText copo(String src) {
    List<TextSpan> wids = List<TextSpan>();
    var x = src.trim().split("<sploint>");
    List<String> tags = new List<String>();
    Map<String, String> links = new Map<String, String>();
    for (int i = 0; i < x.length; i++) {
      TextStyle a;
      String text = "";
      if (x[i].contains("<em>")) {
        tags.add("em");
      } else if (x[i].contains("<i>")) {
        tags.add("i");
      } else if (x[i].contains("<strong>")) {
        tags.add("strong");
      } else if (x[i].contains("<u>")) {
        tags.add("u");
      } else if (x[i].contains("<a")) {
        tags.add("a");
        text = x[i].split('href="')[1].split('">')[1];
        links[text] = x[i].split('href="')[1].split('"')[0];
        print("\n\n\n\n\n\n\n\nlink:'" + links[text] + "'\n\n\n\n\n\n\n");
      } else if (x[i].contains("</" + "i>")) {
        tags.remove("i");
      } else if (x[i].contains("</" + "em>")) {
        tags.remove("em");
      } else if (x[i].contains("</" + "strong>")) {
        tags.remove("strong");
      } else if (x[i].contains("<" + "/u>")) {
        tags.remove("u");
      } else if (x[i].contains("</" + "a>")) {
        tags.remove("a");
      } else {
        text = x[i];
      }
      a = TextStyle(
        fontSize: 18,
        height: 1.5,
        fontWeight: tags.contains("em") || tags.contains("strong") ? FontWeight.bold : FontWeight.normal,
        fontStyle: tags.contains("i") ? FontStyle.italic : FontStyle.normal,
        color: tags.contains("a") ? Color.fromRGBO(230, 20, 20, 1) : Colors.black,
      );

      TextSpan t = new TextSpan(
          text: text,
          style: a,
          recognizer: tags.contains("a")
              ? (new TapGestureRecognizer()
                ..onTap = () async {
                  String url = links[text];
                  print("\n\n\n\n\n\n\n\nBRAAAAAAAAAAAAAAAABOOOOOOOOOOR\n\n\n\n\n\n\n\n\n\n\n\n");
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    print("não deu pra lançar a braba :'" + url + "'");
                  }
                })
              : null);
      if (text.compareTo("") != 0) wids.add(t);
    }
    RichText linha = new RichText(text: TextSpan(children: wids));
    return linha;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          data + " | " + autor,
          style: TextStyle(fontSize: 15),
        ),
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
            SizedBox(
              height: 10,
            ),
            Text(
              data + " | " + autor,
              style: TextStyle(color: Colors.black26, fontSize: 15),
            ),
            Container(
              height: 1,
              color: Colors.black26,
              margin: EdgeInsets.only(top: 10, bottom: 15),
            ),
            Container(
              child: teste,
              width: MediaQuery.of(context).size.width,
            )
          ],
        ),
      ),
    );
  }
}
