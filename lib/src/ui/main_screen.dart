import 'package:flutter/material.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final firebaseInfo = Provider.of<FirebaseAuthService>(context);   

    return Scaffold(
      appBar: AppBar(
        title: Text('Pantalla principal', style: TextStyle(fontSize: 18.0),),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            color: Colors.transparent,
            textColor: Colors.white,
            child: Text('Cerrar\nSesión', style: TextStyle(fontSize: 13.0),),
            onPressed: (){
              firebaseInfo.signOut().then((onValue){
                print(onValue);
              }).catchError((onError){
                print(onError);
              });
            },
          )
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('Main Screen'),
            ],
          ),
        ),
      ),
    );
  }

}

