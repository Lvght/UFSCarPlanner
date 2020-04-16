import 'dart:ffi';
import 'dart:math' as math;
import 'dart:ui';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:core';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/gestures.dart';
import 'package:flame/flame.dart';
import 'package:flame/position.dart';
import 'package:flame/sprite.dart';
import 'package:flame/text_config.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';

BuildContext contexto;

class Slider extends PositionComponent{
  
  double position;
  int value;
  Rect total,verde;
  List<Paint> paints = List<Paint>();
  Function function;
  static List<Slider> list;
  Slider( double posicao,Function fun,bool sfxOrMusic){

    value = sfxOrMusic?TheGame.sfx:TheGame.music;
    Paint white = new Paint(),green = new Paint();
    white.color = Color.fromRGBO(255, 255, 255, 100);
    green.color = Color.fromRGBO(0, 255, 200, 100);
    paints.add(white);
    paints.add(green);
    if(list==null)
      list=new List<Slider>();
    position = posicao;
    function = fun;
    list.add(this);
    total = Rect.fromCenter(center: Offset(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*position),width: MediaQuery.of(contexto).size.width*0.8, height: MediaQuery.of(contexto).size.height*0.02 );
    verde = Rect.fromLTWH(total.left, total.top,value*total.width/100 , total.height);
  }

  static void clickListener(Offset click){
    if(list!=null)
      for(int i =0;i<list.length;i++){
        if(list[i].total.contains(click)){
          list[i].value = (((click.dx-list[i].total.left)/(list[i].total.width))*100).floor();
          list[i].verde = Rect.fromLTWH(list[i].total.left, list[i].total.top,list[i].value*list[i].total.width/100 , list[i].total.height);
          list[i].function.call(list[i].value);
          TheGame.save();
          break;
        }
      }
  }

  @override
  void render(Canvas c) {
   c.drawRect(total,paints[0]);
   c.drawRect(verde, paints[1]);
   c.drawCircle(verde.centerRight, verde.height, paints[0]);
  }

  @override
  void update(double t) {

  }

  SliderDestroy(){
    list.remove(this);
    this.destroy();
  }

  static destroyAll(){
    if(list!=null)
      for(int i= 0;i<list.length;i++)
        list[i].SliderDestroy();
  }

  static renderAll(Canvas c){
    if(list!=null)
      for(int i= 0;i<list.length;i++)
        list[i].render(c);
  }
}

class Texto extends PositionComponent{

  TextConfig textConfig;
  String text;
  Position position;
  static List<Texto> list;
  Texto(double size, String texto, Position posicao){
    if(list==null)
      list=new List<Texto>();
    textConfig = new TextConfig(fontSize: size,color: Color.fromRGBO(255, 255, 255, 100));
    text = texto;
    position = posicao;
    list.add(this);

  }

  @override
  void render(Canvas c) {
    textConfig.render(c, text, position,anchor:  Anchor.center);

  }

  @override
  void update(double t) {

  }

  textDestroy(){
    list.remove(this);
    this.destroy();
  }

  static destroyAll(){
    if(list!=null)
      for(int i= 0;i<list.length;i++)
        list[i].textDestroy();
  }
  static renderAll(Canvas c){
    if(list!=null)
      for(int i= 0;i<list.length;i++)
        list[i].render(c);
  }
}

class Star extends PositionComponent {
  Color color;
  Paint _paint ;
  Rect rect;
  static List<Star> list;
  double step = 1;
  Star(double x,double y,double step) {

    this.step = step*MediaQuery.of(contexto).size.height/100;
    color = new Color.fromRGBO(255,255,255,step*100);
    _paint = Paint()
      ..color = color;
    if(list==null)
      list= new List<Star>();
    list.add(this);
    double size = MediaQuery.of(contexto).size.width*0.0005*(10+10);
    rect = new Rect.fromLTWH(x, y, size ,size);

  }
  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {
    rect = rect.shift(Offset(0, step));

    if(rect.center.dy>MediaQuery.of(contexto).size.height)
      starDestroy();
  }

