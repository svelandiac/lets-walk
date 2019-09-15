import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:lets_walk/src/ui/callbacks/callback_container.dart';
import 'package:lets_walk/src/ui/callbacks/callback_object.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class Map extends StatefulWidget {

  final CallbackContainer callbackContainer;

  Map({this.callbackContainer});

  @override
  State createState() => MapState(callbackContainer: callbackContainer);
}


class MapState extends State<Map> with AutomaticKeepAliveClientMixin<Map>{

  CallbackContainer callbackContainer;

  SavedMarkersService markersService;
  GoogleMapController mapController;
  Location location = Location();
  Locations locations;

  MapState({this.callbackContainer});

  build(context) {
    super.build(context);

    markersService  = SavedMarkersService(context);
    locations = Provider.of<Locations>(context);

    CallbackObject callbackObject = CallbackObject(
      callBackFunction: (GeoPoint point){
        animateToGeopoint(point);
      }
    );

    callbackContainer.callbackObject = callbackObject;

    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: CameraPosition(target: LatLng(4.703970, -74.042797), zoom: 7),
          onMapCreated: _onMapCreated,
          myLocationEnabled: true, // Add little blue dot for device location, requires permission from user
          myLocationButtonEnabled: true,
          mapType: MapType.normal, 
          rotateGesturesEnabled: true,
          scrollGesturesEnabled: true,
          tiltGesturesEnabled: true,
          zoomGesturesEnabled: true,
          mapToolbarEnabled: true,        
          markers: locations.markers,  
        ),
      ]
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      markersService.startQuery();
      mapController = controller;
      _animateToUser();
    });
  }

  Future<void> _animateToUser() async {
    var pos = await location.getLocation();
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 17
      )
    ));
  }

  Future<void> animateToGeopoint(GeoPoint point) async {
    print('The point is:\nLatitude = ${point.latitude}\nLongitude = ${point.longitude}');
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(point.latitude, point.longitude),
        zoom: 20
      )
    ));
  }

  @override
  bool get wantKeepAlive => true;

}