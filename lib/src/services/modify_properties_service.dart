import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/property.dart';

class ModifyPropertiesService with ChangeNotifier {

  Property _propertyToModify;
  Firestore _firestore = Firestore.instance;

  set property(Property property){
    this._propertyToModify = property;
    notifyListeners();
  }

  Property get property => this._propertyToModify;

  Future<void> editProperty(){
    
    var propertyReference = _firestore.collection('locations').document(_propertyToModify.documentID);

    return propertyReference.setData({
      'details': _propertyToModify.details,
      'modifications' : _propertyToModify.modifications,
      'propertyStatus' : _propertyToModify.propertyStatus,
      'ownerInfo' : _propertyToModify.ownerInfo,
      'currentState': _propertyToModify.currentState,
      'visited': _propertyToModify.visited
    }, merge: true);
  } 
}