import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class SavedMarkersService with ChangeNotifier{

  Set<Marker> _markers;
  Firestore _firestore = Firestore.instance;
  Location _location = Location();
  Geoflutterfire _geo = Geoflutterfire();
  StreamSubscription _subscription;
  BehaviorSubject<double> _radius = BehaviorSubject();
  Stream<dynamic> _query;


  SavedMarkersService(){
    _markers = Set();
  }

  void _addNewMarker(Marker marker){
    _markers.add(marker);
  }

  void _clearMarkers() {
    _markers.clear();
  }

  void _updateMarkers() {
    
    var userQuery = _firestore.collection('locations');
    
    userQuery.snapshots().listen((data){
      var documentList = data.documents;
      _clearMarkers();
      documentList.forEach((DocumentSnapshot document) {
        if(document.data['position']!=null){
          GeoPoint pos = document.data['position']['geopoint'];
          var marker = Marker(
            position: LatLng(pos.latitude, pos.longitude),
            icon: BitmapDescriptor.defaultMarker,
            infoWindow: InfoWindow(title: document.documentID),
            markerId: MarkerId(document.documentID)
          );
          _addNewMarker(marker);
        }
      });

      notifyListeners();

    });
  }

   Future<DocumentReference> addGeoPoint(String name) async {
    var pos = await _location.getLocation();
    GeoFirePoint point = _geo.point(latitude: pos.latitude, longitude: pos.longitude);
    return _firestore.collection('locations').add({ 
      'position': point.data,
      'name': name 
    });
  }


   startQuery() async {
     _updateMarkers();
  }
  
  Set<Marker> get markers => _markers;

}