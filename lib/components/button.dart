import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function onPressed;
  final Widget child;

  Button({this.onPressed, this.child});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      child: child,
      textColor: Colors.white,
      color: Colors.red,
    );
  }
}
