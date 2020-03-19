import 'package:flutter/material.dart';
import 'package:html/parser.dart'; //
import 'package:http/http.dart' as http;
import 'package:ufscarplanner/ui/news_page.dart';
import 'package:async/async.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class PaginaNoticias extends StatefulWidget {
  @override
  _PaginaNoticiaState createState() => _PaginaNoticiaState();
}
class AuxMap{
  AuxMap(String data,String link,String titulo,String autor,String texto){

    this.map= {"Data": data.trim(), "Link": link.trim(), "Titulo": titulo.trim(),"Autor":autor.trim(),"Texto":texto.trim()};
  }
  Map<String,String> map;
  factory AuxMap.fromJson(Map<String, dynamic> json) {
    return new AuxMap(json["Data"],json["Link"], json["Titulo"],json["Autor"],json["Texto"]);
  }

  Map toJson() => {
    "Data": map["Data"], "Link": map["Link"], "Titulo": map["Titulo"],"Autor":map["Autor"],"Texto":map["Texto"]
  };
}
class _PaginaNoticiaState extends State<PaginaNoticias> {

  final AsyncMemoizer _memoizer = AsyncMemoizer();
  String userDataFilename = "Newsdata.json";

  Future<String> get _filePath async {
    var directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }
  Future<File> get _file async =>
      File(await _filePath + "/" + userDataFilename);

  Future<List<Map<String, String>>> intermediate(String url) async{
    var future;
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile||connectivityResult == ConnectivityResult.wifi) {
      print("\n\n\n\nTEM NET GENTE\n\n\n\n\n");
      await getLinks(url).then((valor)async{
        await  writeRawData(json.encode(valor));
        await readRawData().then((data){
          Iterable l = json.decode(data);
          Map<String, dynamic> a = new Map<String, dynamic>();
          setState(() {

            List<AuxMap> aux = l.map(( a)=> AuxMap.fromJson(a)).toList();
            future =new  List<Map<String,String>>();
            for(int i=0;i<aux.length;i++){
              future.add(aux[i].map);
            }
            print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Hello\n"+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n${ future.toString()} ");

          });
        });
      });

    }else{
      print("\n\n\n\n N TEM NET GENTE\n\n\n\n\n");
      await readRawData().then((data){
        Iterable l = json.decode(data);
        Map<String, dynamic> a = new Map<String, dynamic>();
        setState(() {
          List<AuxMap> aux = l.map(( a)=> AuxMap.fromJson(a)).toList();
          future =new  List<Map<String,String>>();
          for(int i=0;i<aux.length;i++){
            future.add(aux[i].map);
          }
          print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n Hey\n"+"\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n${ future.toString()} ");

        });
      });
      print("BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB");
    }
    print("iiiiiiiii\ni\nii\niiii\niiii\niiiiiiiiii\n\n\n\n\n\n");
    return await future;
  }

  Future<File> writeRawData(String rawData) async {
    final file = await _file;
    return await file.writeAsString(rawData);
  }

  Future<String> readRawData() async {
    try {
      final file = await _file;
      return await file.readAsString();
    } catch (e) {
      print(e);
      return null;
    }
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
          future: this._memoizer.runOnce(() => intermediate('https://www2.ufscar.br/noticias')),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
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
                              snapshot.data[index]["Data"] +
                                  " | " +
                                  snapshot.data[index]["Autor"],
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
