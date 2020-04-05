import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:core';
import 'package:flutter_radio/flutter_radio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:ufscarplanner/components/wave_background.dart';

class RadioPage extends StatefulWidget {
  @override
  _RadioPageState createState() => _RadioPageState();
}

class _RadioPageState extends State<RadioPage> {

  // More radios can be added here
  final List<Map<String, String>> radios = [
    // FIXME Não funciona {'radio': 'Rádio UFSCar', 'url': 'https://www.radio.ufscar.br:8443/radioufscar96.mp3'},
    {'radio': 'Clássica', 'url': 'https://uk3.internet-radio.com/proxy/saglioc?mp=/stream;'},
    {'radio': 'EDM', 'url': 'https://uk6.internet-radio.com/proxy/realdanceradio?mp=/live'},
    {'radio': 'Jazz', 'url': 'https://us4.internet-radio.com/proxy/wsjf?mp=/stream;'},
    {'radio': 'Lo-fi 1', 'url': 'https://stream.laut.fm/lofi?ref=radiode'},
    {'radio': 'Lo-fi 2', 'url': 'https://streaming.liveonline.radio/lofi-hiphop-radio'},
  ];

  int _currentRadioIndex = 3;
  bool isPlaying = false;
  bool awaiting = false;

  @override
  void initState() {
    super.initState();
    FlutterRadio.audioStart();
  }

  List<DropdownMenuItem<int>> _getItens() {
    List<DropdownMenuItem<int>> itens = [];

    for (int i = 0; i < radios.length; i++)
      itens.add(DropdownMenuItem<int>(
        child: Container(
          margin: EdgeInsets.only(right: 7),
          child: Text(
            radios[i]['radio'],
            style: TextStyle(color: Colors.white),
          ),
        ),
        value: i,
      ));

    return itens;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Background(Theme.of(context)),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text("Escolha uma rádio para escutar", style: TextStyle(color: Colors.white, fontSize: 18)),
                SizedBox(height: 20,),
                Theme(
                  data: ThemeData(
                    canvasColor: Color(0xDD000000),
                  ),
                  child: DropdownButton<int>(
                    icon: Icon(Icons.radio),
                    iconEnabledColor: Colors.white,
                    underline: Container(color: Colors.white, height: 1.0),
                    value: _currentRadioIndex,
                    items: _getItens(),
                    onChanged: (index) async {
                      if (isPlaying) {
                        await FlutterRadio.stop();
                        await FlutterRadio.play(url: radios[index]['url']);
                      }
                      setState(() => _currentRadioIndex = index);
                    },
                  ),
                ),
                IconButton(
                  iconSize: 60,
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_circle_filled,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    if (isPlaying)
                      await FlutterRadio.stop();
                    else
                      await FlutterRadio.play(
                          url: radios[_currentRadioIndex]['url']);

                    setState(() {
                      isPlaying = isPlaying ? false : true;
                    });
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
