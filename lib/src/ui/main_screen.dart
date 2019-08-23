import 'package:flutter/material.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget{

  Widget _buildLogOutButton(){
    return Consumer<FirebaseAuthService>(
      builder: (context, firebaseInfo, child) => FlatButton(
        color: Colors.transparent,
        textColor: Colors.white,
        child: Icon(Icons.power_settings_new),
        onPressed: (){
          firebaseInfo.signOut().then((onValue){
            print(onValue);
          }).catchError((onError){
            print(onError);
          });
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
              width: 252,
            ),
            Container(
              width: 250,
              child: OutlineButton(
                child: Text('Agregar un nuevo inmueble'),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                highlightedBorderColor: Colors.black,
                onPressed: (){
                  Navigator.pushNamed(context, '/NewPropertyScreen');
                },
              ),
            ),
            Container(
              width: 250,
              child: OutlineButton(
                child: Text('Ver todos los inmuebles'),
                shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                highlightedBorderColor: Colors.black,
                onPressed: (){
                  Navigator.pushNamed(context, '/SeePropertiesScreen');                  
                },
              ),
            ),
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