  void starDestroy(){
    list.remove(this);
    this.destroy();
  }
}

class Enemy extends Player with Tapable{

  List<Paint> _paint = [
    Paint()
      ..color = const Color(0xFFFF0B10),
    Paint()
      ..color = const Color(0xFFFF0B10),
    Paint()
      ..color = const Color(0xFFFF5A00),
    Paint()
      ..color = const Color(0xFFFFCE00),
    Paint()
      ..color = const Color(0xFFD6FF00),
    Paint()
      ..color = const Color(0xFFA6FF00),
    Paint()
      ..color = const Color(0xFF06FF00),
  ];
  Sprite nave = Sprite('enemy.png');
  static List<Enemy> list;
  double x, y, targetX, targetY, step,fire, timer, cooldown = 0.4;
  int score;
  Rect rect,lifeRect;
  int life = 6;
  Player jogante;
  TheGame theGame;
  Enemy(Player player,double cooldown,double step)  {

    if(list==null)
      list=new List<Enemy>();
    list.add(this);
    fire=0.7*MediaQuery.of(contexto).size.height/100;
    this.jogante = player;
    rect = Rect.fromLTWH(0.5*MediaQuery.of(contexto).size.width, -0.5*MediaQuery.of(contexto).size.height,0.1*MediaQuery.of(contexto).size.width , 0.1*MediaQuery.of(contexto).size.width);
    lifeRect =  Rect.fromLTWH(rect.topLeft.dx,rect.topLeft.dy-0.02*MediaQuery.of(contexto).size.width ,0.1*MediaQuery.of(contexto).size.width/6 *(life) , 0.01*MediaQuery.of(contexto).size.width);
    x = 0;
    score = 0;
    y = 0;
    timer = 0;
    targetX = 0;
    targetY = rect.height;
    this.cooldown = cooldown;
    this.step = step;
  }

  @override
  void render(Canvas c) {
    rect.translate(90, 0);
    c.drawRect(lifeRect, _paint[life]);
    // in your render method
    nave.renderRect(c, rect,overridePaint: _paint[life]);
  }
  double getAngle(){
    return  math.atan((targetY - y)/(targetX-x));
  }
  @override
  void update(double t) {
    x=rect.center.dx;
    y=rect.center.dy;
    if((targetX-x).abs()>4 || (targetY-y).abs()>4) {
      Offset offset = Offset(
          (targetX - x) / (targetX - x).abs() * math.cos(getAngle()).abs() *
              (step * t),
          (targetY - y) / (targetY - y).abs() * math.sin(getAngle()).abs() *
              (step * t));

      if(offset.dy.isNaN )
        offset= Offset(offset.dx,0);
      if(offset.dx.isNaN)
        offset= Offset(0,offset.dy);
        rect = rect.shift(offset);
        lifeRect = lifeRect.shift(offset);

    }else{
      targetX= jogante.player.center.dx;

      targetY= 100;
      if(timer > cooldown ){
        timer = 0;
        new Meteor.enemy(this.jogante, rect.center.dx, rect.bottom, fire);
      }
    }

    timer += t;

    if(life==0){
      jogante.score+=20;
      enemyDestroy();
    }
  }
  enemyDestroy(){
    list.remove(this);
    this.destroy();
  }
  static destroyAll(){
    if(list!=null)
      for(int i=0; i<list.length;i++)
        list[i].enemyDestroy();
  }

}

class Player extends PositionComponent with Tapable  {

  List<Paint> _paint = [
    Paint()
      ..color = const Color(0xFFFF0B10),
    Paint()
      ..color = const Color(0xFFFF0B10),
    Paint()
      ..color = const Color(0xFFFF5A00),
    Paint()
      ..color = const Color(0xFFFFCE00),
    Paint()
      ..color = const Color(0xFFD6FF00),
    Paint()
      ..color = const Color(0xFFA6FF00),
    Paint()
      ..color = const Color(0xFF06FF00),
   ];
  Sprite nave = Sprite('nave.png');

