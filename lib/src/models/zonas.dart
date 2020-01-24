import 'package:flutter/material.dart';

class Zonas with ChangeNotifier {

  List<String> _zonas;

  Zonas();

  List<String> get zonas => this._zonas;

  set zonas(List<String> zonas) {
    this._zonas = zonas;
    notifyListeners();
  }


}