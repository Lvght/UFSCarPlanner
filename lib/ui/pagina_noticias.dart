import 'package:flutter/material.dart';
import 'package:html/parser.dart'; //
import 'package:http/http.dart' as http;
import 'package:ufscarplanner/ui/news_page.dart';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:hive/hive.dart';
class PaginaNoticias extends StatefulWidget {
  @override
  _PaginaNoticiaState createState() => _PaginaNoticiaState();
}
class AuxMap{
  AuxMap(String data,String link,String titulo,String autor,String texto){
    this.map= {"Data": data.trim(), "Link": link.trim(), "Titulo": titulo.trim(),"Autor":autor.trim(),"Texto":texto.trim()};
  }
  Map<String,String> map;


}
class _PaginaNoticiaState extends State<PaginaNoticias> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();

  Future<List<Map<String, String>>> get_news(String url) async{
    final newsBox = await Hive.box("news");
    var listOfNews;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
//      print("\n\n\n\nTEM NET GENTE\n\n\n\n\n");
      await getLinks(url).then((valor)async{
        for(int i=0 ;i<valor.length;i++) {
          newsBox.put(i,valor[i]);
        }

        print("\n\n\n\n");

          listOfNews =new  List<Map<String,String>>();
          print(newsBox.length.toString()+"  "+valor.length.toString());
          for (int i = 0; i < newsBox.length; i++) {
            Map<String, String> auxNews = Map.from(newsBox.get(i));
            listOfNews.add(auxNews);
          }
//            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Hello\n"+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n${ listOfNews.toString()} ");


      });

    }else{
      print("\n\n\n\n N TEM NET GENTE\n\n\n\n\n");

        if(newsBox.length!=0) {
          listOfNews = new List<Map<String, String>>();
          for (int i = 0; i < newsBox.length; i++) {
            Map<String, String> auxNews = Map.from(newsBox.get(i));
            listOfNews.add(auxNews);
            print(listOfNews[i].toString());
          }
        }else{
          listOfNews = new List<Map<String, String>>();
          listOfNews.add(new Map<String,String>());
        }


    }
    await setState(() {});
    return await  listOfNews;
  }


  Future<List<Map<String, String>>> getLinks(String url) async {
    List<String> S;
    http.Response response = await http.get(url);
    String rawData;

    String a = "\u005C";

      S=  response.body.replaceAll(a + 'u003C', "<")
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
        //  debugPrint("B: " + B.toString());
         // debugPrint("C :" + C.toString());
        }
        // debugPrint(B.toString());
      }
    }
    //TODO CHAMAR DECENTEMENTE ESSA FUNÇÃO
    //TODO ONSTRUIR OS WIDGETS
    //debugPrint(D.toString());
    return await D;
  }

  Future<Map<String, String>> LoadNews(String url) async {
    http.Response response = await http.get(url);

    Map<String, String> E = {"Autor": "", "Texto": ""};
    E["Autor"] = response.body
        .split('<div class="autor">')[1]
        .split("</" + "i>")[0]
        .replaceAll("<i>", "")
        .replaceAll("\n", "");
    var aux = response.body
        .split('<div class="texto">')[1]
        .split("</" + "div>")[0]
        //.replaceAll("<br>", "--------------------")
        .replaceAll("<strong>", "<sploint><strong><sploint>")
        .replaceAll("<em>", '<sploint><em><sploint>')
        .replaceAll("<br />", "\n")
        .replaceAll("</" + "strong>", "<sploint></strong><sploint>")
        .replaceAll("</" + "em>", "<sploint></em><sploint>")
        .replaceAll("<u>", "<sploint><u><sploint>")
        .replaceAll("</u>", "<sploint></u><sploint>")
        .replaceAll("<a>", "<sploint><a><sploint>")
        .replaceAll("</a>", "<sploint></a><sploint>");
    E["Texto"] = aux;
    return E;
  }

  TextStyle _titleStyle() => TextStyle(fontSize: 17);

  TextStyle _subtitleStyle() => TextStyle(fontSize: 13, color: Colors.black26);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: FutureBuilder(
          future: this._memoizer.runOnce(() => get_news('https://www2.ufscar.br/noticias')),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                );
              default:
                return ListView.builder(
                  itemBuilder: (BuildContext context, int index) {
                    return FlatButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsPage(
                                    snapshot.data[index]["Titulo"],
                                    snapshot.data[index]["Autor"],
                                    snapshot.data[index]["Data"],
                                    snapshot.data[index]["Texto"],
                                  ))),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(10, 0, 10, 15),
                        padding: EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black26))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              snapshot.data[index]["Titulo"],
                              style: _titleStyle(),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              snapshot.data[index]["Data"].trim() +
                                  " | " +
                                  snapshot.data[index]["Autor"].trim(),
                              style: _subtitleStyle(),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  itemCount:snapshot.data==null? 0:snapshot.data.length - 1,
                );
            }
          }),
    );
  }
}
