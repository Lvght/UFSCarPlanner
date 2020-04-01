import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  //radio aleatória
String url ="https://playerservices.streamtheworld.com/api/livestream-redirect/JP_SP_AMAAC.aac";

bool isPlaying=false,isVisible=true;

  @override
  void initState() {
  super.initState();
  audioStart();
  }

  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  child: Icon(Icons.pause_circle_filled),
                  onPressed: () {FlutterRadio.pause();isPlaying=false;},
                ),FlatButton(
                  child: Icon(Icons.play_circle_filled),
                  onPressed: () {FlutterRadio.play(url: url);isPlaying=true;},
                )
              ],
            )
        ),
      ),
    );
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print("deu bom o radio");
  }
}
