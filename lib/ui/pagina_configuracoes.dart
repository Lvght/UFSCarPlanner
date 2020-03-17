import 'package:flutter/material.dart';
import 'package:ufscarplanner/ui/login_page.dart';
import 'login_page.dart';
import 'package:ufscarplanner/helpers/UserData.dart';

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
        Container(
          margin: EdgeInsets.only(top: 15, bottom: 60),
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image.asset("_assets/brasil.png", width: MediaQuery.of(context).size.width * 25 / 100,),
              SizedBox(height: 10,),
              Text("Defenda a ciência brasileira.", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),)
            ],
          ),
        ),
        RaisedButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage())),
          child: Text("Fazer login"),
        ),
        RaisedButton(
          child: Text("Imprimir texto do arquivo"),
          onPressed: () async {
            final userHelper = UserHelper();
            debugPrint(await userHelper.readRawData());
          },
        )
      ],
    );
  }
}
