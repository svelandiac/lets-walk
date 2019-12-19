import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/type_of_user.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User02MainScreen extends StatefulWidget{

  @override
  _User02MainScreenState createState() => _User02MainScreenState();
}

class _User02MainScreenState extends State<User02MainScreen> {

  TypeOfUser typeOfUser;

  Future<void> changeUser(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user', value);
    typeOfUser.value = value;
    return;
  }

  Widget _buildLogOutButton(){
    return Consumer<FirebaseAuthService>(
      builder: (context, firebaseInfo, child) => FlatButton(
        color: Colors.transparent,
        textColor: Colors.white,
        child: Icon(Icons.power_settings_new),
        onPressed: (){
          changeUser(null);
        },
      )
    );
  }

  Widget _buildBody(BuildContext context){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Text(
              'Bienvenido, ¿qué deseas hacer?', 
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
            SizedBox(
              height: 50,
              width: 251,
            ),
            RoundedOutlinedButton(
              text: 'Agregar un nuevo inmueble',
              onPressed: (){
                Navigator.pushNamed(context, '/AddPropertyUser02Screen');
              },
            ),
            RoundedOutlinedButton(
              text: 'Editar los inmuebles añadidos',
              onPressed: (){
                Navigator.pushNamed(context, '/SeePropertiesScreen');                  
              },
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    typeOfUser = Provider.of<TypeOfUser>(context);

    return new Scaffold(
      appBar: AppBar(
        title: Text('Menú principal'),
        centerTitle: true,
        actions: <Widget>[
          _buildLogOutButton()
        ],
        backgroundColor: Colors.black87,
      ),
      body: _buildBody(context)
    );
  }
}
