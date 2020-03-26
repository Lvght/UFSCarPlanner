import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:http/http.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ufscarplanner/helpers/UserData.dart';

const String menorQue = "\\u003C";
const String contrabarra = "\u005C";

enum WebViewState {
  LOGIN_FAILED,
  REQ_LOGINPAGE,
  ISAT_LOGINPAGE,
  REQ_HOMEPAGE,
  REQ_LISTMATRICULAS,
  REQ_ACOESMATRICULAS,
  REQ_INSCRICOESRESULTADOS,
  REQ_RESUMOINSCRICOESRESULTADOS,
  UNDEFINED_LOCATION,
  INITIAL_VALUE
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

  String _routeStr = "Init\n";
  String _displayMessage = "";
  WebViewState _state = WebViewState.INITIAL_VALUE;
  List<WebViewState> _route = List();

  double _currentProgress = 0;
}

class _LoginPageState extends State<LoginPage> {
  // User
  User user = User.internal();

  // Controladores
  final TextEditingController _loginTextController = TextEditingController();
  final TextEditingController _passwordTextController = TextEditingController();
  WebViewController _webViewController;

  // Outras propriedades
  bool _done = false;
  String _mensagem;
  String _rawData;
  String _cleanData;
  final _key = GlobalKey<FormState>();

