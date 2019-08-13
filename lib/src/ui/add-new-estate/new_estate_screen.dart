import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class NewEstateScreen extends StatelessWidget{
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir un nuevo inmueble'),
        centerTitle: true,
      ),
      body: FireMap(),
    );
  }

}

class FireMap extends StatefulWidget {
  @override
  State createState() => FireMapState();
}


class FireMapState extends State<FireMap> {

  SavedMarkersService markersService;
  GoogleMapController mapController;
  Location location = Location();

  build(context) {

    markersService = Provider.of<SavedMarkersService>(context);

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
          mapToolbarEnabled: false,          
          markers: markersService.markers,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: FloatingActionButton(
            heroTag: 'addNewMarkerButton',
            child: Icon(Icons.add_location),
            onPressed: (){markersService.addGeoPoint('My home');},
            backgroundColor: Colors.red,
          ),
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


}