  double x, y, targetX, targetY, step, timer, cooldown = 0.4;
  int score;
  int scene;
  Rect player,lifeRect;
  int life = 6;
  TheGame theGame;
  Player() {
    scene = 0;
    player = Rect.fromLTWH(0.5*MediaQuery.of(contexto).size.width, 0.5*MediaQuery.of(contexto).size.height,0.1*MediaQuery.of(contexto).size.width , 0.1*MediaQuery.of(contexto).size.width);
    lifeRect =  Rect.fromLTWH(player.bottomLeft.dx,player.bottomLeft.dy+0.01*MediaQuery.of(contexto).size.width ,0.1*MediaQuery.of(contexto).size.width/6 *(life) , 0.01*MediaQuery.of(contexto).size.width);
    x = 0;
    score = 0;
    y = 0;
    timer = 0;
    targetX = 0.5*MediaQuery.of(contexto).size.width;
    targetY = 0.5*MediaQuery.of(contexto).size.height;
    step = 400.4;

  }

  @override
  void render(Canvas c) {
    c.drawRect(lifeRect, _paint[life]);

    // in your render method
    nave.renderRect(c, player);
  }
  double getAngle(){
    return  math.atan((targetY - y)/(targetX-x));
  }
  @override
  void update(double t) {

    x=player.center.dx;
    y=player.center.dy;
    if((targetX-x).abs()>4 || (targetY-y).abs()>4) {
      Offset offset = Offset(
          (targetX - x) / (targetX - x).abs() * math.cos(getAngle()).abs() *
              (step * t),
          (targetY - y) / (targetY - y).abs() * math.sin(getAngle()).abs() *
              (step * t));
      player = player.shift(offset);
      lifeRect = lifeRect.shift(offset);
    }if(timer > cooldown ){
        timer = 0;
        new Bullet(this);
      }

    timer += t;


  }

}

class Meteor extends PositionComponent {
  int random = math.Random().nextInt(20);
  Color color;
  Paint _paint ;
  Rect rect;
  static List<Meteor> list;
  double step = 1;
  Player player;
  Meteor(Player player,double x,double y,double step) {
    color = new Color.fromRGBO(200,random.isNaN?0:random +126, 50, 1);
    _paint = Paint()
      ..color = color;
    if(list==null)
      list= new List<Meteor>();
    list.add(this);
    this.step = step;
    rect = new Rect.fromLTWH(x, y, MediaQuery.of(contexto).size.width*0.003*(math.Random().nextDouble()*30+10), MediaQuery.of(contexto).size.width*0.003*(math.Random().nextDouble()*30+10));
    this.player = player;
  }
  Meteor.enemy(Player player,double x,double y,double step) {
    _paint = Paint()
      ..color = const Color.fromRGBO(0, 255, 255, 150);
    if(list==null)
      list= new List<Meteor>();
    list.add(this);
    this.step = step;
    rect = new Rect.fromLTWH(x, y, MediaQuery.of(contexto).size.width*0.003*(10), MediaQuery.of(contexto).size.width*0.003*(10));
    this.player = player;
  }
  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {
    Offset offset =Offset(0, step);
    if(!offset.dx.isNaN && !offset.dy.isNaN)
    rect = rect.shift(offset);

    if ((rect.center.dx - player.x).abs() < player.player.width && (rect.center.dy - player.y).abs() < player.player.height) {
      meteorDestroy();
      if(player.life>0) {
        player.life--;
        Flame.audio.play("damage.wav");
        player.lifeRect =  Rect.fromLTWH(player.player.bottomLeft.dx,player.player.bottomLeft.dy+0.01*MediaQuery.of(contexto).size.width ,0.1*MediaQuery.of(contexto).size.width/6 *(player.life) , 0.01*MediaQuery.of(contexto).size.width);
      }else{
        Flame.bgm.stop();
        player.scene = 2;
        TheGame.clearScreen();
        TheGame.highscore = player.score>TheGame.highscore?player.score:TheGame.highscore;
        TheGame.spawner.rain = false;
        TheGame.save();
        new Texto(20, "Score : "+player.score.toString(), Position(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*0.3));
        new Texto(23, "Your HighScore: "+TheGame.highscore.toString(), Position(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*0.4));
        new Button(0.5, "Restart", (){player.scene = 1;
        TheGame.clearScreen();
        TheGame.loadGame();});
        new Button(0.65, "Menu", (){player.scene = 0;
        TheGame.clearScreen();
        TheGame.loadMenu();});
      }
    }
    if(rect.center.dy>MediaQuery.of(contexto).size.height)
      meteorDestroy();
  }
  static destroyAll(){
    if(list!=null)
      for(int i=0; i<list.length;i++)
        list[i].meteorDestroy();
  }
  void meteorDestroy(){
    list.remove(this);
    this.destroy();
  }
}

