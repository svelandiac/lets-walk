import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';

class EditPropertyScreen extends StatefulWidget {
  
  @override
  _EditPropertyScreenState createState() => _EditPropertyScreenState();
}

class _EditPropertyScreenState extends State<EditPropertyScreen> {

  ModifyPropertiesService modifyPropertiesService;
  Property property;

  //TextFields controllers
  TextEditingController _addressController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _observationsController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _neighborhoodController = TextEditingController();

  var _scaffoldKey = new GlobalKey<ScaffoldState>();


  final uploadingSnackBar = SnackBar(
    content: Text('Editando el inmueble...'),
    duration: Duration(days: 2),
  );

  final successSnackBar = SnackBar(
    content: Text('Inmueble editado satisfactoriamente'),
    backgroundColor: Colors.green,
  );

  bool _isButtonEnabled;

  Widget _buildBody(){
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            SizedBox(height: 40.0,),
            Text(
              'Edita un inmueble',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              'Estás editando la información del siguiente inmueble:',
              style: TextStyle(
                fontSize: 13.0,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
            ),
            SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Dirección:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _addressController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Contacto:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _contactNumberController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Barrio:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _neighborhoodController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Descripción:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,      
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 40.0),
                child: Text(
                  'Estado:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'No contactado'
                  ),
                  Spacer(),
                  Switch(
                    value: (property.isContacted=='noContacted'),
                    onChanged: (newValue){
                      setState(() {
                        property.isContacted = 'noContacted';
                      });
                    },
                    activeColor: Colors.red,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Contactado'
                  ),
                  Spacer(),
                  Switch(
                    value: (property.isContacted=='contacted'),
                    onChanged: (newValue){
                      setState(() {
                        property.isContacted = 'contacted';
                      });
                    },
                    activeColor: Colors.green,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Ocupada'
                  ),
                  Spacer(),
                  Switch(
                    value: (property.isContacted=='busy'),
                    onChanged: (newValue){
                      setState(() {
                        property.isContacted = 'busy';
                      });
                    },
                    activeColor: Colors.yellow,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Disponible'
                  ),
                  Spacer(),
                  Switch(
                    value: (property.isContacted=='available'),
                    onChanged: (newValue){
                      setState(() {
                        property.isContacted = 'available';
                      });
                    },
                    activeColor: Colors.blue,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 60.0, top: 5.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Perdida'
                  ),
                  Spacer(),
                  Switch(
                    value: (property.isContacted=='lost'),
                    onChanged: (newValue){
                      setState(() {
                        property.isContacted = 'lost';
                      });
                    },
                    activeColor: Colors.black,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Observaciones:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _observationsController,   
                      decoration: InputDecoration(
                        labelText: 'Observaciones'
                      ),   
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    'Fecha vencimiento\ndel contrato:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _dateController,   
                      decoration: InputDecoration(
                        hintText: 'dd/mm/aa',
                        labelText: 'Fecha de vencimiento'
                      ),   
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: RoundedOutlinedButton(
                text: 'Actualizar el inmueble',
                width: 200,
                onPressed: _isButtonEnabled ? _submit : null,
              ),
            ),
            SizedBox(height: 40.0,),
          ],
        ),
      ),
    );
  }

  void _submit(){

    setState(() {
      _isButtonEnabled = false;
    });
    _scaffoldKey.currentState.showSnackBar(uploadingSnackBar);

    property.address = _addressController.text;
    property.contactNumber = _contactNumberController.text;
    property.description = _descriptionController.text;
    property.observations = _observationsController.text;
    property.date = _dateController.text;
    property.neighborhood = _neighborhoodController.text;

    modifyPropertiesService.property = property;
    modifyPropertiesService.editProperty().then((onValue){
      setState(() {
        _isButtonEnabled = true;
        _scaffoldKey.currentState.hideCurrentSnackBar();
        _scaffoldKey.currentState.showSnackBar(successSnackBar);
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _isButtonEnabled = true;
  }

  @override
  Widget build(BuildContext context) {

    if(modifyPropertiesService==null){

      modifyPropertiesService  = Provider.of<ModifyPropertiesService>(context);
      property = modifyPropertiesService.property;
      _addressController.text = property.address; 
      _contactNumberController.text = property.contactNumber;
      _descriptionController.text = property.description;
      _dateController.text = property.date;
      _observationsController.text = property.observations;
      _neighborhoodController.text = property.neighborhood;
    }
  
   return Scaffold(
     key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Ver los inmuebles añadidos'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}