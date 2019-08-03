import 'package:flutter/material.dart';
import 'package:lets_walk/src/services/firebase_auth_service.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Widget _loadingPrompt(bool value){
    if(value)
      return Center(
        child: CircularProgressIndicator(),
      );
    else
      return Container();
  }

  @override
  Widget build(BuildContext context) {

    final firebaseInfo = Provider.of<FirebaseAuthService>(context);

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _loadingPrompt(firebaseInfo.loading),
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(
                      firebaseInfo.stateMessage,
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
                        firebaseInfo.loading = true;
                        firebaseInfo.signInWithEmailAndPassword(_emailController.text, _passwordController.text)
                          .then((onValue){
                            debugPrint('onValue: ${onValue.email}');
                            firebaseInfo.stateMessage = 'Inicia sesión en tu cuenta';
                            firebaseInfo.loading = false;
                          })
                          .catchError((onError){
                            debugPrint('Error: $onError');
                            firebaseInfo.stateMessage = 'Usuario o contraseña incorrectos\nIntenta de nuevo';
                            firebaseInfo.loading = false;
                          });
                      },
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
