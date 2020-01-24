import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/ui/callbacks/callback_container.dart';

enum SortOption {
  address,
  state,
  description,
  position,
}

class Locations with ChangeNotifier {

  List<Property> _properties;
  Set<Marker> _markers; 
  CallbackContainer callbackContainer;

  Function changeToList;

  Locations(){
    this._properties = List();
    this._markers = Set();
    this.callbackContainer = CallbackContainer();
  }

  List<Property> get properties => this._properties;
  Set<Marker> get markers => this._markers;

  void addNewProperty(Property property){
    this._properties.add(property);
    var newMarker = Marker(
      markerId: MarkerId(property.documentID),
      icon: BitmapDescriptor.defaultMarker,
      infoWindow: InfoWindow(
        title: property.direccion,
        snippet: 'Contacto: ${property.numero}',
        onTap: () {
          changeToList();
          callbackContainer.callbackObject.callBackFunction(property.direccion);
        }
      ),
      position: LatLng(property.puntoGeografico.elementAt(0), property.puntoGeografico.elementAt(1)),
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