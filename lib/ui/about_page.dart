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
            children: <Widget>[
              Text("Este aplicativo não possui nenhum vínculo com a UFSCar", textAlign: TextAlign.center,),
              SizedBox(height: 40,),
              Text("App desenvolvido por:", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10,),
              Text("Matheus Ramos de Carvalho @BCC_019", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              Text("Vinicius Quaresma da Luz @BCC_019", style: TextStyle(fontSize: 16), textAlign: TextAlign.center,),
              SizedBox(height: 30,),
              Text("Aplicativo em desenvolvimento! Não redistribua o pacote de instalação deste aplicativo. Destinado a fins de teste apenas. Quando orientado, desinstale este aplicativo de seu aparelho.", style: TextStyle(fontSize: 10), textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}