  // Cria o WebView
  WebView _createWebView(
      String initialUrl,
      void onPageStartedFunction(String url),
      void onPageFinishedFunction(String url)) {
    return WebView(
      initialUrl: initialUrl,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController w) => this._webViewController = w,
      onPageStarted: onPageStartedFunction,
      onPageFinished: onPageFinishedFunction,
    );
  }

  bool isAtLoginFailed() {
    int lastIndex = widget._route.length - 1;
    if (lastIndex == 1 &&
        (widget._route[lastIndex] == WebViewState.ISAT_LOGINPAGE)) {
      widget._route.removeLast();
      widget._state = WebViewState.LOGIN_FAILED;
      return true;
    }

    return false;
  }

  void _onPageStartedFunct(String url) async {
    //TODO TRATAR FALTA DE INTERNET
    print("Carregando a página: $url");

    setState(() {
      if (url.contains("https://sistemas.ufscar.br/siga/login.xhtml"))
        widget._state = WebViewState.REQ_LOGINPAGE;
      if (url.contains("https://sistemas.ufscar.br/siga/paginas/home.xhtml"))
        widget._state = WebViewState.REQ_HOMEPAGE;
      else if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml"))
        widget._state = WebViewState.REQ_LISTMATRICULAS;
      else if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml"))
        widget._state = WebViewState.REQ_ACOESMATRICULAS;
      else if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml"))
        widget._state = WebViewState.REQ_INSCRICOESRESULTADOS;
      else if (url.contains(
          "https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?cid=1"))
        widget._state = WebViewState.REQ_RESUMOINSCRICOESRESULTADOS;
      widget._routeStr += "Carregando a página: $url\n";
    });
  }

  void _onPageFinishedFunct(String url) async {
    final userHelper = UserHelper();
    String auxSubjectParser;

    // Primeira página: o login acontece aqui.
    if (url == "https://sistemas.ufscar.br/siga/login.xhtml" &&
        this._done == false) {
      this._mensagem = "pode logar";
    }

    // ETAPA DE SALVAMENTO DOS DADOS
    // Esta condição indica o fim do processo das páginas
    // Este é o ÚLTIMO CASO!
    else if (url == "https://sistemas.ufscar.br/siga/login.xhtml") {
      this._cleanData = this._rawData;

      _coleta(this._cleanData);
      _done = true;

      print("Escrevendo...\n");
      await userHelper.saveUser(user);

      auxSubjectParser =
          json.encode(user.materias.toString()).replaceAll("\\n", "");
      user.mat = userHelper.subjectParser(auxSubjectParser);
      print("Os dados foram escritos\n");

      // Retorna à tela anterior, retornando os dados do usuário
      Navigator.pop(this.context, this.user);
    }

    // Aqui a página de Matrículas é carregada.
    if (url == "https://sistemas.ufscar.br/siga/paginas/home.xhtml") {
      this._webViewController.loadUrl(
          "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml");
    }

    // Aqui executa-se o JS necessário na página de matrículas para que se possa avançar
    if (url ==
        "https://sistemas.ufscar.br/siga/paginas/aluno/listMatriculas.xhtml")
      this._webViewController.evaluateJavascript(
          "document.getElementById('aluno-matriculas-form:matriculas-table:0:matricula').click();");
    if (url.contains(
        "https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml?"))
      this._webViewController.evaluateJavascript(
          "document.getElementById('acoes-matriculas-form:solicitacao-inscricao-link').click();");
    if (url.contains(
        "https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml?")) {
      String rawData = await this
          ._webViewController
          .evaluateJavascript("document.documentElement.innerHTML;");
      user.ira = rawData
          .split("IRA")[1]
          .split(">")[2]
          .split(contrabarra + "u003C" + "/span")[0];
      debugPrint("VALOR DO IRA = ${user.ira}");

      user.nome = rawData
          .split("${this._loginTextController.text} - ")[1]
          .split(contrabarra + "u003C" + "/span>")[0];
      debugPrint("Valor do nome = ${user.nome}");

      this._webViewController.evaluateJavascript(
          "document.getElementById('inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113').click();");
    }

    if (url.contains(
        "https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?")) {
      _rawData = await this
          ._webViewController
          .evaluateJavascript("document.documentElement.innerHTML;");
      this._webViewController.evaluateJavascript(
          "document.getElementById('logout-form:sair-link').click();");
      this._done = true;
    }

    print("Esta página foi carregada: $url");
    setState(() {
      if (url.contains("https://sistemas.ufscar.br/siga/login.xhtml"))
        widget._state = WebViewState.ISAT_LOGINPAGE;

      widget._routeStr += "Esta página foi carregada: $url\n";
      widget._route.add(widget._state);
    });

    print("Tamanho da rota: ${widget._route.length}");

    if (isAtLoginFailed()) print("LOGIN FRACASSADO");
  }

  double _getProgress() {
    switch (widget._state) {
      case WebViewState.ISAT_LOGINPAGE:
      case WebViewState.INITIAL_VALUE:
      case WebViewState.REQ_LOGINPAGE:
      case WebViewState.UNDEFINED_LOCATION:
      case WebViewState.LOGIN_FAILED:
        return 0.0;
      case WebViewState.REQ_HOMEPAGE:
        return 0.1;
      case WebViewState.REQ_LISTMATRICULAS:
        return 0.2;
      case WebViewState.REQ_ACOESMATRICULAS:
        return 0.5;
      case WebViewState.REQ_INSCRICOESRESULTADOS:
        return 0.8;
      case WebViewState.REQ_RESUMOINSCRICOESRESULTADOS:
        return 0.9;
    }
  }

  String _getDisplayText() {
    switch (widget._state) {
      case WebViewState.LOGIN_FAILED:
        return "Não foi possível fazer login. Verifique os seus dados e tente novamente.";
      case WebViewState.INITIAL_VALUE:
        return "Carregando...";
      case WebViewState.REQ_LOGINPAGE:
        return "Acessando a página inicial do SIGA...";
      case WebViewState.ISAT_LOGINPAGE:
        return "Insira os seus dados";
      case WebViewState.REQ_HOMEPAGE:
        return "Acessando o SIGA... [1/6]";
      case WebViewState.REQ_LISTMATRICULAS:
        return "Acessando o SIGA... [2/6]";
      case WebViewState.REQ_ACOESMATRICULAS:
        return "Acessando o SIGA... [3/6]";
      case WebViewState.REQ_INSCRICOESRESULTADOS:
        return "Acessando o SIGA [4/6]";
      case WebViewState.REQ_RESUMOINSCRICOESRESULTADOS:
        return "Acessando o SIGA [5/6]";
      case WebViewState.UNDEFINED_LOCATION:
        return "Ocorreu um erro.";
    }
  }

  InputDecoration _getInputDecoration(String labelText) => InputDecoration(
        hintText: labelText,
      );

  User _coleta(String s) {
    User output = User.internal();
    UserHelper _userHelper = UserHelper();
    //TODO ARRUMA ISSO AI
    String cleanData = "";
    s = s.replaceAll(contrabarra + 'u003C', "<");
    //buscando numero maximo de rows da tabela
    int io = int.parse(s
        .split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[
            1]
        .split("</" + "body>")[0]
        .split('id=' +
            contrabarra +
            '"inscricao-resultados-form:atividades-inscritas-table:')[(s
                .split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[
                    1]
                .split("</" + "body>")[0]
                .split('id=' +
                    contrabarra +
                    '"inscricao-resultados-form:atividades-inscritas-table:')
                .length -
            2)]
        .split(":j_idt")[0]);
    //encontrando a tabela

    String i = s
        .split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[
            1]
        .split("</" + "body>")[0]
        .split('id=' +
            contrabarra +
            '"inscricao-resultados-form:atividades-inscritas-table:${io}:j_idt171')[0]
        .replaceAll(contrabarra + 'u003C', "<")
        .replaceAll("<td", "<>TD<")
        .replaceAll("<tr", "<>TR<")
        .replaceAll('class=\\"rf-dt-c\\"', "");

    for (int j = 0; j < i.replaceAll(">", "<").split("<").length; j++) {
      if (j % 2 == 0)
        cleanData += "<sploint>" + i.replaceAll(">", "<").split("<")[j];
    }

    var aux;
    do {
      aux = cleanData;
      cleanData = cleanData.replaceAll("<sploint><sploint>", "<sploint>");
      cleanData = cleanData.replaceAll(contrabarra + contrabarra, contrabarra);
      cleanData = cleanData.replaceAll(' ' + contrabarra, contrabarra);
      cleanData = cleanData.replaceAll("  ", " ");
      cleanData = cleanData.replaceAll(
          contrabarra + "t" + contrabarra + "t", contrabarra + "t");
    } while (cleanData != aux);
    aux = cleanData.split("<sploint>");
    cleanData = "";
    for (int j = 0; j < aux.length; j++) {
      if (aux[j] != contrabarra + "n" + contrabarra + "t" &&
          aux[j] != contrabarra + "n") cleanData += aux[j] + "\n";
    }
    int td = -1;

    List<Map<String, String>> mapList = new List<Map<String, String>>();
    Map<String, String> mapaDasAulas = {
      "Aula": "",
      "Turma": "",
      "Dias/Horarios": "",
      "Ministrantes": "",
      "Operacoes": ""
    };
    Map<String, String> mapaDeChecagem = mapaDasAulas;
    List<String> lista = [
      "Aula",
      "Turma",
      "Dias/Horarios",
      "Ministrantes",
      "Operacoes"
    ];

    // O for se inicia no '7' para que conteúdo desnecessário da página seja pulado.
    // Este valor não possui significado lógico e sim estrutural.
    cleanData += "\nTR";
    for (int j = 7; j < cleanData.split("\n").length; j++) {
      if (cleanData.split("\n")[j] == "TR") {
        if (mapaDasAulas != mapaDeChecagem) {
          mapList.add(mapaDasAulas);
        }
        mapaDasAulas = {
          "Aula": "",
          "Turma": "",
          "Dias/Horarios": "",
          "Ministrantes": "",
          "Operacoes": ""
        };
      } else if (cleanData.split("\n")[j] == "TD") {
        td++;
      } else {
        mapaDasAulas[lista[td % 5]] += cleanData.split("\n")[j].trim() + "\n";
      }
    }

    output.materias = mapList;
    this.user.materias = mapList;
    this.user.mat = _userHelper.subjectParser(mapList.toString());

    return this.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widgets.Text("Página de login"),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(top: 25),
          child: Center(
            child: Form(
              key: _key,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _getDisplayText(),
                      style: TextStyle(fontSize: 15),
                      textAlign: TextAlign.center,
                    ),
                    LinearProgressIndicator(
                      value: _getProgress(),
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation(Colors.red),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (str) =>
                          str.isEmpty ? "Insira o seu RA ou CPF." : null,
                      decoration: _getInputDecoration('Login (CPF ou RA)'),
                      controller: _loginTextController,
                      keyboardType: TextInputType.number,
                      enabled: widget._state == WebViewState.ISAT_LOGINPAGE ||
                          widget._state == WebViewState.LOGIN_FAILED,
                    ),
                    TextFormField(
                      validator: (str) =>
                          str.isEmpty ? "Insira a sua senha." : null,
                      decoration: _getInputDecoration('Senha'),
                      obscureText: true,
                      controller: _passwordTextController,
                      enabled: widget._state == WebViewState.ISAT_LOGINPAGE ||
                          widget._state == WebViewState.LOGIN_FAILED,
                    ),
                    RaisedButton(
                      child: Text("Fazer login"),
                      onPressed:
                          (widget._state == WebViewState.ISAT_LOGINPAGE ||
                                  widget._state == WebViewState.LOGIN_FAILED)
                              ? () {
                                  if (_key.currentState.validate()) {
                                    print("Botão pressionado");
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    this.user.ra = _loginTextController.text;

                                    // Ativa o WebView
                                    this._webViewController.evaluateJavascript(
                                        "document.getElementById('login:usuario').value = '" +
                                            _loginTextController.text +
                                            "';");
                                    this._webViewController.evaluateJavascript(
                                        "document.getElementById('login:password').value = '" +
                                            _passwordTextController.text +
                                            "';");
                                    this._webViewController.evaluateJavascript(
                                        "document.getElementById('login:loginButton').click();");
                                  }
                                }
                              : null,
                    ),
//                  Text(
//                    widget._routeStr,
//                    style: TextStyle(fontSize: 10),
//                    textAlign: TextAlign.center,
//                  ),
                    Visibility(
                      child: Container(
                          // O tamanho definido é arbitrário
                          // efetivamente, nada será mostrado na tela
                          height: 400,
                          width: 400,
                          child: this._createWebView(
                              "https://sistemas.ufscar.br/siga/login.xhtml",
                              this._onPageStartedFunct,
                              this._onPageFinishedFunct)),
                      maintainState: true,
                      visible: false,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