class Bullet extends PositionComponent {
  Paint _paint = Paint()
    ..color = const Color(0xFFFFF0000);
  Rect rect;
  static double size =0.02*MediaQuery.of(contexto).size.width;
  static List<Bullet> list;
  double step = 10;
  Player player;
  Bullet(Player player) {
    if(list == null)
      list = new List<Bullet>();
    list.add(this);
    this.player = player;
    rect = new Rect.fromLTWH(player.player.center.dx-size/2, player.player.center.dy-size, size, size);

  }
  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {
    rect = rect.shift(Offset(0, -1*step));
    if(Meteor.list!=null)
    for (int i = 0; i < Meteor.list.length;i++)
      if ((Meteor.list[i].rect.center.dx - rect.center.dx).abs() < Meteor.list[i].rect.size.width && (Meteor.list[i].rect.center.dy - rect.center.dy).abs() < Meteor.list[i].rect.size.height){
        Flame.audio.play("meteor.wav",volume: TheGame.sfx.toDouble()/100);
        Meteor.list[i].meteorDestroy();
        player.score++;
        bulletDestroy();
        break;
      }
    if(rect.center.dy<0)
      bulletDestroy();
    if(Enemy.list!=null)
    for (int i = 0; i < Enemy.list.length;i++)
      if ((Enemy.list[i].rect.center.dx - rect.center.dx).abs() < Enemy.list[i].rect.size.width && (Enemy.list[i].rect.center.dy - rect.center.dy).abs() < Enemy.list[i].rect.size.height){
        if(Enemy.list[i].life>0)
        Enemy.list[i].life--;
        Flame.audio.play("shot.wav");
        Enemy.list[i].lifeRect =  Rect.fromLTWH( Enemy.list[i].rect.bottomLeft.dx,Enemy.list[i].rect.bottomLeft.dy+0.01*MediaQuery.of(contexto).size.width ,0.1*MediaQuery.of(contexto).size.width/6 *(Enemy.list[i].life) , 0.01*MediaQuery.of(contexto).size.width);
        bulletDestroy();
      }
  }
  static destroyAll(){
    if(list!=null)
      for(int i=0; i<list.length;i++)
        list[i].bulletDestroy();
  }
  void bulletDestroy(){
    list.remove(this);
    this.destroy();
  }
}

class Spawner{

  double step = 10, timer,startimer, y = 10;
  bool rain =true;
  Player player;
  Spawner(Player player) {
    int r = math.Random().nextInt(40);
    for(int i=0;i<r;i++)
      new Star( math.Random().nextDouble()*MediaQuery.of(contexto).size.width,math.Random().nextDouble()*MediaQuery.of(contexto).size.height, math.Random().nextDouble()*2+0.7);
    this.player = player;
    timer = 0;
    startimer = 0;
  }

