import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:ufscarplanner/helpers/UserData.dart';
import 'package:ufscarplanner/ui/home_page.dart';

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
                value: Hive.box('preferences').get('darkmode', defaultValue: false),
                onChanged: (x){},
                activeColor: Colors.red,
              )
            ],
          ),
          widget.isLoggedIn?
          Row(
            children: <Widget>[
              Expanded(child: Text("Sair do siga")),
              RaisedButton(
                color: Colors.redAccent,
                textColor: Colors.white,
                child: Text("Clique aqui"),
                onPressed: () async {
                  UserHelper _userHelper = UserHelper();
                  await _userHelper.deleteFile();

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
              )
            ],
          ) : Container(),
        ],
      ),
    );
  }
}
