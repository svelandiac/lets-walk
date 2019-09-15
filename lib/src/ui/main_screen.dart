import 'package:flutter/material.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget{

  Widget _buildLogOutButton(){
    return Consumer<FirebaseAuthService>(
      builder: (context, firebaseInfo, child) => FlatButton(
        color: Colors.transparent,
        textColor: Colors.white,
        child: Icon(Icons.power_settings_new),
        onPressed: (){
          firebaseInfo.signOut();
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
                Navigator.pushNamed(context, '/NewPropertyScreen');
              },
            ),
            RoundedOutlinedButton(
              text: 'Ver todos los inmuebles',
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
