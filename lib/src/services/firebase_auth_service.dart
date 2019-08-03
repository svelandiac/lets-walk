import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/user.dart';

class FirebaseAuthService with ChangeNotifier{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _stateMessage = 'Inicia sesión en tu cuenta';
  bool _loading = false;

  String get stateMessage => _stateMessage;

  bool get loading => _loading;

  set stateMessage(String value){
    this._stateMessage = value;
    notifyListeners();
  }

  set loading(bool value){
    this._loading = value;
    notifyListeners();
  }

  User _userFromFirebase(FirebaseUser user) {
    if (user == null) {
      return null;
    }
    return User(
      uid: user.uid,
      email: user.email,
    );
  }

  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final AuthResult authResult = await _firebaseAuth.signInWithCredential(EmailAuthProvider.getCredential(
      email: email,
      password: password,
    ));
    return _userFromFirebase(authResult.user);
  }

  Future<String> signOut() async {
    _firebaseAuth.signOut().then((onValue){
      return 'Successfully logged out';
    }).catchError((onError){
      return 'Oops, something went wrong';
    });
    return 'Operation was not successfully';
  }

}