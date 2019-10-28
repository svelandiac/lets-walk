import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/settings/project_config.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/main_screen.dart';
import 'package:provider/provider.dart';

void main() => runApp(LetsWalkApp());

class LetsWalkApp extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context)=>FirebaseAuthService(),),
        ChangeNotifierProvider(builder: (context)=>Locations(),),
        ChangeNotifierProvider(builder: (context)=>ModifyPropertiesService(),),

      ],
      child: MaterialApp(
        title: "Platz Admin",
        home: _handleWindowDisplay(),
        routes: routes,
        theme: ThemeData(
          // Default brightness and colors.
          primaryColor: Colors.black,
          accentColor: Colors.cyan[600],
          
          // Default font family.
          fontFamily: 'Montserrat',
          
          // Default TextTheme.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 25.0, fontStyle: FontStyle.normal),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
      )
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