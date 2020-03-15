import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:webview_flutter/webview_flutter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controladores
  final TextEditingController _loginTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  WebViewController _webViewController;

  // Outras propriedades
  bool _done = false;
  String _mensagem;
  String _rawData;
  String _cleanData;

  // Cria o WebView
  WebView _createWebView(String initialUrl, void onPageStartedFunction(String url), void onPageFinishedFunction(String url)) {
    return WebView(
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController w) => this._webViewController = w,
      onPageStarted: onPageStartedFunction,
      onPageFinished: onPageFinishedFunction,
    );
  }

  void _onPageStartedFunct(String url) async {
    //TODO TRATAR FALTA DE INTERNET
    print("Carregando a página: $url");
  }

  void _onPageFinishedFunct(String url) async {
    // Primeira página: o login acontece aqui.
    if (url == "https://sistemas.ufscar.br/siga/login.xhtml" && this._done == false) {
      this._mensagem = "pode logar";
    }

    // Esta condição indica o fim do processo das páginas
    // Este é o ÚLTIMO CASO!
    else if (url == "https://sistemas.ufscar.br/siga/login.xhtml") {
      //TODO GRAVAR DADOS DE B
      //TODO VOLTAR PARA PAGINA DE CONFIGURAÇÕES
      this._cleanData = this._rawData;
      _coleta(this._cleanData);
      _done = true;
      Navigator.pop(this.context);
    }

    // Aqui a página de Matrículas é carregada.
    if (url == "https://sistemas.ufscar.br/siga/paginas/home.xhtml") {
      this._webViewController.loadUrl("https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml");
    }

    // Aqui executa-se o JS necessário na página de matrículas para que se possa avançar
    if (url == "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml")
      this._webViewController.evaluateJavascript("document.getElementById('aluno-matriculas-form:matriculas-table:0:matricula').click();");
    if (url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml?"))
      this._webViewController.evaluateJavascript("document.getElementById('acoes-matriculas-form:solicitacao-inscricao-link').click();");
    if (url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml?"))
      this
          ._webViewController
          .evaluateJavascript("document.getElementById('inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113').click();");

    if (url.contains("https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?")) {
      _rawData = await this._webViewController.evaluateJavascript("document.documentElement.innerHTML;");
      print("->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
          this._rawData.split("inscricao-resultados-form:atividades-inscritas-table:tb")[1]);
      this._webViewController.evaluateJavascript("document.getElementById('logout-form:sair-link').click();");
      this._done = true;
    }

    print("Esta página foi carregada: $url");
  }

  InputDecoration _getInputDecoration(String labelText) => InputDecoration.collapsed(
        hintText: labelText,
      );

  List<Map<String, String>> _coleta(String s) {
    //TODO ARRUMA ISSO AI
    String a = "\u005C";
    var p = "";
    String i = s
        .split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[1]
        .split("inscricao-resultados-form:atividades-inscritas-table:5:j_idt171")[0]
        .replaceAll(a + 'u003C', "<")
        .replaceAll("<td", "<>TD<")
        .replaceAll("<tr", "<>TR<")
        .replaceAll('class=\\"rf-dt-c\\"', "");

    for (int j = 0; j < i.replaceAll(">", "<").split("<").length; j++) {
      if (j % 2 == 0) p += "<sploint>" + i.replaceAll(">", "<").split("<")[j];
    }
    var aux;
    do {
      aux = p;
      p = p.replaceAll("<sploint><sploint>", "<sploint>");
      p = p.replaceAll(a + a, a);
      p = p.replaceAll(' ' + a, a);
      p = p.replaceAll("  ", " ");
      p = p.replaceAll(a + "t" + a + "t", a + "t");
    } while (p != aux);
    aux = p.split("<sploint>");
    p = "";
    for (int j = 0; j < aux.length; j++) {
      if (aux[j] != a + "n" + a + "t" && aux[j] != a + "n") p += aux[j] + "\n";
    }
    int tr = -1, td = -1;

    List<Map<String, String>> mapa = new List<Map<String, String>>();
    Map<String, String> axa = {"Aula": "", "Turma": "", "Dias/Horarios": "", "Ministrantes": "", "Operacoes": ""};
    Map<String, String> axismo = axa;
    List<String> lista = ["Aula", "Turma", "Dias/Horarios", "Ministrantes", "Operacoes"];

    for (int j = 7; j < p.split("\n").length; j++) {
      if (p.split("\n")[j] == "TR") {
        if (axa != axismo) mapa.add(axa);
        tr++;
        axa = {"Aula": "", "Turma": "", "Dias/Horarios": "", "Ministrantes": "", "Operacoes": ""};
      } else if (p.split("\n")[j] == "TD") {
        td++;
      } else {
        axa[lista[td % 5]] += p.split("\n")[j] + "\n";
      }
    }
    print(mapa.toString());
    return mapa;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: widgets.Text("Página de login"),
      ),
      body: Column(
        children: <Widget>[
          TextField(
            decoration: _getInputDecoration('Login'),
            controller: _loginTextController,
          ),
          TextField(
            decoration: _getInputDecoration('Senha'),
            obscureText: true,
            controller: _passwordTextController,
          ),
          RaisedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[Icon(Icons.check_circle), widgets.Text("Fazer login")],
            ),
            onPressed: () {
              print("Botão pressionado");

              // Ativa o WebView
              this
                  ._webViewController
                  .evaluateJavascript("document.getElementById('login:usuario').value = '" + _loginTextController.text + "';");
              this
                  ._webViewController
                  .evaluateJavascript("document.getElementById('login:password').value = '" + _passwordTextController.text + "';");
              this._webViewController.evaluateJavascript("document.getElementById('login:loginButton').click();");
            },
          ),
          Visibility(
            child: Container(
              // O tamanho definido é arbitrário
              // efetivamente, nada será mostrado na tela
                height: 20,
                width: 20,
                child: this._createWebView("https://sistemas.ufscar.br/siga/login.xhtml", this._onPageStartedFunct, this._onPageFinishedFunct)),
            maintainState: true,
            visible: false,
          ),
        ],
      ),
    );
  }
}
