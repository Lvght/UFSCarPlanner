import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final loginInput = TextField(
    decoration: InputDecoration(hintText: "Login"),
  );

  final passwordInput = TextField(
    decoration: InputDecoration(hintText: "Password"),
  );

  final loginButton = Material(
    child: RaisedButton(
      child: Text("Entrar"),
      onPressed: () async {
        // Pode conter as seguintes propriedades:
        // URL, headers, body e encoding
        // FIXME o que cada uma faz?
        http.Response response = await http
            .post('https://sistemas.ufscar.br/siga/login.xhtml', headers: {
          'login': 'login',
          'javax.faces.ViewState': '-7991983047578773891%3A4650427535077768370',
          'org.richfaces.focus': 'login%3AloginButton%20login',
          'login%3Ausuario': '769836',
          'login%3Apassword': '***',
          'javax.faces.source': 'login%3AloginButton',
          'javax.faces.partial.event': 'click',
          'javax.faces.partial.execute': 'login%3AloginButton%20%40component',
          'javax.faces.partial.render': '%40component',
          'org.richfaces.ajax.component': 'login%3AloginButton',
          'login%3AloginButton': 'login%3AloginButton',
          'rfExt': 'null',
          'AJAX%3AEVENTS_COUNT': '1',
          'javax.faces.partial.ajax': 'true'
        });
        print(response.body);
        print(response.headers);
        print(response);
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Página de login"),
      ),
      body: Column(
        children: <Widget>[this.loginInput, this.passwordInput, this.loginButton],
      ),
    );


  }
}
