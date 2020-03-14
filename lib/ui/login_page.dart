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

  // Construtor


  static List<Map<String,String>> coleta(String s) {
    //TODO ARRUMA ISSO AI
    String a = "\u005C";
    var p="";
    String i = s.split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[1].split("inscricao-resultados-form:atividades-inscritas-table:5:j_idt171")[0].replaceAll(a+'u003C', "<").replaceAll("<td","<>TD<").replaceAll("<tr","<>TR<").replaceAll('class=\\"rf-dt-c\\"', "");

    for(int j=0;j<i.replaceAll(">", "<").split("<").length;j++){
      if(j%2==0)
        p+="<sploint>"+i.replaceAll(">", "<").split("<")[j];
    }
    var aux;
    do{
      aux=p;
      p=p.replaceAll("<sploint><sploint>", "<sploint>");
      p=p.replaceAll(a+a,a );
      p=p.replaceAll(' '+a,a);
      p=p.replaceAll("  "," ");
      p=p.replaceAll(a+"t"+a+"t", a+"t");
    }while(p!=aux);
    aux = p.split("<sploint>");
    p="";
    for(int j=0;j<aux.length;j++){
      if(aux[j]!=a+"n"+a+"t"&&aux[j]!=a+"n")
        p+=aux[j]+"\n";
    }
    int tr=-1,td=-1;

    List<Map<String,String>> mapa = new List<Map<String,String>>();
    Map<String,String>   axa= {"Aula":"","Turma":"","Dias/Horarios":"","Ministrantes":"","Operacoes":""};
    Map<String,String> axismo = axa;
    List<String> lista = ["Aula","Turma","Dias/Horarios","Ministrantes","Operacoes"];

    for(int j=7;j<p.split("\n").length;j++){
      if(p.split("\n")[j]=="TR"){
        if(axa!=axismo)
          mapa.add(axa);
        tr++;
        axa= {"Aula":"","Turma":"","Dias/Horarios":"","Ministrantes":"","Operacoes":""};
      }else if(p.split("\n")[j]=="TD"){
        td++;
      }else{
        axa[lista[td%5]]+=p.split("\n")[j]+"\n";
      }

    }
    print(mapa.toString());
    return mapa;
  }

  final TextEditingController _controller = TextEditingController();
  static Future<String> rawData;
  static String c;
  static String warningMessage = "por enquanto não";
  static WebViewController _controlador;
  static final loginInput = TextField(
    decoration: InputDecoration(hintText: "Login"),
    controller: u,
  );

  static TextEditingController u = new TextEditingController(),
      p = new TextEditingController();
  static var ResultText = new widgets.Text(warningMessage);

  static final passwordInput = TextField(
    decoration: InputDecoration(hintText: "Password"),
    obscureText: true,
    controller: p,
  );

  WebView webViewWidget = new WebView(
    onWebViewCreated: (WebViewController webViewController) {
      _controlador = webViewController;
    },
    initialUrl: "https://sistemas.ufscar.br/siga/login.xhtml",
    javascriptMode: JavascriptMode.unrestricted,
    onPageStarted: (url) async {
      //TODO TRATAR FALTA DE INTERNET
      warningMessage = "carregando.... " + url;
      print(warningMessage);
    },
    onPageFinished: (url) async {
      if (url == "https://sistemas.ufscar.br/siga/login.xhtml" &&
          terminou == false) {
        warningMessage = "pode logar";
      }
      // Esta condição indica o fim do processo das páginas
      else if (url == "https://sistemas.ufscar.br/siga/login.xhtml") {
        //TODO GRAVAR DADOS DE B
        //TODO VOLTAR PARA PAGINA DE CONFIGURAÇÕES
        c = await rawData;
        coleta(c);
        terminou = true;
      }
      if (url == "https://sistemas.ufscar.br/siga/paginas/home.xhtml") {
        _controlador.loadUrl(
            "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml");
      }
      if (url ==
          "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml")
        _controlador.evaluateJavascript(
            "document.getElementById('aluno-matriculas-form:matriculas-table:0:matricula').click();");
      if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml?"))
        _controlador.evaluateJavascript(
            "document.getElementById('acoes-matriculas-form:solicitacao-inscricao-link').click();");
      if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml?"))
        _controlador.evaluateJavascript(
            "document.getElementById('inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113').click();");

      if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?")) {
        rawData = _controlador
            .evaluateJavascript("document.documentElement.innerHTML;");
        print("->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
            (await rawData).split(
                "inscricao-resultados-form:atividades-inscritas-table:tb")[1]);
        _controlador.evaluateJavascript(
            "document.getElementById('logout-form:sair-link').click();");
        warningMessage = "logou";
        terminou = true;
      }

      warningMessage = "carregado.... " + url;
      print(warningMessage);
    },
  );
  static bool terminou = false;
  Material loginButton = Material(
      child: Column(
    children: <Widget>[
      loginInput,
      passwordInput,
      ResultText,
      RaisedButton(
        child: widgets.Text("Entrar"),
        onPressed: () {
          _controlador.evaluateJavascript(
              "document.getElementById('login:usuario').value = '" +
                  u.text +
                  "';");
          _controlador.evaluateJavascript(
              "document.getElementById('login:password').value = '" +
                  p.text +
                  "';");
          _controlador.evaluateJavascript(
              "document.getElementById('login:loginButton').click();");
          ResultText = widgets.Text(warningMessage);
        },
      ),
    ],
  ));

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
            child: webViewWidget,
            width: 1,
            height: 1,
          ),
        ],
      ),
    );
  }
}
