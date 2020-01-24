import 'package:flutter/material.dart';
import 'package:lets_walk/settings/project_config.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/type_of_user.dart';
import 'package:lets_walk/src/models/zonas.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:lets_walk/src/ui/screens/select_user_screen.dart';
import 'package:lets_walk/src/ui/screens/user-01/add_property_user_01_screen.dart';
import 'package:lets_walk/src/ui/screens/user-02/user_02_main_screen.dart';
import 'package:lets_walk/src/ui/screens/user-03/user_03_main_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(LetsWalkApp());

class LetsWalkApp extends StatefulWidget{

  @override
  _LetsWalkAppState createState() => _LetsWalkAppState();
}

class _LetsWalkAppState extends State<LetsWalkApp> {

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(builder: (context)=>FirebaseAuthService(),),
        ChangeNotifierProvider(builder: (context)=>Locations(),),
        ChangeNotifierProvider(builder: (context)=>ModifyPropertiesService(),),
        ChangeNotifierProvider(builder: (context)=>TypeOfUser(),),
        ChangeNotifierProvider(builder: (context)=>Zonas(),),
      ],
      child: MaterialApp(
        title: "Platz Admin",
        home: HandleDisplayWindow(),
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

class HandleDisplayWindow extends StatefulWidget {

  @override
  _HandleDisplayWindowState createState() => _HandleDisplayWindowState();
}

class _HandleDisplayWindowState extends State<HandleDisplayWindow> {

  TypeOfUser typeOfUser;

  Future<int> checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int value = (prefs.getInt('user'));
    return value;
  }

  Widget _buildBody(BuildContext context) {
    if(typeOfUser.value == null){
      return SelectUserScreen();
    }

    if(typeOfUser.value == 1)
      return AddPropertyUser01Screen();

    if(typeOfUser.value == 2)
      return User02MainScreen();

    if(typeOfUser.value == 3)
      return User03MainScreen();

    return SelectUserScreen();
  }

  @override
  Widget build(BuildContext context) {

    typeOfUser = Provider.of<TypeOfUser>(context);

    checkUser().then((user) {
      typeOfUser.value = user;
    });

    return Scaffold(
      body: _buildBody(context),
    );
  }
}