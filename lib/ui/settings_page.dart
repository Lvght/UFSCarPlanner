import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ufscarplanner/ui/pagina_game.dart';
class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();

  SettingsPage(this.isLoggedIn);

  final bool isLoggedIn;
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text("Tema escuro")),
                Switch(
                  value: Hive.box('preferences')
                      .get('darkMode', defaultValue: false),
                  onChanged: (x) async {
                    await Hive.box('preferences').put('darkMode', x);
                  },
                  activeColor: Colors.red,
                )
              ],
            ),
            widget.isLoggedIn
                ? Row(
                    children: <Widget>[
                      Expanded(child: Text("Apagar dados do siga")),
                      IconButton(
                        icon: Icon(Icons.exit_to_app),
                        onPressed: () async {
                          UserHelper _userHelper = UserHelper();
                          await _userHelper.deleteFile();

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ),
                    ],
                  )
                : Container(),
            Row(
              children: <Widget>[
                Expanded(child: Text("Visite o repositório deste projeto")),
                IconButton(
                  icon: Icon(Icons.open_in_browser),
                  onPressed: () async {
                    await launch('https://github.com/vinql/UFSCarPlanner/');
                  },
                ),
              ],
            ),
            Divider(),
            GestureDetector(child:  Text("Autores", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),onDoubleTap: (){

              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyGame()));


            },),
            SizedBox(height: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Matheus Ramos de Carvalho",
                  style: TextStyle(fontSize: 22),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Image.asset(
                      "_assets/twitter.png",
                      height: 20,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    FlatButton(
                      onPressed: () async =>
                          await launch("https://twitter.com/oak_branches"),
                      padding: EdgeInsets.all(0),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      child: Text(
                        "@oak_branchs",
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: Theme.of(context).accentColor,
                      ),
                      padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                      child: Text(
                        "BCC 19",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    )
                  ],
                ),
              ],
            ),
            SizedBox(height: 20,),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Vinicius Quaresma da Luz",
                    style: TextStyle(fontSize: 22),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        "_assets/twitter.png",
                        height: 20,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      FlatButton(
                        onPressed: () async =>
                            await launch("https://twitter.com/vncsqrsm"),
                        padding: EdgeInsets.all(0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        child: Text(
                          "@vncsqrsm",
                          textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: Theme.of(context).accentColor,
                        ),
                        padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                        child: Text(
                          "BCC 19",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  '_assets/brasil.png',
                  height: 15,
                ),
                SizedBox(width: 10,),
                Text("Defenda a ciência brasileira.")
              ],
            )
          ],
        ),
      ),
    );
  }
}
