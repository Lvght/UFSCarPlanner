import 'package:http/http.dart'; // Contains a client for making API calls
import 'package:html/parser.dart';
import 'package:ufscarplanner/models/meal.dart';


class DataScrapper {
  DataScrapper(this._url);

  List<Meal> meals;
  String _url;

  // Método para obter os dados
  Future<List<Meal>> initiate() async {
    var client = Client();
    Response response = await client.get(this._url);

    var document = parse(response.body);

    print(document.querySelectorAll('#content'));
    meals = find(response);
//    debugPrint("Meals = ${meals.toString()}]");
//    debugPrint("Tamanho do meals = ${meals.length}");
    return meals;
  }

  List<Meal> find(Response response) {
    String aux;
    String cleanData;
    List<Meal> mealList;
    List<String> auxList;
    List<String> extractedMealStringList;
    List<String> rawData = response.body.split('<div id="cardapio">');
    rawData.removeAt(0);

    // Remove todas as tags e símbolos indesejados
    cleanData = rawData.toString().replaceAll("<b>", "");
    cleanData = cleanData.toString().replaceAll("</b>", "");
    cleanData = cleanData.toString().replaceAll("<div>", "");
    cleanData = cleanData.toString().replaceAll("</div>", "");
    cleanData = cleanData.toString().replaceAll('<div class="cardapio_titulo">', "");

    /*
     * Remove os espaços duplicados.
     * Note que a remoção ocorre mais rapidamente na variável [aux], sendo que esta fica resposnável pela
     * condição de parada.
     */
    do {
      cleanData = cleanData.toString().replaceAll('  ', ' ');
      aux = cleanData.toString().replaceAll('  ', ' ');
    } while (cleanData != aux);

    // Remove os símbolos indesejados remanescentes
    cleanData = cleanData.toString().replaceAll("\n \n \n", "\n");
    cleanData = cleanData.toString().replaceAll("\n - \n", "\n");
    cleanData = cleanData.toString().replaceAll("\n : \n", "\n");
    cleanData = cleanData.toString().replaceAll("<span>", "");
    cleanData = cleanData.toString().replaceAll("</span>", "");

    // Extrai a string de cada refeição
    // note que o conteúdo do site está dentro de um único artigo
    extractedMealStringList = cleanData.toString().split('</article>');
    extractedMealStringList = extractedMealStringList.toString().split('<div class="col-lg-7 metade periodo">');

    // Remove as informações posteriores ao cardápio
    extractedMealStringList.removeLast();

    // Limpa dados remanescentes
    extractedMealStringList.removeAt(0);

    mealList = List<Meal>(extractedMealStringList.length);

    // Roda o loop uma vez para cada opção do cardápio
    for (int i = 0; i < extractedMealStringList.length; i++) {
      auxList = extractedMealStringList[i].split("\n");

      // Alguns campos são compostos por apenas espaços
      // Como há espaços repetidos, a condição para removê-los é o tamanho ser menor que 3.
      // Isso não afetará os campos com informações relevantes.
      for (int j = 0; j < auxList.length; j++)
        if (auxList[j].length < 3)
          auxList.removeAt(j);

      mealList[i] = new Meal(auxList[0], auxList[1], auxList[2], auxList.sublist(3, auxList.length - 1));
    }

//    print("Refeições has lenght of ${mealList.length}");
    return mealList;
  }
}
