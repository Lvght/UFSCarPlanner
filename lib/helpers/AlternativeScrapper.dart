import 'package:http/http.dart' as http;

const String ruUrl = "https://www2.ufscar.br/restaurantes-universitario/cardapio";

enum tipoRefeicao { DESJEJUM, ALMOCO, JANTAR }

class Refeicao {
  String pratoPrincipal;
  String guarnicao;
  String arroz;
  String feijao;
  String saladas;
  String sobremesa;
  tipoRefeicao tipo;

  // Construtor
  Refeicao(this.pratoPrincipal, this.guarnicao, this.arroz, this.feijao,
      this.saladas, this.sobremesa, this.tipo);
}

// Limpa as tags HTML e símbolos reduntantes da String.
String clearString(String s) {
  String aux;
  List<String> splitResult;

  String rawData = s.replaceAll("<b>", "");
  rawData = rawData.toString().replaceAll("</" + "b>", "");
  rawData = rawData.toString().replaceAll("<div>", "");
  rawData = rawData.toString().replaceAll("</" + "div>", "");
  rawData = rawData.toString().replaceAll('<div class="cardapio_titulo">', "");

  // Note que 'aux' é varrido mais rapidamente
  do {
    rawData = rawData.replaceAll('  ', ' ');
    aux = rawData.replaceAll('  ', ' ');
  } while (aux != rawData);

  rawData = rawData.toString().replaceAll("\n \n \n", "\n");
  rawData = rawData.toString().replaceAll("\n - \n", "\n");
  rawData = rawData.toString().replaceAll("\n : \n", "\n");
  rawData = rawData.toString().replaceAll("<span>", "");
  rawData = rawData.toString().replaceAll("</span>", "");

  splitResult = rawData.split('<div class="col-lg-7 metade periodo">');
  splitResult.removeLast();
  splitResult.removeAt(0);

  return splitResult.toString();
}

Future<String> getHttpData(String url) async {
  List<String> splitResult;
  String rawData;
  http.Response response = await http.get(url);

  splitResult = response.body.split('<div id="#cardapio"');

  splitResult.removeAt(0);
  rawData = clearString(splitResult.toString());
  print(rawData);
  return response.body;
}

