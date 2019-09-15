import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/models/property.dart';

enum SortOption {
  address,
  state,
  description,
  position,
}

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

  // void sortBy(SortOption option){

  //     switch (option) {
  //       case SortOption.address:
  //         _sortByAddress();
  //         break;

  //       case SortOption.state:
  //         _sortByState();
  //         break;

  //       case SortOption.description:
  //         _sortByDescription();
  //         break;

  //       case  SortOption.position:
  //         _sortByPosition();
  //         break;

  //       default:

  //         break;
  //     }
  // }

  // void _sortByAddress(){
  //   print('Sort by address');
  //   this._properties.sort(
  //     (a, b){
  //       return a.address.toLowerCase().trim().compareTo(b.address.toLowerCase().trim());
  //     }
  //   );
  //   notifyListeners();
  // }

  // void _sortByState(){
  //   print('Sort by current state');
  //   this._properties.sort(
  //     (a, b){
  //       return a.isContacted.compareTo(b.isContacted);
  //     }
  //   );
  //   notifyListeners();
  // }

  // void _sortByDescription(){
  //   print('Sort by description');
  //   this._properties.sort(
  //     (a, b){
  //       return a.description.toLowerCase().trim().compareTo(b.description.toLowerCase().trim());
  //     }
  //   );
  //   notifyListeners();
  // }

  // void _sortByPosition(){
  //   print('Sort by position');
  //   this._properties.sort(
  //     (a, b){
  //       return a.geohash.compareTo(b.geohash);
  //     }
  //   );
  //   notifyListeners();
  // }
}