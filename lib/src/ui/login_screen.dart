import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/user.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  FirebaseAuthService firebaseAuthService = FirebaseAuthService();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final userInfo = Provider.of<User>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text(
                  'Inicia sesión en tu cuenta',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'tú@ejemplo.com',
                    labelText: 'Correo electrónico'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Contraseña de la cuenta',
                    labelText: 'Contraseña',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: RaisedButton(
                  child: Text('Inicia sesión', style: TextStyle(color: Colors.white),),
                  color: Colors.blue,
                  onPressed: (){
                    firebaseAuthService.signInWithEmailAndPassword(_emailController.text, _passwordController.text)
                      .then((onValue){
                        debugPrint('onValue: ${onValue.email}');
                        userInfo.email = onValue.email;
                        userInfo.uid = onValue.uid;
                        Navigator.pushNamed(context, '/MainScreen');
                      })
                      .catchError((onError){
                        debugPrint('Error: $onError');
                      });
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}