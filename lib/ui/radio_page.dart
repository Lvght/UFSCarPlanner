import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:core';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {
  String radio;

  String streamUrl = "https://stream.laut.fm/lofi?ref=radiode";

  List<String> radioList = ["Radio Ufscar", "Lo fi"];
  List<String> listaUrl = ["https://www.radio.ufscar.br:8443/radioufscar96.mp3", "https://stream.laut.fm/lofi?ref=radiode"];
  bool isPlaying;
  bool awaiting = false;

  @override
  void initState() {
    super.initState();
    audioStart();
    playingStatus();
  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print('Audio Start OK');
  }

  double volume = 1;

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        debugShowCheckedModeBanner: false,
        home: new Scaffold(
          body: new Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              DropdownButton<String>(
                value: radio,
                items: radioList.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String value) async {
                  radio = value;
                  FlutterRadio.stop();
                  streamUrl = listaUrl[radioList.indexOf(radio)];
                  await FlutterRadio.isPlaying().then((valor) {
                    setState(() {
                      isPlaying = valor;
                    });
                  });
                },
              ),
              Center(
                  child: Icon(
                Icons.radio,
                size: MediaQuery.of(context).size.width * 0.9,
              )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  isPlaying == null || isPlaying == false
                      ? FlatButton(
                          child: Icon(
                            Icons.play_circle_filled,
                            size: MediaQuery.of(context).size.width * 0.2,
                          ),
                          onPressed: () async {
                            if (!await FlutterRadio.isPlaying()) {
                              await FlutterRadio.play(url: streamUrl).then((value) {
                                setState(() {
                                  isPlaying = true;
                                  print("Play");
                                });
                              });
                            }
                          },
                        )
                      : FlatButton(
                          child: Icon(Icons.pause_circle_filled, size: MediaQuery.of(context).size.width * 0.2),
                          onPressed: () async {
                            if (await FlutterRadio.isPlaying()) {
                              await FlutterRadio.stop().then((value) {
                                setState(() {
                                  isPlaying = false;
                                  print("Pause");
                                });
                                //  playingStatus();
                              });
                            }
                          },
                        )
                ],
              ),
            ]),
          ),
        ));
  }

  Future playingStatus() async {
    setState(() {
      print("------------------------------->" + isPlaying.toString());
    });
  }
}

Future<void> audioStart() async {
  await FlutterRadio.audioStart();
  print("deu bom o radio");
}
