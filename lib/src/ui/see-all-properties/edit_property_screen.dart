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
  TextEditingController _kindOfPropertyController = TextEditingController();
  TextEditingController _numberOfBathsController = TextEditingController();
  TextEditingController _numberOfRoomsController = TextEditingController();
  TextEditingController _sizeController = TextEditingController();
  TextEditingController _yearsOldController = TextEditingController();
  TextEditingController _numberOfParkingController = TextEditingController();
  TextEditingController _stratumController = TextEditingController();

  TextEditingController _acabadosController = TextEditingController();
  TextEditingController _ruidoController = TextEditingController();
  TextEditingController _iluminacionController = TextEditingController();
  TextEditingController _ventilacionController = TextEditingController();
  TextEditingController _fallasController = TextEditingController();

  TextEditingController _nombrePropietarioController = TextEditingController();
  TextEditingController _numeroController = TextEditingController();
  TextEditingController _precioArriendoController = TextEditingController();
  TextEditingController _costoAdministracionController = TextEditingController();
  
  bool _arriendoAmoblado;
  bool _abiertoContratoMandato;
  
  String _available;

  bool _visited;

  var _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool _petsController;
  bool _remakedController;

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
                    'Comentario:',
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
            SizedBox(height: 30.0,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Tipo de propiedad:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _kindOfPropertyController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Número de habitaciones:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _numberOfRoomsController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Número de baños:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _numberOfBathsController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Metros cuadrados:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _sizeController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Antigüedad (años):',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _yearsOldController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Cantidad de parqueaderos:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _numberOfParkingController,      
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Estrato:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _stratumController,      
                    ),
                  ),
                ],
              ),
            ),  
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    '¿Se permiten mascotas?:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: (this._petsController),
                    onChanged: (newValue){
                      setState(() {
                        _petsController = newValue;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
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
                    '¿Propiedad remodelada?:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  Spacer(),
                  Switch(
                    value: (this._remakedController),
                    onChanged: (newValue){
                      setState(() {
                        _remakedController = newValue;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 40.0),
                child: Text(
                  'Estado de la propiedad:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 100.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Acabados:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: _acabadosController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 100.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Ruido:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: _ruidoController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 100.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Iluminación:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: _iluminacionController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 100.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Ventilación:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    width: 40,
                    child: TextField(
                      controller: _ventilacionController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Fallas, fisuras, etc:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _fallasController,
                    ),
                  )
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 40.0),
                child: Text(
                  'Datos del propietario:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Nombre:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _nombrePropietarioController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Número:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _numeroController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Precio de arriendo esperado:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _precioArriendoController,
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '¿Arriendo amoblado?:'
                  ),
                  Spacer(),
                  Switch(
                    value: (this._arriendoAmoblado),
                    onChanged: (newValue){
                      setState(() {
                        _arriendoAmoblado = newValue;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 40.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Costo de administración:'
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _costoAdministracionController,
                    ),
                  )
                ],
              ),
            ),   
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    '¿Abierto a contrato de mandato?:'
                  ),
                  Spacer(),
                  Switch(
                    value: (this._abiertoContratoMandato),
                    onChanged: (newValue){
                      setState(() {
                        _abiertoContratoMandato = newValue;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),         
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 40.0),
                child: Text(
                  'Estado actual:',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Disponible:'
                  ),
                  Spacer(),
                  Switch(
                    value: (_available == 'disponible'),
                    onChanged: (newValue){
                      setState(() {
                        if(newValue)
                          _available = 'disponible';
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),     
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Ocupado:'
                  ),
                  Spacer(),
                  Switch(
                    value: (_available == 'ocupado'),
                    onChanged: (newValue){
                      setState(() {
                        if(newValue)
                          _available = 'ocupado';
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ),     
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'No sabemos:'
                  ),
                  Spacer(),
                  Switch(
                    value: (_available == 'noSabemos'),
                    onChanged: (newValue){
                      setState(() {
                        if(newValue)
                          _available = 'noSabemos';
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
                ],
              ),
            ), 
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 0.0, top: 20.0),
              child: Row(
                children: <Widget>[
                  Text(
                    'Visitado:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 40,),
                  Switch(
                    value: (this._visited),
                    onChanged: (newValue){
                      setState(() {
                        _visited = newValue;
                      });
                    },
                    activeColor: Colors.black,
                  ),
                  SizedBox(
                    width: 40,
                  )
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

    property.kindOfProperty = _kindOfPropertyController.text;
    property.numberOfBaths = int.parse(_numberOfBathsController.text);
    property.numberOfRooms = int.parse(_numberOfRoomsController.text);
    property.size = double.parse(_sizeController.text);
    property.yearsOld = int.parse(_yearsOldController.text);
    property.numberOfParking = int.parse(_numberOfParkingController.text);
    property.pets = _petsController;
    property.remaked = _remakedController;
    property.stratum = int.parse(_stratumController.text);
    
    property.acabados = int.parse(_acabadosController.text);
    property.ruido = int.parse(_ruidoController.text);
    property.iluminacion = int.parse(_iluminacionController.text);
    property.ventilacion = int.parse(_ventilacionController.text);
    property.fallas = _fallasController.text;

    property.currentState = _available;
    property.abiertoContratoMandato = _abiertoContratoMandato;
    property.arriendoAmoblado = _arriendoAmoblado;
    property.costoAdministracion = _costoAdministracionController.text;
    property.nombrePropietario = _nombrePropietarioController.text;
    property.numeroPropietario = _numeroController.text;
    property.precioArriendoEsperado = _precioArriendoController.text;

    property.visited = _visited;

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

      _petsController = false;
      _remakedController = false;
      _arriendoAmoblado = false;
      _abiertoContratoMandato = false;

      _available = 'disponible';
      _visited = false;

    }
  
   return Scaffold(
     key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Editar los inmuebles añadidos'),
        centerTitle: true,
      ),
      body: _buildBody(),
    );
  }
}