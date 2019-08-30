import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/models/property.dart';

class Locations with ChangeNotifier {

  List<Property> _properties;
  Set<Marker> _markers; 

  Locations(){
    this._properties = List();
    this._markers = Set();
  }

  List<Property> get properties => this._properties;
  Set<Marker> get markers => this._markers;

  void addNewProperty(Property property){
    this._properties.add(property);
    var newMarker = Marker(
      markerId: MarkerId(property.documentID),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: property.address,
        snippet: 'Contacto: ${property.contactNumber}'
      ),
      position: LatLng(property.location.latitude, property.location.longitude),
    );  
    this._markers.add(newMarker);
    notifyListeners();
  }

  void clearProperties(){
    this._markers.clear();
    this._properties.clear();
    notifyListeners();
  }
}