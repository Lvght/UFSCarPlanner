import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:core';
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

String radio ;
String streamUrl = "https://playerservices.streamtheworld.com/api/livestream-redirect/JP_SP_AMAAC.aac" ;

    List<String> radioList= ["JovemPan","Audio Aleatório"];
    List<String> listaUrl = [ "https://playerservices.streamtheworld.com/api/livestream-redirect/JP_SP_AMAAC.aac" 
,"https://ia802708.us.archive.org/3/items/count_monte_cristo_0711_librivox/count_of_monte_cristo_001_dumas.mp3"];
bool isPlaying;
bool awaiting=false;
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
double volume=1;
@override
Widget build(BuildContext context) {

  return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
      body: new Center(
          child:Column( mainAxisSize: MainAxisSize.min,children : <Widget>[ DropdownButton<String>(
            value: radio,
            items: radioList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String value)async {
              radio = value;
              FlutterRadio.stop();
              streamUrl = listaUrl[radioList.indexOf(radio)];
              await FlutterRadio.isPlaying().then((valor) {
                setState(() {
                  isPlaying = valor;
                });

              });

            },
          ),Center(child: Icon(Icons.radio, size: MediaQuery.of(context).size.width*0.9,)), Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
               isPlaying==null||isPlaying==false?FlatButton(
                child: Icon(Icons.play_circle_filled,size: MediaQuery.of(context).size.width*0.2 ,),
                onPressed: ()async {
                  if(!await FlutterRadio.isPlaying()) {

                        await FlutterRadio.play(url: streamUrl).then((value) {
                          setState(() {
                            isPlaying = true;
                            print("Play");
                          });

                        });
                  }
                },
              ):

              FlatButton(
                child: Icon(Icons.pause_circle_filled,size: MediaQuery.of(context).size.width*0.2),
                onPressed: () async{
                  if(await FlutterRadio.isPlaying()) {
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
        print("------------------------------->"+isPlaying.toString());
      });


  }

  }

  Future<void> audioStart() async {
    await FlutterRadio.audioStart();
    print("deu bom o radio");
  }

