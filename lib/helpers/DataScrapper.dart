import 'dart:convert';             // Contains the JSON encoder
import 'package:flutter/material.dart';
import 'package:http/http.dart';   // Contains a client for making API calls
import 'package:html/parser.dart'; // Contains HTML parsers to generate a Document object
import 'package:html/dom.dart' as dom;    // Contains DOM related classes for extracting data from elements

class DataScrapper {
  DataScrapper(String url) {
    this._url = url;
  }

  String _url;

  // Método para obter os dados
  Future initiate() async {
    var client = Client();
    Response response = await client.get(this._url);

    var document = parse(response.body);

    print(document.querySelectorAll('#content'));
    print(document.querySelectorAll("#cardapio").toString().length);
  }
}