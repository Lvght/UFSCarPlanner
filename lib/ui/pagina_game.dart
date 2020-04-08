import 'dart:ffi';
import 'dart:math' as math;
import 'dart:ui';

import 'dart:core';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/gestures.dart';
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
  Rect player,lifeRect;
  int life = 6;
  Player() {


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
  Color color = new Color.fromRGBO(200, math.Random().nextInt(20)+126, 50, 1);
  Paint _paint ;
  Rect rect;
  static List<Meteor> list;
  double step = 1;
  Player player;
  Meteor(Player player,double x,double y,double step) {
    _paint = Paint()
      ..color = color;
    if(list==null)
      list= new List<Meteor>();
    list.add(this);
    this.step = step;
    rect = new Rect.fromLTWH(x, y, math.Random().nextDouble()*30+10, math.Random().nextDouble()*30+10);
    this.player = player;
  }
  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {
    rect = rect.shift(Offset(0, step));

    if ((rect.center.dx - player.x).abs() < player.player.width && (rect.center.dy - player.y).abs() < player.player.height) {
      meteorDestroy();
      if(player.life>0) {
        player.life--;
        player.lifeRect =  Rect.fromLTWH(player.player.bottomLeft.dx,player.player.bottomLeft.dy+0.01*MediaQuery.of(contexto).size.width ,0.1*MediaQuery.of(contexto).size.width/6 *(player.life) , 0.01*MediaQuery.of(contexto).size.width);
      }
    }
    if(rect.center.dy>MediaQuery.of(contexto).size.height)
      meteorDestroy();
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
        Meteor.list[i].meteorDestroy();
        player.score++;
        bulletDestroy();
        print(player.score);
      }
    if(rect.center.dy<0)
      bulletDestroy();
  }

  void bulletDestroy(){
    list.remove(this);
    this.destroy();
  }
}

class Spawner{

  double step = 10, timer, y = 10;
  Player player;
  Spawner(Player player) {
    this.player = player;
    timer = 0;
  }

  void update(double t) {
    timer+=t;
    if(timer>0.8){
      timer=0;
      int r = math.Random().nextInt(20);
      double posx = math.Random().nextDouble()*MediaQuery.of(contexto).size.width;
      double vel = math.Random().nextDouble()*2+0.7;
      for(int i=0;i<r;i++)
        new Meteor(player, posx+i/math.sqrt(r), y+i/math.sqrt(r),vel);
    }
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
  }
  Player player = Player();
  Paint _paint;

  Spawner spawner ;
  TheGame() {
    spawner= Spawner(player);
  }

  @override
  void update(double t) {
    spawner.update(t);
    player.update(t);
    if(Bullet.list!=null)
    for(int i = 0; i < Bullet.list.length;i++)
      Bullet.list[i].update(t);
    if(Meteor.list!=null)
    for(int i = 0; i < Meteor.list.length;i++)
      Meteor.list[i].update(t);
  }

  @override
  void render(Canvas c) {
    player.render(c);
    if(Bullet.list!=null)
    for(int i = 0; i < Bullet.list.length;i++)
      Bullet.list[i].render(c);
    if(Meteor.list!=null)
    for(int i = 0; i < Meteor.list.length;i++)
      Meteor.list[i].render(c);

    config.render(c,"Score: "+player.score.toString(),Position(20, 20));
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
    return TheGame().widget;
  }

}