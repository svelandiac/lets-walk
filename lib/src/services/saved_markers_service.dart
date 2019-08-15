import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';

class SavedMarkersService with ChangeNotifier{

  Set<Marker> _markers;
  Firestore _firestore = Firestore.instance;
  Location _location = Location();
  Geoflutterfire _geo = Geoflutterfire();
  FirebaseStorage _storage = FirebaseStorage.instance;


  Future<List<String>> uploadPic(List<File> files) async {

    var userID = await FirebaseAuth.instance.currentUser();

    List<String> uploadedUrls = List();

    for(File file in files){

      //Create a reference to the location you want to upload to in firebase  
      StorageReference reference = _storage.ref().child('images/' + userID.email.toString() + '/' + basename(file.path) + Random().nextInt(1000).toString());

      //Upload the file to firebase 
      StorageUploadTask uploadTask = reference.putFile(file);

      // Waits till the file is uploaded then stores the download url 
      var location = await (await uploadTask.onComplete).ref.getDownloadURL();

      uploadedUrls.add(location.toString());

    }
    return uploadedUrls;
   }




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
            infoWindow: InfoWindow(title: document.data['details']['address']),
            markerId: MarkerId(document.documentID)
          );
          _addNewMarker(marker);
        }
      });

      notifyListeners();

    });
  }

  _mapFromAList(List<String> list) {
    int counter = 0;
    final map = {};
    for(String item in list){
      map[counter.toString()] = item;
      counter++;
    }
    return map;
  }

  Future<DocumentReference> addGeoPoint(Property property) async {
    
    List<String> uploadedPictures = await uploadPic(property.photos);
    var pos = await _location.getLocation();

    GeoFirePoint point = _geo.point(latitude: pos.latitude, longitude: pos.longitude);

    return _firestore.collection('locations').add({ 
      'position': point.data,
      'details': property.data,
      'pictures': _mapFromAList(uploadedPictures)
    });
  }


  startQuery() async {
     _updateMarkers();
  }
  
  Set<Marker> get markers => _markers;

}