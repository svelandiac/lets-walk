import 'package:flutter/material.dart';

class RoundedOutlinedButton extends StatelessWidget {

  final double width;
  final String text;
  final Function() onPressed;

  RoundedOutlinedButton({
    this.width = 250,
    this.text,
    this.onPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      child: OutlineButton(
        child: Text(text),
        shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
        borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
        highlightedBorderColor: Colors.black,
        onPressed: onPressed,
      ),
    );
  }
}