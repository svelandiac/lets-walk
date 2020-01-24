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

  Future<List<String>> getZonas() async {

    List<String> zonas = List();

    var userQuery = await _firestore.collection('zonas').getDocuments();

    userQuery.documents.forEach((DocumentSnapshot document){
      zonas.add(document.data['nombreZona']);
    });

    return zonas;
  }

  void tryAssignValues(Function function) {
    try {
      function();
    }
    catch (e) {
      print('ERROR: Assigning values from database: $e');
    }
  }

  void _updateProperties() {
    
    var userQuery = _firestore.collection('propiedades');
    
    userQuery.snapshots().listen((data){
      var documentList = data.documents;
      locations.clearProperties();

      documentList.forEach((DocumentSnapshot document) {

        try {

          Property newProperty = Property();

          newProperty.documentID = document.documentID;

          // caracteristicasEdificio
          
          tryAssignValues(() {
            newProperty.gimnasioTiene = document.data['caracteristicasEdificio']['gimnasio']['tiene'];
            newProperty.gimnasioComentario = document.data['caracteristicasEdificio']['gimnasio']['comentario'];
          });

          tryAssignValues(() {
            newProperty.parqueInfantilTiene = document.data['caracteristicasEdificio']['parqueInfantil']['tiene'];
            newProperty.parqueInfantilComentario = document.data['caracteristicasEdificio']['parqueInfantil']['comentario'];
          });

          tryAssignValues(() {
            newProperty.parqueaderoVisitantesTiene = document.data['caracteristicasEdificio']['parqueaderoVisitantes']['tiene'];
            newProperty.parqueaderoVisitantesComentario = document.data['caracteristicasEdificio']['parqueaderoVisitantes']['comentario'];
          });

          tryAssignValues(() {
            newProperty.piscinaTiene = document.data['caracteristicasEdificio']['piscina']['tiene'];
            newProperty.piscinaComentario = document.data['caracteristicasEdificio']['piscina']['comentario'];
          });

          tryAssignValues(() {
            newProperty.plantaElectricaTiene = document.data['caracteristicasEdificio']['plantaElectrica']['tiene'];
            newProperty.plantaElectricaComentario = document.data['caracteristicasEdificio']['plantaElectrica']['comentario'];
          });

          tryAssignValues(() {
            newProperty.salaCineTiene = document.data['caracteristicasEdificio']['salaCine']['tiene'];
            newProperty.salaCineComentario = document.data['caracteristicasEdificio']['salaCine']['comentario'];
          });

          tryAssignValues(() {
            newProperty.salaJuntasTiene = document.data['caracteristicasEdificio']['salaJuntas']['tiene'];
            newProperty.salaJuntasComentario = document.data['caracteristicasEdificio']['salaJuntas']['comentario'];
          });

          tryAssignValues(() {
            newProperty.seguridadTiene = document.data['caracteristicasEdificio']['seguridad']['tiene'];
            newProperty.seguridadComentario = document.data['caracteristicasEdificio']['seguridad']['comentario'];
          });

          tryAssignValues(() {
            newProperty.zonaBBQTiene = document.data['caracteristicasEdificio']['zonaBBQ']['tiene'];
            newProperty.zonaBBQComentario = document.data['caracteristicasEdificio']['zonaBBQ']['comentario'];
          });

          // caracteristicasZona

          tryAssignValues(() {
            newProperty.parquesCercanosTiene = document.data['caracteristicasZona']['parquesCercanos']['tiene'];
            newProperty.parquesCercanosComentario = document.data['caracteristicasZona']['parquesCercanos']['comentario'];
          });

          tryAssignValues(() {
            newProperty.transportePublicoTiene = document.data['caracteristicasZona']['transportePublico']['tiene'];
            newProperty.transportePublicoComentario = document.data['caracteristicasZona']['transportePublico']['comentario'];
          });

          tryAssignValues(() {
            newProperty.viasAccesoTiene = document.data['caracteristicasZona']['viasAcceso']['tiene'];
            newProperty.viasAccesoComentario = document.data['caracteristicasZona']['viasAcceso']['comentario'];
          });

          // estaDisponible

          tryAssignValues(() {
            newProperty.estaDisponible = document.data['estaDisponible'];
          });

          // estadoDeLaPropiedad

          tryAssignValues(() {
            newProperty.acabados = document.data['estadoDeLaPropiedad']['acabados'];
            newProperty.fallas = document.data['estadoDeLaPropiedad']['fallas'];
            newProperty.iluminacion = document.data['estadoDeLaPropiedad']['iluminacion'];
            newProperty.ruido = document.data['estadoDeLaPropiedad']['ruido'];
            newProperty.ventilacion = document.data['estadoDeLaPropiedad']['ventilacion'];
          });

          // fechasDeCreacionYActualizacion

          tryAssignValues(() {
            newProperty.fechaActualizacion = document.data['fechaActualizacion'];
            newProperty.fechaCreacion = document.data['fechaCreacion'];
          });

          // fotos

          tryAssignValues(() {
            newProperty.fotos = document.data['fotos'];
          });

          // informacionDueno

          tryAssignValues(() {
            newProperty.abiertoContratoMandato = document.data['informacionDueno']['abiertoContratoMandato'];
            newProperty.amoblado = document.data['informacionDueno']['amoblado'];
            newProperty.comparteComision = document.data['informacionDueno']['comparteComision'];
            newProperty.correo = document.data['informacionDueno']['correo'];
            newProperty.nombre = document.data['informacionDueno']['nombre'];
            newProperty.numero = document.data['informacionDueno']['numero'];
            newProperty.puntoContacto = document.data['informacionDueno']['puntoContacto'];
          });

          // informacionPropiedad

          tryAssignValues(() {
            newProperty.antiguedad = document.data['informacionPropiedad']['antiguedad'];
            newProperty.costoAdministracion = document.data['informacionPropiedad']['costoAdministracion'];
            newProperty.descripcion = document.data['informacionPropiedad']['descripcion'];
            newProperty.direccion = document.data['informacionPropiedad']['direccion'];
            newProperty.estrato = document.data['informacionPropiedad']['estrato'];
            newProperty.incluyeAdministracion = document.data['informacionPropiedad']['incluyeAdministracion'];
            newProperty.mascotas = document.data['informacionPropiedad']['mascotas'];
          });

          tryAssignValues(() {
            newProperty.numeroDeBanos = document.data['informacionPropiedad']['numeroDeBanos']['numero'];
            newProperty.numeroDeBanosComentario = document.data['informacionPropiedad']['numeroDeBanos']['comentario'];
          });

          tryAssignValues(() {
            newProperty.numeroDeGarajes = document.data['informacionPropiedad']['numeroDeGarajes']['numero'];
            newProperty.numeroDeGarajesComentario = document.data['informacionPropiedad']['numeroDeGarajes']['comentario'];
          });

          tryAssignValues(() {
            newProperty.numeroDeHabitaciones = document.data['informacionPropiedad']['numeroDeHabitaciones']['numero'];
            newProperty.numeroDeHabitacionesComentario = document.data['informacionPropiedad']['numeroDeHabitaciones']['comentario'];
          });

          tryAssignValues(() {
            newProperty.piso = document.data['informacionPropiedad']['piso'];
            newProperty.precio = document.data['informacionPropiedad']['precio'];
            newProperty.puntoDeContactoPropiedad = document.data['informacionPropiedad']['puntoContacto'];
            newProperty.remodelado = document.data['informacionPropiedad']['remodelado'];
            newProperty.tamano = document.data['informacionPropiedad']['tamano'];
            newProperty.tipoApartamento = document.data['informacionPropiedad']['tipoApartamento'];
            newProperty.tipoDePiso = document.data['informacionPropiedad']['tipoDePiso'];
            newProperty.tipoDePropiedad= document.data['informacionPropiedad']['tipoPropiedad'];
            newProperty.zona = document.data['informacionPropiedad']['zona'];
          });

          // posicion

          tryAssignValues(() {
            newProperty.geohash = document.data['posicion']['geohash'];
            newProperty.puntoGeografico = document.data['posicion']['puntoGeografico'];
          });

          // tieneAtributos

          tryAssignValues(() {
            newProperty.tieneBalcon = document.data['tieneAtributos']['balcon'];
            newProperty.tieneChimenea = document.data['tieneAtributos']['chimenea'];
            newProperty.tieneCocinaAmericana = document.data['tieneAtributos']['cocinaAmericana'];
            newProperty.tieneCocinaIntegral = document.data['tieneAtributos']['cocinaIntegral'];
            newProperty.tieneDeposito = document.data['tieneAtributos']['deposito'];
            newProperty.tieneIluminado = document.data['tieneAtributos']['iluminado'];
            newProperty.tieneSilencioso = document.data['tieneAtributos']['silencioso'];
            newProperty.tieneTerraza = document.data['tieneAtributos']['terraza'];
          });

          // yaVisitado
          tryAssignValues(() {
            newProperty.yaVisitado = document.data['yaVisitado'];
          });

          locations.addNewProperty(newProperty);

        } catch (e) {
          print(e);
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