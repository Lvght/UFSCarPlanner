import 'package:flutter/material.dart';
import 'package:ufscarplanner/helpers/DataScrapper.dart';

class PaginaRu extends StatefulWidget {
  @override
  _PaginaRuState createState() => _PaginaRuState();
}

class _PaginaRuState extends State<PaginaRu> {
  DataScrapper d1 = DataScrapper(
      'https://www2.ufscar.br/restaurantes-universitario/cardapio');



  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: d1.initiate(),
      builder: (context, snapshot) {
        return Text(snapshot.data.toString());
      },
    );
  }
}
