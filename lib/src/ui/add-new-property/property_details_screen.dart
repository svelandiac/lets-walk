import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:provider/provider.dart';

class PropertyDetailsScreen extends StatefulWidget {
  @override
  _PropertyDetailsScreenState createState() => _PropertyDetailsScreenState();
}

class _PropertyDetailsScreenState extends State<PropertyDetailsScreen> {

  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  SavedMarkersService  markersService;

  bool _uploading;
  bool _taskCompletedSuccessfully;

  bool _isButtonEnabled;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();


  Property newProperty = Property();

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if(image!=null)
        newProperty.photos.add(image);
    });
  }

  void _submit(){
    if(_addressController.text.isNotEmpty&&_contactNumberController.text.isNotEmpty&&_descriptionController.text.isNotEmpty&&_isButtonEnabled){

      setState(() {
        this._uploading = true;
        this._isButtonEnabled = false;
      });

      newProperty.address = _addressController.text;
      newProperty.contactNumber = _contactNumberController.text;
      newProperty.description = _descriptionController.text;

      print('New property details:\nAddress: ${newProperty.address}\nContact number: ${newProperty.contactNumber}\nDescription: ${newProperty.description}');
      markersService.addGeoPoint(newProperty).then((onValue){
        setState(() {
          this._uploading = false;
          this._taskCompletedSuccessfully = true;
          this._isButtonEnabled = true;
        });
      }).catchError((onError){
        setState(() {
          this._uploading = false;
          this._isButtonEnabled = true;
        });
      });
    }
  }

  @override
  void initState() {
    super.initState();
    this._uploading = false;
    this._taskCompletedSuccessfully = false;
    this._isButtonEnabled = true;
  }

  @override
  Widget build(BuildContext context) {

    markersService = Provider.of<SavedMarkersService>(context);

    final uploadingSnackBar = SnackBar(
      content: Text('Añadiendo el inmueble...'),
    );

    final successSnackBar = SnackBar(
      content: Text('Inmueble añadido satisfactoriamente'),
      backgroundColor: Colors.green,
    );

    if(_uploading){
      _scaffoldKey.currentState.showSnackBar(uploadingSnackBar);
    }

    if(_taskCompletedSuccessfully){
      _scaffoldKey.currentState.showSnackBar(successSnackBar).closed.then((onValue){
        setState(() {
          this._taskCompletedSuccessfully = false;
        });
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Añadir un nuevo inmueble'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  'Añade información adicional',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Calle 116 # 15 - 32',
                    labelText: 'Dirección del inmueble'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                child: TextField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(
                    hintText: '+57 315 343 40 25',
                    labelText: 'Número de contacto'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Descripción del inmueble',
                    labelText: 'Descripción'
                  ),
                ),
              ),
              Container(
                width: 200,
                padding: EdgeInsets.only(top: 30.0),
                child: OutlineButton(
                  child: Text('Agregar el inmueble'),
                  shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                  borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                  highlightedBorderColor: Colors.black,
                  onPressed: _submit,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: Text(
                  'Añadir imágenes',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
              Text(
                'Puedes añadir hasta 8 imágenes',
                style: TextStyle(
                  fontSize: 13.0,
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.all(20.0),
                physics: ScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20.0,
                  crossAxisSpacing: 20.0
                ),
                itemCount: 8,
                itemBuilder: (context, index){
                  if(newProperty.photos.length<index+1) 
                    return GestureDetector(
                      child: _noPhoto(index),
                      onTap: (){
                        getImage();
                      },
                    );
                  else
                    return Container(
                      child: Image.file(newProperty.photos.elementAt(index), fit: BoxFit.cover),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black)
                      ),
                      height: 50,
                      width: 50.0,
                    );
                },
              )
            ],
          ),
        ),
      )
    );
  }

  Widget _noPhoto(int index){
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Foto ${index+1}', style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 20.0,),
          Icon(Icons.add_a_photo)
        ],
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black)
      ),
      height: 50,
      width: 50.0,
    );
  }
}