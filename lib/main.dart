import 'package:flutter/material.dart';
import 'package:lets_walk/src/ui/login_screen.dart';

void main() => runApp(LetsWalkApp());

class LetsWalkApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Let's Walk!",
      home: LoginScreen(),
    );
  }

}

