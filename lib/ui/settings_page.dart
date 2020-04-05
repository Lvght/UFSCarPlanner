import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/home_page.dart';
import 'package:url_launcher/url_launcher.dart';

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
      body: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(child: Text("Tema escuro")),
              Switch(
                value: Hive.box('preferences').get('darkMode', defaultValue: false),
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

                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
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
        ],
      ),
    );
  }
}
