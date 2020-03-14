import 'package:flutter/material.dart';
import 'package:html/dom.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/widgets.dart' as widgets;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {

  static coleta() async{
    //TODO ARRUMA ISSO AI
   // var i = c.replaceAll("\t", "").replaceAll("\u003", "");

  //  print(i.toString());
  }
  final TextEditingController _controller = TextEditingController();
  static Future<String> b;
  static String c;
  static String deuRuim= "por enquanto não";
  static WebViewController _controlador;
  static final loginInput = TextField(
    decoration: InputDecoration(hintText: "Login"),
    controller: u,
  );

  static TextEditingController u= new TextEditingController(),p = new TextEditingController();
  static var ResultText = new widgets.Text(deuRuim) ;
  static final passwordInput = TextField(
    decoration: InputDecoration(hintText: "Password"),
    obscureText: true,
    controller: p,
  );

   WebView  a = new WebView(
    onWebViewCreated: (WebViewController webViewController) {
      _controlador = webViewController;
    },
    initialUrl: "https://sistemas.ufscar.br/siga/login.xhtml",
    javascriptMode: JavascriptMode.unrestricted,
    onPageStarted: (url)async{
      //TODO TRATAR FALTA DE INTERNET
      deuRuim="carregando.... "+url;
      print(deuRuim);
    },
    onPageFinished: (url) async{
      if (url == "https://sistemas.ufscar.br/siga/login.xhtml"&&bola==false) {
        deuRuim="pode logar";
      }else if(url == "https://sistemas.ufscar.br/siga/login.xhtml") {

        //TODO GRAVAR DADOS DE B
        //TODO VOLTAR PARA PAGINA DE CONFIGURAÇÕES
        c=await b;
        coleta();
        bola=true;
      }
      if(url=="https://sistemas.ufscar.br/siga/paginas/home.xhtml"){
        _controlador.loadUrl("https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml");
      }
      if (url ==
          "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml")
        _controlador.evaluateJavascript(
            "document.getElementById('aluno-matriculas-form:matriculas-table:0:matricula').click();");
      if (url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml?"))
        _controlador.evaluateJavascript(
            "document.getElementById('acoes-matriculas-form:solicitacao-inscricao-link').click();");
      if (url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml?"))
        _controlador.evaluateJavascript(
            "document.getElementById('inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113').click();");

      if(url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?")) {
        b = _controlador.evaluateJavascript(
            "document.documentElement.innerHTML;");
        print("->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"+(await b).split("inscricao-resultados-form:atividades-inscritas-table:tb")[1]);
        _controlador.evaluateJavascript(
            "document.getElementById('logout-form:sair-link').click();");
        deuRuim="logou";
        bola=true;
      }

      deuRuim="carregado.... "+url;
      print(deuRuim);

    },
  );
  static bool bola=false;
  Material loginButton = Material(
    child:Column(children: <Widget>[loginInput,passwordInput,ResultText,RaisedButton(
    child: widgets.Text("Entrar"),onLongPress:() async{
    ResultText= new  widgets.Text(deuRuim);},
    onPressed: ()  {
      _controlador.evaluateJavascript(
          "document.getElementById('login:usuario').value = '"  +u.text+   "';");
      _controlador.evaluateJavascript(
          "document.getElementById('login:password').value = '"+ p.text +"';");
      _controlador.evaluateJavascript(
          "document.getElementById('login:loginButton').click();");
      ResultText=  widgets.Text(deuRuim);
      },
  ),
  ],) );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widgets.Text("Página de login"),

      ),
      body: Column(
        children: <Widget>[
          this.loginButton,
          Container(
            child: a,
            width: 1,
            height: 1,

          ),
        ],
      ),
    );

  }

}
