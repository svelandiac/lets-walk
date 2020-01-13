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


  List<String> _kindOfPropertyTypes;
  List<String> _oneToFiveTypes;
  List<String> _tipoDeApartamentoTypes;
  List<String> _tipoDePisoTypes;
  List<String> _puntoDeContactoTypes;
  List<DropdownMenuItem<String>> _dropdownMenuItems;
  List<DropdownMenuItem<String>> _oneToFiveMenuItems;
  List<DropdownMenuItem<String>> _tipoDeApartamentoMenuItems;
  List<DropdownMenuItem<String>> _tipoDePisoMenuItems;
  List<DropdownMenuItem<String>> _puntoDeContactoMenuItems;
  String _selectedKindOfProperty;
  String _tipoDeApartamento;
  String _tipoDePiso;
  String _puntoDeContacto;

  String oneToFiveHabitacionesValue;
  String oneToFiveBanosValue;
  String oneToFiveGarajesValue;
  String oneToFiveEstratoValue;
  String oneToFiveAcabadosValue;
  String oneToFiveRuidoValue;
  String oneToFiveIluminacionValue;
  String oneToFiveVentilacionValue;

  TextEditingController _comentarioHabitacionesController = TextEditingController();
  TextEditingController _comentarioBanosController = TextEditingController();
  TextEditingController _comentarioGarajesController = TextEditingController();

  bool chimenea = false;
  bool balcon = false;
  bool terraza = false;
  bool cocinaIntegral = false;
  bool cocinaAmericana = false;
  bool deposito = false;
  bool silencioso = false;
  bool iluminado = false;

  final uploadingSnackBar = SnackBar(
    content: Text('Editando el inmueble...'),
    duration: Duration(days: 2),
  );

  final successSnackBar = SnackBar(
    content: Text('Inmueble editado satisfactoriamente'),
    backgroundColor: Colors.green,
  );

  _onChangeKindOfPropertyMenu(String value) {
    setState(() {
      _selectedKindOfProperty = value;
    });
  }

  _onChangeTipoDeApartamentoMenu(String value) {
    setState(() {
      _tipoDeApartamento = value;
    });
  }

  oneToFiveHabitaciones(String value) {
    setState(() {
      oneToFiveHabitacionesValue = value;
    });
  }

  oneToFiveBanos(String value) {
    setState(() {
      oneToFiveBanosValue = value;
    });
  }
  
  oneToFiveGarajes(String value) {
    setState(() {
      oneToFiveGarajesValue = value;
    });
  }

  oneToFiveEstrato(String value) {
    setState(() {
      oneToFiveEstratoValue = value;
    });
  }

  oneToFiveAcabados(String value) {
    setState(() {
      oneToFiveAcabadosValue = value;
    });
  }

  oneToFiveRuido(String value) {
    setState(() {
      oneToFiveRuidoValue = value;
    });
  }

  oneToFiveIluminacion(String value) {
    setState(() {
      oneToFiveIluminacionValue = value;
    });
  }

  oneToFiveVentilacion(String value) {
    setState(() {
      oneToFiveVentilacionValue = value;
    });
  }

  tipoDePisoChanged(String value) {
    setState(() {
      _tipoDePiso = value;
    });
  }

  puntoDeContactoChanged(String value) {
    setState(() {
      _puntoDeContacto = value;
    });
  }

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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tipo de propiedad:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: _selectedKindOfProperty,
                    items: _dropdownMenuItems,
                    onChanged: _onChangeKindOfPropertyMenu,
                  )
                ],
              ),
            ),
            (_selectedKindOfProperty == 'Apartamento') ?
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0, top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tipo de apartamento:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: _tipoDeApartamento,
                    items: _tipoDeApartamentoMenuItems,
                    onChanged: _onChangeTipoDeApartamentoMenu,
                  )
                ],
              ),
            ): 
            Container(),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Tipo de piso:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: _tipoDePiso,
                    items: _tipoDePisoMenuItems,
                    onChanged: tipoDePisoChanged,
                  )
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Número de habitaciones:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: oneToFiveHabitacionesValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveHabitaciones,
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
                    'Comentarios:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioHabitacionesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Número de baños:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: oneToFiveBanosValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveBanos,
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
                    'Comentarios:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioBanosController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
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
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Garajes:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: oneToFiveGarajesValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveGarajes,
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
                    'Comentarios:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Estrato:',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: oneToFiveEstratoValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveEstrato,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                  'Añadidos',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Chimenea',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Balcón',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.balcon),
                    onChanged: (newValue){
                      setState(() {
                        balcon = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Terraza',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.terraza),
                    onChanged: (newValue){
                      setState(() {
                        terraza = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Cocina Integral',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.cocinaIntegral),
                    onChanged: (newValue){
                      setState(() {
                        cocinaIntegral = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Cocina Americana',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.cocinaAmericana),
                    onChanged: (newValue){
                      setState(() {
                        cocinaAmericana = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Depósito',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.deposito),
                    onChanged: (newValue){
                      setState(() {
                        deposito = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Silencioso',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.silencioso),
                    onChanged: (newValue){
                      setState(() {
                        silencioso = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Iluminado',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.iluminado),
                    onChanged: (newValue){
                      setState(() {
                        iluminado = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 18.0, right: 18.0, top: 40.0),
                child: Text(
                  'Características de edificio y zona',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Seguridad Privada 24 horas',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Piscina',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Gimnasio',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Zona BBQ',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Sala de cine',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Sala de juntas',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Parque infantil',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Parqueadero visitantes',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Planta eléctrica',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
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
                  'Características de edificio y zona',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Parques cercanos',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Vías de acceso cercanas',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 18.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(width: 25,),
                  Text(
                    'Transporte público cercano',
                  ),
                  SizedBox(width: 25,),
                  Switch(
                    value: (this.chimenea),
                    onChanged: (newValue){
                      setState(() {
                        chimenea = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 43.0, right: 43.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Comentarios:',
                  ),
                  SizedBox(width: 15.0,),
                  Expanded(
                    child: TextField(
                      controller: _comentarioGarajesController,      
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
                  DropdownButton(
                    value: oneToFiveAcabadosValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveAcabados,
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
                  DropdownButton(
                    value: oneToFiveRuidoValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveRuido,
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
                  DropdownButton(
                    value: oneToFiveIluminacionValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveIluminacion,
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
                  DropdownButton(
                    value: oneToFiveVentilacionValue,
                    items: _oneToFiveMenuItems,
                    onChanged: oneToFiveVentilacion,
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
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, right: 18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Punto de contacto:',
                  ),
                  SizedBox(width: 15.0,),
                  DropdownButton(
                    value: _puntoDeContacto,
                    items: _puntoDeContactoMenuItems,
                    onChanged: puntoDeContactoChanged,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    'Comparte comisión:'
                  ),
                  Spacer(),
                  Switch(
                    value: (this._abiertoContratoMandato),
                    onChanged: (newValue){
                      setState(() {
                        _abiertoContratoMandato = newValue;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                    inactiveTrackColor: Colors.red,
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

  String avoidNullValue(value) {

    if(value == null)
      return '';
    else
      return value.toString();
  }

  @override
  void initState() {
    super.initState();
    _isButtonEnabled = true;

    _kindOfPropertyTypes = <String> [
      'Apartamento',
      'Casa',
      'Loft'
    ];

    _tipoDeApartamentoTypes = <String> [
      'Interior',
      'Exterior',
    ];

    _tipoDePisoTypes = <String> [
      'Madera',
      'Cerámica',
      'Alfombra'
    ];

    _puntoDeContactoTypes = <String> [
      'Inmobiliarias',
      'Directo',
      'Broker'
    ];

    _oneToFiveTypes = <String> [
      '1',
      '2',
      '3',
      '4',
      '5'
    ];

    _dropdownMenuItems = buildDropdownMenuItems(_kindOfPropertyTypes);
    _oneToFiveMenuItems = buildDropdownMenuItems(_oneToFiveTypes);
    _tipoDeApartamentoMenuItems = buildDropdownMenuItems(_tipoDeApartamentoTypes);
    _tipoDePisoMenuItems = buildDropdownMenuItems(_tipoDePisoTypes);
    _puntoDeContactoMenuItems = buildDropdownMenuItems(_puntoDeContactoTypes);
    _selectedKindOfProperty = _dropdownMenuItems[0].value;
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

    if(modifyPropertiesService==null){


      _petsController = false;
      _remakedController = false;
      _arriendoAmoblado = false;
      _abiertoContratoMandato = false;
      _available = 'disponible';
      _visited = false;

      modifyPropertiesService  = Provider.of<ModifyPropertiesService>(context);
      property = modifyPropertiesService.property;
      _addressController.text = property.address; 
      _contactNumberController.text = property.contactNumber;
      _descriptionController.text = property.description;

      _kindOfPropertyController.text = avoidNullValue(property.kindOfProperty);
      _numberOfBathsController.text = avoidNullValue(property.numberOfBaths);
      _numberOfRoomsController.text = avoidNullValue(property.numberOfRooms);
      _sizeController.text = avoidNullValue(property.size);
      _yearsOldController.text = avoidNullValue(property.yearsOld);
      _numberOfParkingController.text = avoidNullValue(property.numberOfParking);
      _stratumController.text = avoidNullValue(property.stratum);

      if(property.pets != null)
        _petsController = property.pets;
      if(property.remaked != null)
      _remakedController = property.remaked;

      _acabadosController.text = avoidNullValue(property.acabados);
      _ruidoController.text = avoidNullValue(property.ruido);
      _iluminacionController.text = avoidNullValue(property.iluminacion);
      _ventilacionController.text = avoidNullValue(property.ventilacion);
      _fallasController.text = avoidNullValue(property.fallas);
      
      _nombrePropietarioController.text = avoidNullValue(property.nombrePropietario);
      _numeroController.text = avoidNullValue(property.numeroPropietario);
      _precioArriendoController.text = avoidNullValue(property.precioArriendoEsperado);
      if(property.arriendoAmoblado != null)
        _arriendoAmoblado = property.arriendoAmoblado;
      _costoAdministracionController.text = avoidNullValue(property.costoAdministracion);

      if(property.abiertoContratoMandato != null)
        _abiertoContratoMandato = property.abiertoContratoMandato;

      _available = avoidNullValue(property.currentState);

      if(property.visited != null)
        _visited = property.visited;
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