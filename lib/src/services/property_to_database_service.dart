import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class PropertyToDatabaseService {

  Firestore _firestore = Firestore.instance;
  Location _location = Location();
  Geoflutterfire _geo = Geoflutterfire();
  FirebaseStorage _storage = FirebaseStorage.instance;

  Locations locations;

  Future<List<String>> uploadPic(List<dynamic> files) async {

    var now = new DateTime.now();

    String currentDate = '${now.year}' + '${now.month}' + '${now.day}' + '${now.hour}' + '${now.minute}' + '${now.second}';

    List<String> uploadedUrls = List();

    for(File file in files){

      //Create a reference to the location you want to upload to in firebase  
      StorageReference reference = _storage.ref().child('platz/platz-property-$currentDate' + Random().nextInt(9).toString() + Random().nextInt(9).toString() + Random().nextInt(9).toString() + Random().nextInt(9).toString());

      //Upload the file to firebase 
      StorageUploadTask uploadTask = reference.putFile(file);

      // Waits till the file is uploaded then stores the download url 
      var location = await (await uploadTask.onComplete).ref.getDownloadURL();

      uploadedUrls.add(location.toString());

    }
    return uploadedUrls;
   }

  PropertyToDatabaseService(BuildContext context){

    locations = Provider.of<Locations>(context);
    
  }

  void _updateProperties() {
    
    var userQuery = _firestore.collection('propiedades');
    
    userQuery.snapshots().listen((data){
      var documentList = data.documents;
      locations.clearProperties();
      print(documentList.length);
      documentList.forEach((DocumentSnapshot document) {

        try {

          Property newProperty = Property();

          // caracteristicasEdificio
          

          locations.addNewProperty(newProperty);

        } catch (e) {

        }

      });
    });
  }

  String pairNumbers(String number) {

    if(number.length == 1)
      return '0' + number;

    return number;
  }

  Future<DocumentReference> addNewProperty(Property property) async {
    
    List<String> uploadedPictures = await uploadPic(property.fotos);
    var pos = await _location.getLocation();
    var now = new DateTime.now();
    String currentDate = '${pairNumbers(now.year.toString())}' + '-' + '${pairNumbers(now.month.toString())}' + '-' + '${pairNumbers(now.day.toString())}' + ' ' + '${pairNumbers(now.hour.toString())}' + ':' + '${pairNumbers(now.minute.toString())}' + ':' + '${pairNumbers(now.second.toString())}';

    GeoFirePoint point = _geo.point(latitude: pos.latitude, longitude: pos.longitude);

    return _firestore.collection('propiedades').add({ 
      'posicion': {
        'puntoGeografico': [pos.latitude, pos.longitude],
        'geohash' : point.hash
      },
      'fotos': uploadedPictures,
      'caracteristicasEdificio': {
        'gimnasio': {
          'comentario': '',
          'tiene': false
        },
        'parqueInfantil': {
          'comentario': '',
          'tiene': false
        },
        'parqueaderoVisitantes': {
          'comentario': '',
          'tiene': false
        },
        'piscina': {
          'comentario': '',
          'tiene': false
        },
        'plantaElectrica': {
          'comentario': '',
          'tiene': false
        },
        'salaCine': {
          'comentario': '',
          'tiene': false
        },
        'salaJuntas': {
          'comentario': '',
          'tiene': false
        },
        'seguridad': {
          'comentario': '',
          'tiene': false
        },
        'zonaBBQ': {
          'comentario': '',
          'tiene': false
        },
      },
      'caracteristicasZona': {
        'parquesCercanos': {
          'comentario': '',
          'tiene': false
        },
        'transportePublico': {
          'comentario': '',
          'tiene': false
        },
        'viasAcceso': {
          'comentario': '',
          'tiene': false
        },
      },
      'estaDisponible': '',
      'estadoDeLaPropiedad': {
        'acabados': 0,
        'fallas': '',
        'iluminacion': 0,
        'ruido': 0,
        'ventilacion': 0,
      },
      'fechaActualizacion': currentDate,
      'fechaCreacion': currentDate,
      'informacionDueno': {
        'abiertoContratoMandato': false,
        'comparteComision': false,
        'puntoContacto': false,
        'amoblado': false,
        'nombre': '',
        'numero': property.numero,
        'correo': '' 
      },
      'informacionPropiedad': {
        'piso': 0,
        'antiguedad': 0,
        'costoAdministracion': '',
        'incluyeAdministracion': false,
        'descripcion': property.descripcion,
        'direccion': property.direccion,
        'estrato': 0,
        'mascotas': false,
        'numeroDeBanos': {
          'comentario': '',
          'numero': 0
        },
        'numeroDeGarajes': {
          'comentario': '',
          'numero': 0
        },
        'numeroDeHabitaciones': {
          'comentario': '',
          'numero': 0
        },
        'precio': '',
        'puntoContacto': '',
        'remodelado': false,
        'tamano': 0,
        'tipoApartamento': '',
        'tipoDePiso': '',
        'tipoPropiedad': '',
        'zona': property.zona
      },
      'tieneAtributos': {
        'balcon': false,
        'chimenea': false,
        'cocinaAmericana': false,
        'cocinaIntegral': false,
        'deposito': false,
        'iluminado': false,
        'silencioso': false,
        'terraza': false,
      },
      'yaVisitado': false
    });
  }

  startQuery() async {
    _updateProperties();
  }
  
}