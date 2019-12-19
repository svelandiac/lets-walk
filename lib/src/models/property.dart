import 'package:cloud_firestore/cloud_firestore.dart';

class Property{

  String _documentID;

  String _address;
  String _contactNumber;
  List<dynamic> _photos;
  String _description;

  GeoPoint _location;
  String _geohash;

  String _isContacted;

  bool _show;

  String _kindOfProperty;
  int _numberOfBaths;
  int _numberOfRooms;
  double _size;
  int _yearsOld;
  int _numberOfParking;

  bool _pets;
  bool _remaked;
  int _stratum;

  int acabados;
  int ruido;
  int iluminacion;
  int ventilacion;
  String fallas;

  String nombrePropietario;
  String numeroPropietario;
  String precioArriendoEsperado;
  bool arriendoAmoblado;
  String costoAdministracion;
  bool abiertoContratoMandato;

  String currentState;

  bool visited;

  Property ({String address, List photos, String description, String contactNumber, String documentID, GeoPoint location, String geohash, bool show = true, String neighborhood, String kindOfProperty, int numberOfBaths, int numberOfRooms, double size, int yearsOld, int numberOfParking,}) {
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

    this._kindOfProperty = kindOfProperty;
    this._numberOfBaths = numberOfBaths;
    this._numberOfRooms = numberOfRooms;
    this._size = size;
    this._yearsOld = yearsOld;
    this._numberOfParking = numberOfParking;
    
    if(geohash == null)
      this._geohash = "";
    else 
      this._geohash = geohash;

    this._show = show;
  }

  String get documentID => this._documentID;
  String get address => this._address;
  List<dynamic> get photos => this._photos;
  String get description => this._description;
  String get contactNumber => this._contactNumber;
  GeoPoint get location => this._location;
  String get isContacted => this._isContacted;
  String get geohash => this._geohash;
  bool get show => this._show;

  String get kindOfProperty => this._kindOfProperty;
  int get numberOfBaths => this._numberOfBaths;
  int get numberOfRooms => this._numberOfRooms;
  double get size => this._size;
  int get yearsOld => this._yearsOld;
  int get nummberOfParking => this._numberOfParking;
  bool get pets => this._pets;
  bool get remaked => this._remaked;
  int get stratum => this._stratum;

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

  set geohash(String value){
    this._geohash = value;
  }

  set show(bool value){
    this._show = value;
  }

  set kindOfProperty(String value){
    this._kindOfProperty = value;
  }

  set numberOfBaths(int value){
    this._numberOfBaths = value;
  }

  set numberOfRooms(int value){
    this._numberOfRooms = value;
  }

  set size(double value){
    this._size = value;
  }

  set yearsOld(int value){
    this._yearsOld = value;
  }

  set numberOfParking(int value){
    this._numberOfParking = value;
  }

  set pets(bool value){
    this._pets = value;
  }

  set remaked(bool value){
    this._remaked = value;
  }

  set stratum(int value){
    this._stratum = value;
  }

  get details {
    return {'address': this._address, 'description': this._description, 'contactNumber': this._contactNumber};
  }

  get modifications {
    return {
      'kindOfProperty' : this._kindOfProperty,
      'numberOfBaths' : this._numberOfBaths,
      'numberOfRooms' : this._numberOfRooms,
      'size' : this._size,
      'yearsOld' : this._yearsOld,
      'numberOfParking' : this._numberOfParking,
      'pets' : this._pets,
      'remaked' : this._remaked,
      'stratum' : this._stratum
    };
  }

  get propertyStatus {
    return {
      'acabados': acabados,
      'iluminacion': iluminacion,
      'ruido' : ruido,
      'ventilacion' : ventilacion,
      'fallas' : fallas
    };
  }

  get ownerInfo {
    return {
      'nombre': nombrePropietario,
      'numero': numeroPropietario,
      'precio': precioArriendoEsperado,
      'amoblado': arriendoAmoblado,
      'costoAdministracion': costoAdministracion,
      'abiertoContratoMandato': abiertoContratoMandato
    };
  }

}