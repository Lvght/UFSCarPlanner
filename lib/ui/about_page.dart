import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gradient_app_bar/gradient_app_bar.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: Text("UFSCar App Alpha"),
        backgroundColorStart: Colors.red,
        backgroundColorEnd: Colors.redAccent,
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start  ,
            children: <Widget>[
              Text("Este aplicativo não possui nenhum vínculo com a UFSCar", textAlign: TextAlign.center, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              SizedBox(height: 40,),
              Text("Autores", textAlign: TextAlign.left, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),),
              SizedBox(height: 5,),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Matheus Ramos de Carvalho", style: TextStyle(fontSize: 22),),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.redAccent,
                          ),
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          child: Text("BCC 19", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                        )
                      ],
                    ),
                    SizedBox(height: 20,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Vinicius Quaresma da Luz", style: TextStyle(fontSize: 22),),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            color: Colors.redAccent,
                          ),
                          padding: EdgeInsets.fromLTRB(4, 2, 4, 2),
                          child: Text("BCC 19", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),),
                        )
                      ],
                    )
                  ],
                ),
              )
          ],
          ),
        ),
      ),
    );
  }
}
