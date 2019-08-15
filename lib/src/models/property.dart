import 'dart:io';

class Property{

  String _address;
  String _contactNumber;
  List<File> _photos;
  String _description;

  Property ({String address, List photos, String description, String contactNumber}) {

    if(photos==null)
      this._photos = List();
    else
      this._photos = photos;
    
    this._address = address;
    this._description = description;
    this._contactNumber = contactNumber;
  }

  String get address => this._address;
  List<File> get photos => this._photos;
  String get description => this._description;
  String get contactNumber => this._contactNumber;

  set address(String value){
    this._address = value;
  }

  set photos(List<File> value){
    this._photos = value;
  }

  set description(String value){
    this._description = value;
  }

  set contactNumber(String value){
    this._contactNumber = value;
  }

  get data {
    return {'address': this._address, 'description': this._description, 'contactNumber': this._contactNumber};
  }
}