  void update(double t) {
    timer+=t;
    startimer+=t;
    if(startimer>0.25) {
      startimer=0;
      int r = math.Random().nextInt(10);
      for(int i=0;i<r;i++)
        new Star( math.Random().nextDouble()*MediaQuery.of(contexto).size.width, y, math.Random().nextDouble()*2+0.7);
    }
    if(player.score%100==0 && player.score>90) {
      new Enemy(player, 1- (0.1*player.score/100>1?1:0.1*player.score/100),5 +100*player.score/100*0.3);
      player.score+=5;
    }
    if(timer>0.8 && rain){
      timer=0;
      int r = math.Random().nextInt(5);
      double posx = math.Random().nextDouble()*MediaQuery.of(contexto).size.width;
      double vel = math.Random().nextDouble()*2+0.7;
      for(int i=0;i<r;i++)
        new Meteor(player, posx+i/math.sqrt(r), y+i/math.sqrt(r),vel);
    }
  }


}

class Button extends PositionComponent {
  static List<Button> list;
  Function onClick;
  Paint _paint = Paint()
    ..color =  new Color.fromRGBO(255,255,255,100);
  double y,fontSize;
  Rect rect;
  String text;
  TextConfig textConfig;
  Button(double y, String t, Function fun){
    if(list==null)
      list= new List<Button>();
    fontSize = 23;
    onClick = fun;
    textConfig = TextConfig(fontSize: fontSize,color: Color.fromRGBO(0,0,0, 100));
    text = t;
    rect =  new Rect.fromCenter(center: Offset(MediaQuery.of(contexto).size.width*0.5,MediaQuery.of(contexto).size.height*y),width:MediaQuery.of(contexto).size.width*0.85 ,height:MediaQuery.of(contexto).size.height*0.1 );
    list.add(this);
  }

  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
    textConfig.render(c, text, Position(rect.center.dx,rect.center.dy),anchor: Anchor.center);
  }

  static clickListener(Offset click){

    if(list!=null)
      for(int i=0 ;i<list.length;i++){
        if(list[i].rect.contains(click)) {
          list[i].onClick.call();
          break;
        }
      }
  }


  buttonDestroy(){
    list.remove(this);
    this.destroy();

  }
  static destroyAll(){
    if(list!=null)
      for(int i=0; i<list.length;i++)
        list[i].buttonDestroy();
  }
  @override
  void update(double t) {
  }

}

class TheGame extends Game with TapDetector {
  final _whitePaint = Paint()
    ..color = const Color(0xFFFFFFFF);
  final _bluePaint = Paint()
    ..color = const Color(0xFF0000FF);
  final _greenPaint = Paint()
    ..color = const Color(0xFF00FF00);

  TextConfig config = TextConfig(fontSize: 23.0,color: Color(0xFFFFFFFF));
  @override
  void onTapDown(TapDownDetails details) {
    player.targetX = details.globalPosition.dx;
    player.targetY = details.globalPosition.dy;
    Slider.clickListener(details.globalPosition);
  }

  @override
  void onTapUp(TapUpDetails details) {
    Button.clickListener(details.globalPosition);
  }
  static int sfx,music;
  static Player player;
  Paint _paint;
  static final hiveBox = Hive.box("gameConfig");
  static Spawner spawner ;
  static save(){
    List<int> lista = [sfx,music,highscore];
    while(hiveBox.length>0)
      hiveBox.deleteAt(hiveBox.length - 1);
    hiveBox.add(lista);
  }
  TheGame() {
    Flame.bgm.load("bgm.wav");
    Flame.audio.load("damage.wav");
    Flame.audio.load("shot.wav");
    Flame.audio.load("meteor.wav");
    if(hiveBox.length!=0){
      List<int> lista = hiveBox.getAt(0);
      sfx =  lista[0];
      music = lista[1];
      highscore = lista[2];
    }else{
      sfx = 100;
      music = 100;
      highscore = 0;
    }
    clearScreen();
    player = Player();
    spawner= Spawner(player);
    player.scene = 0;
    loadMenu();
  }
  gameUpdate(double t){

    player.update(t);
    if(Bullet.list!=null)
      for(int i = 0; i < Bullet.list.length;i++)
        Bullet.list[i].update(t);
    if(Meteor.list!=null)
      for(int i = 0; i < Meteor.list.length;i++)
        Meteor.list[i].update(t);
    if(Enemy.list!=null)
      for(int i = 0; i < Enemy.list.length;i++)
        Enemy.list[i].update(t);

  }
  static clearScreen(){
    Button.destroyAll();
    Enemy.destroyAll();
    Meteor.destroyAll();
    Bullet.destroyAll();
    Texto.destroyAll();
    Slider.destroyAll();
  }

