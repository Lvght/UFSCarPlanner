

import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart';// Contains HTML parsers to generate a Document object



class Meal {
  String day, date, type;
  List<String> lista;
  Map<String, dynamic> lista2;
  bool isBreakfast;

  Meal(this.date, this.day, this.type, this.lista) {
    isBreakfast = !( this.type.contains("ALMOÇO") || this.type.contains("JANTAR") );
  }

  @override
  String toString() {
    String listagem = "";
    for (int i = 0; i < lista.length; i++) listagem += lista[i] + '\n';
    return this.date + "\n" + this.day + "\n" + this.type + "\n" + listagem;
  }
}

class DataScrapper {
  DataScrapper(String url) {
    this._url = url;
  }

  List<Meal> meals;
  String _url;

  // Método para obter os dados
  Future<List<Meal>> initiate() async {
    var client = Client();
    Response response = await client.get(this._url);

    var document = parse(response.body);

    print(document.querySelectorAll('#content'));
    meals = find(response);
    //  print (meals.toString());
    print(document.querySelectorAll("#cardapio").toString().length);
    return meals;
  }

  List<Meal> find(Response response) {
    var s = response.body.split('<div id="cardapio">');
    s[0] = "";
    s.removeAt(0);
    var aux = s.toString().replaceAll("<b>", "");
    aux = aux.toString().replaceAll("</" + "b>", "");
    aux = aux.toString().replaceAll("<div>", "");
    aux = aux.toString().replaceAll("</" + "div>", "");
    aux = aux.toString().replaceAll('<div class="cardapio_titulo">', "");
    var ax;
    do {
      aux = aux.toString().replaceAll('  ', ' ');
      ax = aux.toString().replaceAll('  ', ' ');
    } while (aux != ax);
    aux = aux.toString().replaceAll("\n \n \n", "\n");
    aux = aux.toString().replaceAll("\n - \n", "\n");
    aux = aux.toString().replaceAll("\n : \n", "\n");
    aux = aux.toString().replaceAll("<span>", "");
    aux = aux.toString().replaceAll("</span>", "");
    var as = aux.toString().split('</article>');
    s = as.toString().split('<div class="col-lg-7 metade periodo">');
    s.removeLast();
    s.removeAt(0);
    var refeicoes = List<Meal>(s.length);
    for (int i = 0; i < s.length; i++) {
      var temp = s[i].split("\n");
      for (int j = 0; j < temp.length; j++) {
        if (temp[j].length < 3) {
          temp.removeAt(j);
        }
      }
      refeicoes[i] =
          new Meal(temp[0], temp[1], temp[2], temp.sublist(3, temp.length -1));
    }
    return refeicoes;
  }
}
