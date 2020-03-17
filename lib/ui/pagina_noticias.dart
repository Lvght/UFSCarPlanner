import 'package:flutter/material.dart';
import 'package:html/parser.dart'; //
import 'package:http/http.dart' as http;
import 'package:ufscarplanner/ui/news_page.dart';

class PaginaNoticias extends StatefulWidget {
  @override
  _PaginaNoticiaState createState() => _PaginaNoticiaState();
}

class _PaginaNoticiaState extends State<PaginaNoticias> {
  Future<List<Map<String, String>>> getLinks(String url) async {
    List<String> S;
    String rawData;
    http.Response response = await http.get(url);
    String a = "\u005C";
    S = await response.body
        .replaceAll(a + 'u003C', "<")
        .split('<tbody>')[1]
        .split("</" + "tbody>")[0]
        .replaceAll("</" + "td>", "")
        .replaceAll("</" + "tr>", "")
        .replaceAll("<td>", "TD")
        .replaceAll("<tr>", "TR")
        .replaceAll("href=", "")
        .replaceAll("<a", "")
        .replaceAll("</" + "a>", "")
        .split("TR");
    Map<String, String> B = {"Data": "", "Link": "", "Titulo": ""};
    Map<String, String> E, C = B;
    List<String> A = ["Data", "Link", "Titulo"];
    List<Map<String, String>> D = new List<Map<String, String>>();

    // print("s -   "+S.toString());
    for (int i = 0; i < S.length; i++) {
      B = {"Data": "", "Link": "", "Titulo": ""};
      if (S[i] != "") {
        B[A[0]] = S[i].split("TD")[1];
        B[A[1]] = S[i].split("TD")[2].split('"')[1];
        B[A[2]] = S[i].split("TD")[2].split('"')[2].replaceAll(">", "");
        E = await LoadNews(B["Link"]);
        B.addAll(E);
        var F = B;
        do {
          F = B;
          B[A[0]].replaceAll("  ", " ");
          B[A[1]].replaceAll("  ", " ");
          B[A[2]].replaceAll("  ", " ");
          B["Autor"].replaceAll("  ", " ");
          B["Texto"].replaceAll("  ", " ");
        } while (B != F);
        if (B != {"Data": "", "Link": "", "Titulo": ""}) {
          D.add(B);
        } else {
          debugPrint("B: " + B.toString());
          debugPrint("C :" + C.toString());
        }
        // debugPrint(B.toString());
      }
    }
    //TODO CHAMAR DECENTEMENTE ESSA FUNÇÃO
    //TODO ONSTRUIR OS WIDGETS
    debugPrint(D.toString());
    return await D;
  }

  Future<Map<String, String>> LoadNews(String url) async {
    http.Response response = await http.get(url);

    Map<String, String> E = {"Autor": "", "Texto": ""};
    E["Autor"] = response.body.split('<div class="autor">')[1].split("</" + "i>")[0].replaceAll("<i>", "").replaceAll("\n", "");
    var aux = response.body
        .split('<div class="texto">')[1]
        .split("</" + "div>")[0]
        .replaceAll("<br>", "\n")
        .replaceAll("<strong>", "")
        .replaceAll("<em>", '')
        .replaceAll("<br />", "")
        .replaceAll("</" + "strong>", "")
        .replaceAll("</" + "em>", "")
        .replaceAll("<u>", "")
        .replaceAll("</u>", "")
        .replaceAll('<a href="', "<sploint>")
        .replaceAll("</a>", "")
        .split("<sploint>");
    var ax = "";
    for (int i = 0; i < aux.length; i++) {
      if (aux[i].contains("<a")) {
        ax += aux[i].split("<a")[0];
        for (int j = 1; j < aux[i].split("<a")[1].split(">").length; j++) ax += aux[i].split("<a")[1].split(">")[j];
      } else {
        ax += aux[i];
      }
    }
    E["Texto"] = ax;

    return E;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getLinks('https://www2.ufscar.br/noticias'),
        builder: (BuildContext context, AsyncSnapshot<List<Map<String, String>>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            default:
              return ListView.builder(itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NewsPage(
                                snapshot.data[index]["Titulo"],
                                snapshot.data[index]["Autor"].trim(),
                                snapshot.data[index]["Data"].trim(),
                                snapshot.data[index]["Texto"],
                              ))),
                  child: ListTile(title: Text(snapshot.data[index]["Titulo"])),
                );
              });
          }
        });
  }
}