  static loadGame()
  {
    Flame.bgm.play("bgm.wav",volume : TheGame.music.toDouble()/100.0);
    clearScreen();
    player.score = 0;
    player.life = 6;
    spawner.rain = true;
    player.targetY = MediaQuery.of(contexto).size.height/2;
    player.targetX = MediaQuery.of(contexto).size.width/2;
    player.x = player.targetX;
    player.y = player.targetY;
  }

  @override
  void update(double t) {
    spawner.update(t);
    if(Star.list!=null)
      for(int i = 0; i < Star.list.length;i++)
        Star.list[i].update(t);
    switch (player.scene){
      case(0):
        break;
      case(1):
        gameUpdate(t);
        break;
      case(2):
        break;
      case(3):
        break;
      default:
        break;
    }

  }
  static int highscore;
  static loadMenu(){

    print("HELLO");
    clearScreen();
    new Texto(23, "Your HighScore: "+highscore.toString(), Position(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*0.4));
    spawner.rain = false;
    new Button(0.5, "Start",(){
      clearScreen();
      player.scene = 1;
      loadGame();
    });
    new Button(0.65, "Config",(){
      TheGame.loadConfig();


    });
    new Button(0.80, "Quit",(){
      TheGame.clearScreen();
      Navigator.pop(contexto);

    });
    print("BYE");
  }

  menuRender(Canvas c){
    Texto.renderAll(c);
    if(Button.list!=null)
      for(int i = 0; i < Button.list.length;i++)
        Button.list[i].render(c);
      Slider.renderAll(c);
  }
  gameRender(Canvas c){
    player.render(c);
    if(Bullet.list!=null)
      for(int i = 0; i < Bullet.list.length;i++)
        Bullet.list[i].render(c);
    if(Meteor.list!=null)
      for(int i = 0; i < Meteor.list.length;i++)
        Meteor.list[i].render(c);
    if(Enemy.list!=null)
      for(int i = 0; i < Enemy.list.length;i++)
        Enemy.list[i].render(c);
    config.render(c,"Score: "+player.score.toString(),Position(20, 20));
  }

  @override
  void render(Canvas c) {
    if(Star.list!=null)
      for(int i = 0; i < Star.list.length;i++)
        Star.list[i].render(c);
      switch (player.scene){
        case(1):
          gameRender(c);
          break;
        default:
          menuRender(c);
          break;
      }



  }
  static void loadConfig() {

    TheGame.clearScreen();
    player.scene = 3;
    TheGame.clearScreen();

    new Texto(23, "Sfx volume", Position(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*0.1));
    new Slider(0.2, (int i) {TheGame.sfx = i;},true);
    new Texto(23, "Music volume", Position(MediaQuery.of(contexto).size.width/2,MediaQuery.of(contexto).size.height*0.3));
    new Slider(0.4, (int i) {TheGame.music = i;},false);
    new Button(0.65, "Menu", () {

      TheGame.clearScreen();
      player.scene = 0;
      loadMenu();
    });
  }

}

class MyGame extends StatefulWidget {
  @override
  _MyGameState createState() => _MyGameState();

}

class _MyGameState extends State{
  @override
  Widget build(BuildContext context) {
    contexto = context;
    return new WillPopScope(child : new TheGame().widget,onWillPop: (){
      Flame.bgm.stop();
      Navigator.pop(contexto);
    },);
  }

  @override
  void dispose() {
    super.dispose();
    Flame.bgm.dispose();
  }

}