import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  String text;

  void _changeText(String s) {
    setState(() {
      _controller.text = s;
    });
  }

  final TextEditingController _controller = TextEditingController();

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
        // FIXME ja to tentando arrumar blz
        /*
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
        NAO POSTA ESSA PORRA
        TEM A SENHA DO RAMOS
        TODO TODO PARA COM ISSO PORRA


         */

        http.Response alcool = await http.get(
            'https://sistemas.ufscar.br/siga/login.xhtml',
            headers: {
              'Host': 'sistemas.ufscar.br',
              'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0',
              'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
              'Accept-Language': 'pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3',
              'Accept-Encoding': 'gzip, deflate, br',
              'Referer': 'https://sistemas.ufscar.br/siga/paginas/home.xhtml',
              'DNT': '1',
              'Connection': 'keep-alive',
              'Upgrade-Insecure-Requests': '1'
            }
        );

        print("COOKIE MONSTER WANT " + alcool.headers.toString());
        var cookie = alcool.headers['set-cookie'].split('JSESSIONID=')[1].split(';')[0];
        print("cok " + cookie);

        http.Response response = await http.post(
            'https://sistemas.ufscar.br/siga/login.xhtml',
            headers: {
              'Host': 'sistemas.ufscar.br',
              'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0',
              'Accept': '*/*',
              'Accept-Language': 'pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3',
              'Accept-Encoding': 'gzip, deflate, br',
              'Faces-Request': 'partial/ajax',
              'Content-type': 'application/x-www-form-urlencoded;charset=UTF-8',
              'Content-Length': '505',
              'Origin': 'https://sistemas.ufscar.br',
              'DNT': '1',
              'Connection': 'keep-alive',
              'Referer': 'https://sistemas.ufscar.br/siga/login.xhtml',
              'Cookie': 'JSESSIONID='+cookie+';'
            },
            body: {
              'login': 'login',
              'javax.faces.ViewState': '-3906064097761691964:-5578141727260975006',
              'org.richfaces.focus': 'login:loginButton login',
              'login:usuario': '',
              'login:password': '',
              'javax.faces.source': 'login:loginButton',
              'javax.faces.partial.event': 'click',
              'javax.faces.partial.execute': 'login:loginButton @component',
              'javax.faces.partial.render': '@component',
              'org.richfaces.ajax.component': 'login:loginButton',
              'login:loginButton': 'login:loginButton',
              'rfExt': 'null',
              'AJAX:EVENTS_COUNT': '1',
              'javax.faces.partial.ajax': 'true'
            });

        http.Response cesar = await http.get(
          'https://sistemas.ufscar.br/siga/paginas/home.xhtml',
          headers: {
            'Host': 'sistemas.ufscar.br',
            'User-Agent': 'Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:73.0) Gecko/20100101 Firefox/73.0',
            'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
            'Accept-Language': 'pt-BR,pt;q=0.8,en-US;q=0.5,en;q=0.3',
            'Accept-Encoding': 'gzip, deflate, br',
            'DNT': '1',
            'Connection': 'keep-alive',
            'Referer': 'https://sistemas.ufscar.br/siga/login.xhtml',
            'Cookie': 'JSESSIONID='+cookie+';',
            'Upgrade-Insecure-Requests': '1'
          }
        );

        print("LOGIN QUE " + cesar.body.split('login')[1]);
        print("CESÁR: " + cesar.body.split('candidato-jubilamento-popup')[1]);
        String cid = cesar.body.split('action="/siga/paginas/aluno/listMatriculas.xhtml?cid=')[0];
        print("TA AQUI O CID OH " + cid);

        /*http.Response ednaldo = await http.post(
            'https://sistemas.ufscar.br/siga/paginas/aluno/acoesMatricula.xhtml?cid=' + cid,
            headers: {
              'Host': 'sistemas.ufscar.br',
              'User-Agent': 'Ricardo Menotti Browser v0.1',
              'Accept': 'text/plain',
              'Accept-Encoding': 'plain',
              'Origin': 'https://sistemas.ufscar.br',
              'Cookie': 'JSESSIONID=aQwjIlulfldnbcy5G5ewl8SK; csfcfc=tZ3ZAsEHvMc%3D; ga=GA1.2.357381401.1553744638; _pk_id.9.f1a8=5139c238472f6883.1558054540.13.1583986831.1583983923.; _pk_ses.9.f1a8=1'
            },
            body: {
              'acoes-matriculas-form': 'acoes-matriculas-form',
              'javax.faces.ViewState': '-6602081005325861943:4124917805817902599',
              'org.richfaces.focus': 'login:loginButton login',
              'javax.faces.source': 'acoes-matriculas-form:solicitacao-inscricao-link',
              'javax.faces.partial.event': 'click',
              'javax.faces.partial.execute': 'acoes-matriculas-form:solicitacao-inscricao-link @component',
              'javax.faces.partial.render': '@component',
              'org.richfaces.ajax.component': 'acoes-matriculas-form:solicitacao-inscricao-link',
              'acoes-matriculas-form:solicitacao-inscricao-link': 'acoes-matriculas-form:solicitacao-inscricao-link',
              'rfExt': '1',
              'AJAX:EVENTS_COUNT': '1',
              'javax.faces.partial.ajax': 'true'
            });

        http.Response ciferri = await http.post(
            'https://sistemas.ufscar.br/siga/paginas/aluno/inscricoesResultados.xhtml?cid=' + cid,
            headers: {
              'Host': 'sistemas.ufscar.br',
              'User-Agent': 'Ricardo Menotti Browser v0.1',
              'Accept': 'text/plain',
              'Accept-Encoding': 'plain',
              'Origin': 'https://sistemas.ufscar.br',
              'Cookie': 'JSESSIONID=aQwjIlulfldnbcy5G5ewl8SK; csfcfc=tZ3ZAsEHvMc%3D; ga=GA1.2.357381401.1553744638; _pk_id.9.f1a8=5139c238472f6883.1558054540.13.1583986831.1583983923.; _pk_ses.9.f1a8=1'
            },
            body: {
              'inscricao-resultados-form': 'inscricao-resultados-form',
              'javax.faces.ViewState': '5892697975601029891:1975318493397231398',
              'inscricao-resultados-form:j': 'idt104-value	inscricao-resultados-form:j_idt105',
              'javax.faces.source': 'inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113',
              'javax.faces.partial.event': 'click',
              'javax.faces.partial.execute': 'inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113 @component',
              'javax.faces.partial.render': '@component',
              'org.richfaces.ajax.component': 'inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113',
              'inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113':	'inscricao-resultados-form:periodo-regular-andamento-table:0:j_idt113',
              'rfExt': 'null',
              'AJAX:EVENTS_COUNT': '1',
              'javax.faces.partial.ajax': 'true'
            });

        http.Response marcela = await http.get(
            'https://sistemas.ufscar.br/siga/paginas/aluno/resumoInscricoesResultados.xhtml?cid=' + cid,
            headers: {
              'Host': 'sistemas.ufscar.br',
              'User-Agent': 'Ricardo Menotti Browser v0.1',
              'Accept': 'text/plain',
              'Accept-Encoding': 'plain',
              'Origin': 'https://sistemas.ufscar.br',
              'Cookie': 'JSESSIONID=aQwjIlulfldnbcy5G5ewl8SK; csfcfc=tZ3ZAsEHvMc%3D; ga=GA1.2.357381401.1553744638; _pk_id.9.f1a8=5139c238472f6883.1558054540.13.1583986831.1583983923.; _pk_ses.9.f1a8=1'
            }
        );*/

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
        children: <Widget>[
          this.loginButton,
          SingleChildScrollView(
            child: Text(text??"null"),
          )
        ],
      ),
    );
  }
}
