import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:location/location.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

class SavedMarkersService {

  Firestore _firestore = Firestore.instance;
  Location _location = Location();
  Geoflutterfire _geo = Geoflutterfire();
  FirebaseStorage _storage = FirebaseStorage.instance;

  Locations locations;

  Future<List<String>> uploadPic(List<dynamic> files) async {

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

  SavedMarkersService(BuildContext context){

    locations = Provider.of<Locations>(context);
    
  }

  void _updateMarkers() {
    
    var userQuery = _firestore.collection('locations').orderBy("details.address");
    
    var documentsNumber = 0;
    userQuery.snapshots().listen((data){
      var documentList = data.documents;
      locations.clearProperties();
      documentList.forEach((DocumentSnapshot document) {
        documentsNumber++;

        if(document.data['position']!=null){
          Property newProperty = Property();

          //Document ID
          if(document.documentID!=null)
            newProperty.documentID = document.documentID;

          //document.details
          if(document.data['details']['address']!=null)
            newProperty.address = document.data['details']['address'];
          if(document.data['details']['description']!=null)
            newProperty.description = document.data['details']['description'];
          if(document.data['details']['contactNumber']!=null)
            newProperty.contactNumber = document.data['details']['contactNumber'];
          
          //document.pictures
          if(document.data['pictures']['0']!=null){
            List<String> images = List();
            Map<String, dynamic> picturesMap = Map<String, dynamic>.from(document.data['pictures']);
            for(var imageURL in picturesMap.entries){
              images.add(imageURL.value);
            }
            newProperty.photos = images;
          }

          //document.position
          GeoPoint position = document.data['position']['geopoint'];
          newProperty.location = position;

          //document.state
          if(document.data['isContacted'] == null)
            newProperty.isContacted = 'noContacted';
          else
            newProperty.isContacted = document.data['isContacted'];

          if(document.data['contacting']!=null){
            newProperty.date = document.data['contacting']['date'];
            newProperty.observations = document.data['contacting']['observations'];
          }

          //document.geohash
          newProperty.geohash = document.data['position']['geohash'];

          locations.addNewProperty(newProperty);
        }
      });
      print('Documents found: $documentsNumber');
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
      'details': property.details,
      'pictures': _mapFromAList(uploadedPictures)
    });
  }

  startQuery() async {
     _updateMarkers();
  }
  
}