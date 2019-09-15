import 'package:flutter/material.dart';

class ColorRoundedButton extends StatelessWidget {

  final Color color;
  final String text;
  final Function() onPressed;
  final double width;

  ColorRoundedButton({
    this.color = Colors.white,
    this.text,
    this.onPressed,
    this.width = 180
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: FlatButton(
        color: color,
        child: Text(text),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        onPressed: onPressed,
      ),
    );
  }
}