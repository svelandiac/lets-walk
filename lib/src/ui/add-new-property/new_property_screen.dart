import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';

class NewPropertyScreen extends StatefulWidget {
  @override
  _NewPropertyScreenState createState() => _NewPropertyScreenState();
}

class _NewPropertyScreenState extends State<NewPropertyScreen> {

  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  SavedMarkersService  markersService;

  bool _isButtonEnabled;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Property newProperty = Property();

  final uploadingSnackBar = SnackBar(
    content: Text('Añadiendo el inmueble...'),
    duration: Duration(days: 2),
  );

  final successSnackBar = SnackBar(
    content: Text('Inmueble añadido satisfactoriamente'),
    backgroundColor: Colors.green,
  );

  SnackBar _messageSnackBar(String message){
    return SnackBar(
      content: Text(message, style: TextStyle(color: Colors.white),),
      backgroundColor: Colors.red,
    );
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    setState(() {
      if(image!=null)
        newProperty.photos.add(image);
    });
    Navigator.of(context).pop();
  }

  void _submit(){
    if(newProperty.photos.isNotEmpty){

      _scaffoldKey.currentState.showSnackBar(uploadingSnackBar);

      setState(() {
        this._isButtonEnabled = false;
      });

      newProperty.address = _addressController.text;
      newProperty.contactNumber = _contactNumberController.text;
      newProperty.description = _descriptionController.text;

      markersService.addGeoPoint(newProperty).then((onValue){
        setState(() {
          this._isButtonEnabled = true;
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(successSnackBar);
        });
      }).catchError((onError){
        setState(() {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          this._isButtonEnabled = true;
        });
      });
    }
    else{
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(_messageSnackBar('Añade por lo menos una foto'));
    }
  }

  @override
  void initState() {
    super.initState();
    this._isButtonEnabled = true;
  }

  @override
  Widget build(BuildContext context) {

    markersService = SavedMarkersService(context);

    void _showCameraOptions(){
      showDialog(
        context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text('Seleccionar una foto', style: TextStyle(fontWeight: FontWeight.bold),),
            content: Text('¿Desde dónde quieres subir la foto?'),

            actions: <Widget>[
              FlatButton(
                child: Text('Desde la galería', style: TextStyle(color: Colors.black),),
                onPressed: (){
                  getImage(ImageSource.gallery);
                },
              ),
              FlatButton(
                child: Text('Desde la cámara', style: TextStyle(color: Colors.black)),
                onPressed: (){
                  getImage(ImageSource.camera);
                },
              )
            ],
          );
        }
      );
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
              Text(
                'Debes añadir al menos una foto\nLa información adicional es opcional\nPuedes editarla en cualquier momento',
                style: TextStyle(
                  fontSize: 13.0,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                child: TextField(
                  controller: _addressController,
                  decoration: InputDecoration(
                    hintText: 'Calle 116 # 15 - 32',
                    labelText: 'Dirección del inmueble [Opcional]'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                child: TextField(
                  controller: _contactNumberController,
                  decoration: InputDecoration(
                    hintText: '+57 315 343 40 25',
                    labelText: 'Número de contacto [Opcional]'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                child: TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    hintText: 'Descripción del inmueble',
                    labelText: 'Descripción [Opcional]'
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: RoundedOutlinedButton(
                  text: 'Agregar el inmueble',
                  width: 200,
                  onPressed: _isButtonEnabled ? _submit : null,
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
                        _showCameraOptions();
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