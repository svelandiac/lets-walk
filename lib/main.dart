import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/user.dart';
import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/main_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(LetsWalkApp());

class LetsWalkApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context)=>User(email: null, uid: null),)
      ],
      child: MaterialApp(
        title: "Let's Walk!",
        home: LoginScreen(),
        routes: {
          "/LoginScreen": (context) => LoginScreen(),
          "/MainScreen": (context) => MainScreen(),
        },
      ),
    );
  }

}

