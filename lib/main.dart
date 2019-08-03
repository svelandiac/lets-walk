import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:lets_walk/src/models/user.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/main_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(LetsWalkApp());

class LetsWalkApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context)=>FirebaseAuthService(),)
      ],
      child: MaterialApp(
        title: "Let's Walk!",
        home: _handleWindowDisplay(),
        routes: {
          "/LoginScreen": (context) => LoginScreen(),
          "/MainScreen": (context) => MainScreen(),
        },
      ),
    );
  }

}

Widget _handleWindowDisplay() {
  return StreamBuilder(
    stream: FirebaseAuth.instance.onAuthStateChanged,
    builder: (BuildContext context, snapshot){
      if(snapshot.connectionState == ConnectionState.waiting)
        return _buildWaiting();
      else{
        if(snapshot.hasData)
          return MainScreen();
        else
          return LoginScreen();
      }
    },
  );
}

Widget _buildWaiting(){
  return Scaffold(
    body: Center(
      child: CircularProgressIndicator(),
    ),
  );
}