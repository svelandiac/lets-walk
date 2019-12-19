import 'package:flutter/cupertino.dart';

class TypeOfUser with ChangeNotifier{

  int _value;
  
  TypeOfUser() {
    this._value = 0;
  }

  int get value => this._value;

  set value(int newValue) {
    this._value = newValue;
    notifyListeners();
  }
}