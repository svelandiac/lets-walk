import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/models/zonas.dart';
import 'package:lets_walk/src/services/property_to_database_service.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';

class AddPropertyUser02Screen extends StatefulWidget {
  @override
  _AddPropertyUser02ScreenState createState() => _AddPropertyUser02ScreenState();
}

class _AddPropertyUser02ScreenState extends State<AddPropertyUser02Screen> {
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  PropertyToDatabaseService propertyToDatabaseService;

  bool _isButtonEnabled;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  Property newProperty = Property();

  List<String> _zonasTypes;
  List<DropdownMenuItem<String>> _zonasMenuItems;
  String _zonaSeleccionada;

  Zonas zonas;

  void getZones() async {

    zonas.zonas = await propertyToDatabaseService.getZonas();

    return;
  }

  _onChangeZona(String value) {
    setState(() {
      _zonaSeleccionada = value;
    });
  }

  final uploadingSnackBar = SnackBar(
    content: Text('Añadiendo el inmueble...'),
    duration: Duration(days: 2),
  );

  final successSnackBar = SnackBar(
    content: Text('Inmueble añadido satisfactoriamente'),
    backgroundColor: Colors.green,
  );

  SnackBar _messageSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.red,
    );
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source, imageQuality: 35);

    setState(() {
      if (image != null) newProperty.fotos.add(image);
    });
    Navigator.of(context).pop();
  }

  void _submit() {
    if (newProperty.fotos.isNotEmpty) {
      _scaffoldKey.currentState.showSnackBar(uploadingSnackBar);

      setState(() {
        this._isButtonEnabled = false;
      });

      newProperty.direccion = _addressController.text;
      newProperty.numero = _contactNumberController.text;
      newProperty.descripcion = _descriptionController.text;
      newProperty.zona = _zonaSeleccionada;

      propertyToDatabaseService.addNewProperty(newProperty).then((onValue) {
        setState(() {
          this._isButtonEnabled = true;
          _scaffoldKey.currentState.hideCurrentSnackBar();
          _scaffoldKey.currentState.showSnackBar(successSnackBar);
        });
      }).catchError((onError) {
        setState(() {
          _scaffoldKey.currentState.hideCurrentSnackBar();
          this._isButtonEnabled = true;
        });
      });
    } else {
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState
          .showSnackBar(_messageSnackBar('Añade por lo menos una foto'));
    }
  }

  @override
  void initState() {
    super.initState();
    this._isButtonEnabled = true;
  }

  List<DropdownMenuItem<String>> buildDropdownMenuItems(List strings) {
    List<DropdownMenuItem<String>> items = List();
    for(String string in strings) {
      items.add(DropdownMenuItem(
        value: string,
        child: Text(
          string
        ),
      ));
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    propertyToDatabaseService = PropertyToDatabaseService(context);
    zonas = Provider.of<Zonas>(context);

    getZones();

    if(zonas.zonas != null) {

      _zonasTypes = zonas.zonas;

      _zonasMenuItems = buildDropdownMenuItems(_zonasTypes);

      if(_zonaSeleccionada == null)
        _zonaSeleccionada = _zonasMenuItems[0].value;

    }

    void _showCameraOptions() {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text(
                'Seleccionar una foto',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Text('¿Desde dónde quieres subir la foto?'),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'Desde la galería',
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                ),
                FlatButton(
                  child: Text('Desde la cámara',
                      style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                )
              ],
            );
          });
    }

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Usuario 02'),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Agregar un inmueble',
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '',
                  style: TextStyle(
                    fontSize: 13.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0, left: 25.0),
                  child: TextField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        hintText: 'Calle 116 # 15 - 32',
                        labelText: 'Dirección del inmueble'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                  child: TextField(
                    controller: _contactNumberController,
                    decoration: InputDecoration(
                        hintText: '+57 315 343 40 25',
                        labelText: 'Número de contacto'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25.0, top: 10.0),
                  child: TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Comentarios adicionales',
                        labelText: 'Comentarios'),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(right: 25.0, left: 25.0, top: 20.0),
                  child: Row(
                    children: <Widget>[
                      Text(
                        'Zona:'
                      ),
                      SizedBox(width: 40,),
                      (zonas.zonas != null) ?
                      DropdownButton(
                        value: _zonaSeleccionada,
                        items: _zonasMenuItems,
                        onChanged: _onChangeZona,
                      ) :
                      Text('Cargando zonas...')
                    ],
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
                    style:
                        TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
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
                      crossAxisSpacing: 20.0),
                  itemCount: 8,
                  itemBuilder: (context, index) {
                    if (newProperty.fotos.length < index + 1)
                      return GestureDetector(
                        child: _noPhoto(index),
                        onTap: () {
                          _showCameraOptions();
                        },
                      );
                    else
                      return Container(
                        child: Image.file(newProperty.fotos.elementAt(index),
                            fit: BoxFit.cover),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
                        height: 50,
                        width: 50.0,
                      );
                  },
                )
              ],
            ),
          ),
        ));
  }

  Widget _noPhoto(int index) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'Foto ${index + 1}',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.0,
          ),
          Icon(Icons.add_a_photo)
        ],
      ),
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      height: 50,
      width: 50.0,
    );
  }
}
