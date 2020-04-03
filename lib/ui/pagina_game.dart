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

class Player extends PositionComponent with Tapable {

  Paint _paint = Paint()
  ..color = const Color(0xFFFFFFFF);
  double x,y,Tx,Ty,step;
  Rect player;
  Player(){
    player=Rect.fromLTWH(50, 50, 50, 50);
    x=0;
    y=0;
    Tx=0;
    Ty=0;
    step=400.4;

  }


  @override
  void render(Canvas c) {
    c.drawRect(player, _paint);
  }
  double getAngle(){
    return  math.atan((Ty - y)/(Tx-x));
  }
  @override
  void update(double t) {
    x=player.center.dx;
    y=player.center.dy;
    if((Tx-x).abs()>4 || (Ty-y).abs()>4)
    player = player.shift(Offset((Tx-x)/(Tx-x).abs()*math.cos(getAngle()).abs()*(step*t),(Ty-y)/(Ty-y).abs()*math.sin(getAngle()).abs()*(step*t)));
  }

}


class MyGame extends Game with TapDetector {
  final _whitePaint = Paint()
    ..color = const Color(0xFFFFFFFF);
  final _bluePaint = Paint()
    ..color = const Color(0xFF0000FF);
  final _greenPaint = Paint()
    ..color = const Color(0xFF00FF00);
  @override
  void onTapDown(TapDownDetails details) {
    player.Tx = details.globalPosition.dx;
    player.Ty = details.globalPosition.dy;
  }
  Player player =Player();
  Paint _paint;

  MyGame() {
  }




  @override
  void update(double t) {

  player.update(t);
  }

  @override
  void render(Canvas c) {
  player.render(c);
  }

}
