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

    List<String> uploadedUrls = List();

    for(File file in files){

      //Create a reference to the location you want to upload to in firebase  
      StorageReference reference = _storage.ref().child('images/' + basename(file.path) + Random().nextInt(100000).toString());

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
    
    var userQuery = _firestore.collection('propiedades');
    
    userQuery.snapshots().listen((data){
      var documentList = data.documents;
      locations.clearProperties();
      print(documentList.length);
      documentList.forEach((DocumentSnapshot document) {

        Property newProperty = Property();

        //Document ID
        if(document.documentID!=null)
          newProperty.documentID = document.documentID;

        print(document.data['informacionPropiedad']['direccion']);

        //document.details
        if(document.data['informacionPropiedad']['direccion']!=null)
          newProperty.address = document.data['informacionPropiedad']['direccion'];
        if(document.data['informacionPropiedad']['descripcion']!=null)
          newProperty.description = document.data['informacionPropiedad']['descripcion'];
        if(document.data['informacionDueno']['numero']!=null)
          newProperty.contactNumber = document.data['informacionDueno']['numero'];
        if(document.data['informacionPropiedad']['zona']!=null)
          newProperty.zone = document.data['informacionPropiedad']['zona'];
        
        //document.pictures
        if(document.data['fotos'][0]!=null){
          newProperty.photos = document.data['fotos'];
        }

        //document.position
        GeoPoint position = document.data['posicion']['puntoGeografico'];
        newProperty.location = position;

        //document.geohash
        newProperty.geohash = document.data['posicion']['geohash'];

        //Show property
        newProperty.show = true;

        //document.currentState
        if(document.data['estaDisponible'] == null)
          newProperty.currentState = 'disponible';
        else 
          newProperty.currentState = document.data['estaDisponible'];

        //document.modifications
        if(document.data['informacionPropiedad'] != null){
          newProperty.kindOfProperty = document.data['informacionPropiedad']['tipoPropiedad'];
          newProperty.numberOfBaths = document.data['informacionPropiedad']['numeroDeBanos']['numero'];
          newProperty.numberOfParking = document.data['informacionPropiedad']['numeroDeGarajes']['numero'];
          newProperty.numberOfRooms = document.data['informacionPropiedad']['numeroDeHabitaciones']['numero'];
          newProperty.pets = document.data['informacionPropiedad']['mascotas'];
          newProperty.remaked = document.data['informacionPropiedad']['remodelado'];
          newProperty.size = document.data['informacionPropiedad']['tamano'];
          newProperty.stratum = document.data['informacionPropiedad']['estrato'];
          newProperty.yearsOld = document.data['informacionPropiedad']['antiguedad'];
          newProperty.costoAdministracion = document.data['informacionPropiedad']['costoAdministracion'];
          newProperty.precioArriendoEsperado = document.data['informacionPropiedad']['precio'];
        }

        //document.ownerInfo
        if(document.data['informacionDueno'] != null) {
          newProperty.abiertoContratoMandato = document.data['informacionDueno']['abiertoContratoMandato'];
          newProperty.arriendoAmoblado = document.data['informacionDueno']['amoblado'];
          newProperty.comparteComision = document.data['informacionDueno']['comparteComision'];
          newProperty.nombrePropietario = document.data['informacionDueno']['nombre'];
          newProperty.numeroPropietario = document.data['informacionDueno']['numero'];
          
        }
        

        //document.status
        if(document.data['estadoDeLaPropiedad'] != null) {
          newProperty.acabados = document.data['estadoDeLaPropiedad']['acabados'];
          newProperty.fallas = document.data['estadoDeLaPropiedad']['fallas'];
          newProperty.iluminacion = document.data['estadoDeLaPropiedad']['iluminacion'];
          newProperty.ruido = document.data['estadoDeLaPropiedad']['ruido'];
          newProperty.ventilacion = document.data['estadoDeLaPropiedad']['ventilacion'];
        }
        

        //document.visited
        if(document.data['yaVisitado'] != null)
          newProperty.visited = document.data['yaVisitado'];

        if(document.data['yaVisitado'] != null)
          newProperty.visited = document.data['yaVisitado'];

        locations.addNewProperty(newProperty);
        
      });
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
      'pictures': _mapFromAList(uploadedPictures),
    });
  }

  startQuery() async {
    _updateMarkers();
  }
  
}