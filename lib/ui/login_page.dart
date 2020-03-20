import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:http/http.dart';
import 'package:ufscarplanner/helpers/MateriaHelper.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:ufscarplanner/helpers/UserData.dart';

const String menorQue = "\\u003C";
const String contrabarra = "\u005C";

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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

  void _onPageStartedFunct(String url) async {
    //TODO TRATAR FALTA DE INTERNET
    print("Carregando a página: $url");
  }

  void _onPageFinishedFunct(String url) async {
    final userHelper = UserHelper();

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
      // await userHelper.writeRawData(_coleta(_cleanData).toJson());
      await userHelper.saveUser(user);
      debugPrint("Hahaha : ${user.toJson()}");
      print("Os dados foram escritos\n");
      Navigator.pop(this.context);
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
      print("->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>" +
          this._rawData.split(
              "inscricao-resultados-form:atividades-inscritas-table:tb")[1]);
      this._webViewController.evaluateJavascript(
          "document.getElementById('logout-form:sair-link').click();");
      this._done = true;
    }

    print("Esta página foi carregada: $url");
  }

  InputDecoration _getInputDecoration(String labelText) =>
      InputDecoration.collapsed(
        hintText: labelText,
      );

  // List<Map<String, String>> _coleta(String s) {
  /*
   * String _nome;
   * String _ira;
   * String _ra;
   * List< Map<String, String> > _materias;
   */
  User _coleta(String s) {
    User output = User.internal();
    //TODO ARRUMA ISSO AI
    String cleanData = "";
    String i = s
        .split("Segue abaixo a lista de inscrições e resultados neste periodo letivo.")[
            1]
        .split(
            "inscricao-resultados-form:atividades-inscritas-table:5:j_idt171")[0]
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
    /* print("===============>"+mapList.toString());*/
    this.user.agendamento();
    output.agendamento();

    return this.user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: widgets.Text("Página de login"),
        ),
        body: Center(child: Card(
          color: Colors.white,
          child: Container(
            width:  MediaQuery.of(context).size.width*0.80,
            height:  MediaQuery.of(context).size.width*0.80,
            margin:EdgeInsets.fromLTRB(16, 16, 16,0) ,
          child: Column(
            children: <Widget>[
              TextField(
                decoration: _getInputDecoration('Login'),
                controller: _loginTextController,
                keyboardType: TextInputType.number,
              ),
              TextField(
                decoration: _getInputDecoration('Senha'),
                obscureText: true,
                controller: _passwordTextController,
              ),
              RaisedButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(Icons.check_circle),
                    widgets.Text("Fazer login")
                  ],
                ),
                onPressed: () {
                  print("Botão pressionado");

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
                },
              ),
              Visibility(
                child: Container(
                    // O tamanho definido é arbitrário
                    // efetivamente, nada será mostrado na tela
                    height: 20,
                    width: 20,
                    child: this._createWebView(
                        "https://sistemas.ufscar.br/siga/login.xhtml",
                        this._onPageStartedFunct,
                        this._onPageFinishedFunct)),
                maintainState: true,
                visible: false,
              ),
            ],
          ),
        ))));
  }
}
