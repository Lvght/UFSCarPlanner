import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/login_page.dart';
import 'login_page.dart';

class PaginaConfiguracoes extends StatefulWidget {
  @override
  _PaginaConfiguracoesState createState() => _PaginaConfiguracoesState();
}

class _PaginaConfiguracoesState extends State<PaginaConfiguracoes> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text("Página de configurações"),
        RaisedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
          child: Text("Fazer login"),
        )
      ],
    );
  }
}
