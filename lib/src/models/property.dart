import 'package:cloud_firestore/cloud_firestore.dart';

class Property{

  String _documentID;

  String _address;
  String _contactNumber;
  List<dynamic> _photos;
  String _description;
  String _neighborhood;

  GeoPoint _location;
  String _geohash;

  String _isContacted;
  String _observations;
  String _date;

  bool _show;


  Property ({String address, List photos, String description, String contactNumber, String documentID, GeoPoint location, String geohash, bool show = true, String neighborhood}) {
    if(photos==null)
      this._photos = List();
    else
      this._photos = photos;
    
    this._address = address;
    this._description = description;
    this._contactNumber = contactNumber;
    this._documentID = documentID;
    this._location = location;
    this._isContacted = 'noContacted';
    this._observations = '';
    this._date = '';
    
    if(geohash == null)
      this._geohash = "";
    else 
      this._geohash = geohash;

    this._show = show;
    this._neighborhood = neighborhood;
  }

  String get documentID => this._documentID;
  String get address => this._address;
  List<dynamic> get photos => this._photos;
  String get description => this._description;
  String get contactNumber => this._contactNumber;
  GeoPoint get location => this._location;
  String get isContacted => this._isContacted;
  String get observations => this._observations;
  String get date => this._date;
  String get geohash => this._geohash;
  bool get show => this._show;
  String get neighborhood => this._neighborhood;

  set documentID(String value){
    this._documentID = value;
  }

  set address(String value){
    this._address = value;
  }

  set photos(List<dynamic> value){
    this._photos = value;
  }

  set description(String value){
    this._description = value;
  }

  set contactNumber(String value){
    this._contactNumber = value;
  }

  set location(GeoPoint value){
    this._location = value;
  }

  set isContacted(String value){
    this._isContacted = value;
  } 

  set observations(String value){
    this._observations = value;
  }
  
  set date(String value){
    this._date = value;
  }

  set geohash(String value){
    this._geohash = value;
  }

  set show(bool value){
    this._show = value;
  }

  set neighborhood(String value){
    this._neighborhood = value;
  }

  get details {
    return {'address': this._address, 'description': this._description, 'contactNumber': this._contactNumber};
  }

  get contacting {
    return {'observations': this._observations, 'date': this._date};
  }

}