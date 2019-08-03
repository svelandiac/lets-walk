import 'package:flutter/widgets.dart';

class User with ChangeNotifier {

  String _uid;
  String _email;

  User({String uid, String email}){
    _uid = uid;
    _email = email;
  }

  get uid => _uid;
  
  get email => _email;

  set uid(String value){
    this._uid = value;
    notifyListeners();
  }  

  set email(String value){
    this._email = value;
    notifyListeners();
  }
}