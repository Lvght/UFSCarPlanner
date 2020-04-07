import 'dart:ffi';
import 'dart:math' as math;
import 'dart:ui';

import 'dart:core';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/gestures.dart';
import 'package:flame/anchor.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

BuildContext contexto;

class Player extends PositionComponent with Tapable  {

  Paint _paint = Paint()
    ..color = const Color(0xFFFFFFFF);
  double x, y, targetX, targetY, step, timer, cooldown = 1;
  Rect player;
  Player() {
    player = Rect.fromLTWH(50, 50, 50, 50);
    x = 0;
    y = 0;
    timer = 0;
    targetX = 0;
    targetY = 0;
    step = 400.4;
  }


  @override
  void render(Canvas c) {
    _paint.color = Color(0xFFFFFFFF-(timer*1000).floor());
    c.drawRect(player, _paint);
  }
  double getAngle(){
    return  math.atan((targetY - y)/(targetX-x));
  }
  @override
  void update(double t) {
    x=player.center.dx;
    y=player.center.dy;
    if((targetX-x).abs()>4 || (targetY-y).abs()>4)
      player = player.shift(Offset((targetX-x)/(targetX-x).abs()*math.cos(getAngle()).abs()*(step*t),(targetY-y)/(targetY-y).abs()*math.sin(getAngle()).abs()*(step*t)));
    else{
      if(timer > cooldown ){
        timer = 0;
        new Bullet(this);
      }
    }
    timer += t;


  }

}

class Meteor extends PositionComponent {
  Paint _paint = Paint()
    ..color = const Color(0xFFFFFFFF);
  Rect rect;
  static List<Meteor> list;
  double step = 1;
  Player player;
  Meteor(Player player,double x,double y) {
    if(list==null)
      list= new List<Meteor>();
    list.add(this);
    step = math.Random().nextDouble()*2+0.7;
    rect = new Rect.fromLTWH(x, y, math.Random().nextDouble()*50+20, math.Random().nextDouble()*50+20);
    this.player = player;
  }
  @override
  void render(Canvas c) {
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {
    rect = rect.shift(Offset(0, step));

    if ((rect.center.dx - player.x).abs() < 5 && (rect.center.dy - player.y).abs() < 5)
      meteorDestroy();
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
    ..color = const Color(0xFFFFFFFF);
  Rect rect;
  static List<Bullet> list;
  double step = 10;
  Player player;
  Bullet(Player player) {
    if(list == null)
      list = new List<Bullet>();
    list.add(this);
    this.player = player;
    rect = new Rect.fromLTWH(player.player.center.dx, player.player.center.dy-10, 10, 10);

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
        bulletDestroy();
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
    if(timer>0.4){
      timer=0;
      new Meteor(player, math.Random().nextDouble()*MediaQuery.of(contexto).size.width, y);
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