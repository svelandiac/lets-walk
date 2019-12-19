import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:lets_walk/src/ui/callbacks/callback_object.dart';
import 'package:lets_walk/src/ui/common-widgets/color_rounded_button.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  final Function(GeoPoint) animateToSpecificPoint;

  ListPage(this.animateToSpecificPoint);

  @override
  _ListPageState createState() => _ListPageState();
}

enum ContactOptions { noContacted, contacted, busy, available, lost }

class _ListPageState extends State<ListPage>
    with AutomaticKeepAliveClientMixin<ListPage> {
  //Variables declaration

  Locations locations;
  ModifyPropertiesService modifyPropertiesService;

  Geoflutterfire geo = Geoflutterfire();

  TextEditingController _searchController = TextEditingController();
  TextEditingController _distanceNearbyPropertiesController = TextEditingController();

  CallbackObject callbackObject;

  static String address = 'Dirección';
  static String state = 'Estado';
  static String description = 'Descripción';
  static String position = 'Posición';

  static String sortBy = 'Ordenar por';
  static String filterBy = 'Filtrar por';
  static String deleteFilters = 'Eliminar filtros';

  Map<ContactOptions, bool> _filterByStateOptions = {
    ContactOptions.available: false,
    ContactOptions.busy: false,
    ContactOptions.contacted: false,
    ContactOptions.lost: false,
    ContactOptions.noContacted: false
  };

  List<Property> propertiesToShow;

  bool _loadingSearchProperties;
  bool _searchByAddress;

  List<String> menuOptions = <String>[sortBy, filterBy, deleteFilters];

  List<String> sortOptions = <String>[
    address,
    state,
    description,
  ];

  bool _inputError = false;
  int _distance = 500;

  //Show dialogs

  void _showNearbyPropertiesOptions(Property _propertyToCompare){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Text('Buscar inmuebles cercanos'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('A continuación indique la distancia (en metros) a la que quiere encontrar inmuebles a la redonda:'),
                  SizedBox(height: 15.0,),
                  (_inputError) ? 
                  Text(
                    'Por favor, digite sólo el número de metros a la redonda',
                    style: TextStyle(
                      color: Colors.red
                    ),
                  ) : Container(),
                  TextField(
                    controller: _distanceNearbyPropertiesController,
                    decoration: InputDecoration(hintText: '500'),
                  ),
                  SizedBox(height: 15.0,),
                  Center(
                    child: RoundedOutlinedButton(
                      text: 'Buscar',
                      onPressed: () {
                        setState(() {
                          try{
                            _inputError = false;
                            if(_distanceNearbyPropertiesController.text.length > 0){
                              _distance = int.parse(_distanceNearbyPropertiesController.text);
                            }
                            print('Looking for properties $_distance meters nearby');
                            filterByNearbyProperties(_propertyToCompare);
                            Navigator.of(context).pop();
                          } catch (e) {
                            _inputError = true;
                          }
                        });
                      },
                    ),
                  )
                ],
              ),
            );
          },
        );
      }
    );
  }

  void _showFilterByPosition() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Filtrar por posición'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                    'Siga los siguiente pasos:\n\n1. Seleccione un inmueble.\n2. Presione el botón "Ver en mapa"\n3. Ajuste el radio de búsqueda.\n4. Vuelva a la lista.\n\nYa verá los inmuebles dentro de ese círculo.'),
                Center(
                  child: RoundedOutlinedButton(
                    text: 'Entendido',
                    width: 200,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  void _showFilterByStateOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: Text('Filtrar por estado'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text('¿Qué estados te gustaría seleccionar?'),
                    SizedBox(
                      height: 15.0,
                    ),
                    ColorRoundedButton(
                      color: (_filterByStateOptions[ContactOptions.contacted])
                          ? Colors.green[200]
                          : Colors.grey[100],
                      text: 'Contactado',
                      onPressed: () {
                        setState(() {
                          _filterByStateOptions[ContactOptions.contacted] =
                              !_filterByStateOptions[ContactOptions.contacted];
                        });
                      },
                    ),
                    ColorRoundedButton(
                      color: (_filterByStateOptions[ContactOptions.noContacted])
                          ? Colors.red[200]
                          : Colors.grey[100],
                      text: 'No contactado',
                      onPressed: () {
                        setState(() {
                          _filterByStateOptions[ContactOptions.noContacted] =
                              !_filterByStateOptions[
                                  ContactOptions.noContacted];
                        });
                      },
                    ),
                    ColorRoundedButton(
                      color: (_filterByStateOptions[ContactOptions.busy])
                          ? Colors.yellow[200]
                          : Colors.grey[100],
                      text: 'Ocupado',
                      onPressed: () {
                        setState(() {
                          _filterByStateOptions[ContactOptions.busy] =
                              !_filterByStateOptions[ContactOptions.busy];
                        });
                      },
                    ),
                    ColorRoundedButton(
                      color: (_filterByStateOptions[ContactOptions.available])
                          ? Colors.blue[200]
                          : Colors.grey[100],
                      text: 'Disponible',
                      onPressed: () {
                        setState(() {
                          _filterByStateOptions[ContactOptions.available] =
                              !_filterByStateOptions[ContactOptions.available];
                        });
                      },
                    ),
                    ColorRoundedButton(
                      color: (_filterByStateOptions[ContactOptions.lost])
                          ? Colors.black26
                          : Colors.grey[100],
                      text: 'Perdido',
                      onPressed: () {
                        setState(() {
                          _filterByStateOptions[ContactOptions.lost] =
                              !_filterByStateOptions[ContactOptions.lost];
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    RoundedOutlinedButton(
                      text: 'Filtrar',
                      width: 200,
                      onPressed: () {
                        filterProperties();
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        });
  }

  void _showSortOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Ordenar por'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('¿Cómo deseas ordenar los inmuebles?'),
                SizedBox(
                  height: 30.0,
                ),
                RoundedOutlinedButton(
                  text: 'Por $address',
                  width: 200,
                  onPressed: () {
                    choiceSortAction(address);
                    Navigator.of(context).pop();
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $state',
                  width: 200,
                  onPressed: () {
                    choiceSortAction(state);
                    Navigator.of(context).pop();
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $description',
                  width: 200,
                  onPressed: () {
                    choiceSortAction(description);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  void _showFilterOptions() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Filtrar por',
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('¿Cómo deseas filtrar los inmuebles?'),
                SizedBox(
                  height: 30.0,
                ),
                RoundedOutlinedButton(
                  text: 'Por $state',
                  width: 200,
                  onPressed: () {
                    Navigator.of(context).pop();
                    choiceFilterOption(state);
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $position',
                  width: 200,
                  onPressed: () {
                    Navigator.of(context).pop();
                    choiceFilterOption(position);
                  },
                ),
              ],
            ),
          );
        });
  }

  //Choices

  void choiceSortAction(String choice) {
    setState(() {
      if (choice == address) {
        propertiesToShow.sort((a, b) {
          return a.address
              .toLowerCase()
              .trim()
              .compareTo(b.address.toLowerCase().trim());
        });
      }

      if (choice == description) {
        propertiesToShow.sort((a, b) {
          return a.description
              .toLowerCase()
              .trim()
              .compareTo(b.description.toLowerCase().trim());
        });
      }

      if (choice == state) {
        propertiesToShow.sort((a, b) {
          return a.isContacted.compareTo(b.isContacted);
        });
      }
    });
  }

  void choiceFilterOption(String choice) {
    if (choice == state) {
      _showFilterByStateOptions();
    }
    if (choice == position) {
      _showFilterByPosition();
    }
  }

  void choiceMenuAction(String choice) {
    if (choice == sortBy) _showSortOptions();
    if (choice == filterBy) _showFilterOptions();
    if (choice == deleteFilters) {
      _searchController.text = '';
      updateList();
      _filterByStateOptions = {
        ContactOptions.available: false,
        ContactOptions.busy: false,
        ContactOptions.contacted: false,
        ContactOptions.lost: false,
        ContactOptions.noContacted: false
      };
    }
  }

  //Methods that modify propertiesToShow list

  Future filterProperties() async {
    setState(() {
      propertiesToShow.forEach((Property _property) {
        _property.show = false;

        if (_filterByStateOptions[ContactOptions.contacted]) {
          if (_property.isContacted == 'contacted') _property.show = true;
        }

        if (_filterByStateOptions[ContactOptions.noContacted]) {
          if (_property.isContacted == 'noContacted') _property.show = true;
        }

        if (_filterByStateOptions[ContactOptions.busy]) {
          if (_property.isContacted == 'busy') _property.show = true;
        }

        if (_filterByStateOptions[ContactOptions.available]) {
          if (_property.isContacted == 'available') _property.show = true;
        }

        if (_filterByStateOptions[ContactOptions.lost]) {
          if (_property.isContacted == 'lost') _property.show = true;
        }
      });
    });
  }

  Future filterByNearbyProperties(Property _centerProperty) async {
    setState(() {

      updateList();

      var maximum = 0.0;

      propertiesToShow.forEach((Property _property) {
        _property.show = false;

        var firstPoint = geo.point(latitude: _centerProperty.location.latitude, longitude: _centerProperty.location.longitude);
        var secondPoint = geo.point(latitude: _property.location.latitude, longitude: _property.location.longitude);

        var distance = firstPoint.distance(lat: secondPoint.coords.latitude, lng: secondPoint.coords.longitude);

        if(distance > maximum)
          maximum = distance;

        print(distance.toString() + ' / ' + (_distance/1000).toString());

        if(distance < (_distance/1000)) {
          _property.show = true;
        }
      }); 
    });
  }

  void updateList() {
    setState(() {
      propertiesToShow.forEach((Property _property) {
        _property.show = true;
      });
    });
  }

  Future searchProperty(String searchText) async {
    setState(() {
      if (searchText.length > 0) {
        updateList();
        propertiesToShow.forEach((Property _property) {
          if (_property.show) {
            if (_property.address
                .toLowerCase()
                .trim()
                .startsWith(searchText.toLowerCase().trim())) {
              _property.show = true;
            } else {
              _property.show = false;
            }
          }
        });
      } else {
        updateList();
      }
    });
  }

  Future searchNeighborhood(String neighborhood) async {
    
  }

  void searchASpecificProperty(String text) {
    _searchController.text = text;
    _searchByAddress = true;
    searchProperty(text);
  }

  int getItemCount(List<Property> _list) {
    int _itemCount = 0;
    _list.forEach((Property _property) {
      if (_property.show) _itemCount++;
    });
    return _itemCount;
  }

  Widget _build() {
    int realIndex(int fakeIndex) {
      int counter = -1;
      int realIndex = 0;
      for (int i = 0; i < propertiesToShow.length; i++) {
        if (propertiesToShow.elementAt(i).show) {
          counter++;
          realIndex = i;
        }
        if (counter == fakeIndex) break;
      }
      return realIndex;
    }

    Widget _buildItem(context, index, List<Property> propertiesList) {
      index = realIndex(index);

      var item = propertiesList.elementAt(index);

      Widget isContacted() {
        Widget result;

        switch (item.isContacted) {
          case 'noContacted':
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.red),
            );
            break;
          case 'contacted':
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            );
            break;
          case 'busy':
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.yellow),
            );
            break;
          case 'available':
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            );
            break;
          case 'lost':
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            );
            break;
          default:
            result = Container(
              width: 15.0,
              height: 15.0,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black),
            );
            break;
        }

        return result;
      }

      return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpansionTile(
            title: Row(
              children: <Widget>[
                Text(item.address, style: TextStyle(fontSize: 20.0)),
                Spacer(),
                isContacted()
              ],
            ),
            onExpansionChanged: (expanded) {
              if (expanded) modifyPropertiesService.property = item;
            },
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Número de contacto: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.5),
                    ),
                    Flexible(
                      child: Text(
                        item.contactNumber,
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Estado: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Flexible(
                      child: (item.isContacted == 'noContacted')
                          ? Text(
                              'No contactado',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Contactado',
                              style: TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      'Fotos: ',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.5),
                    ),
                    Flexible(
                      child: Text(
                        (item.photos.length == 1)
                            ? '${item.photos.length} imagen'
                            : '${item.photos.length} imágenes',
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                height: 300.0,
                child: (item.photos.isNotEmpty)
                    ? Padding(
                        padding: EdgeInsets.all(8.0),
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/Silver-Balls-Swinging.gif',
                          image: item.photos.first,
                        ),
                      )
                    : Container(),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    RoundedOutlinedButton(
                      text: 'Ver en mapa',
                      width: 140,
                      onPressed: () {
                        GeoPoint point = item.location;
                        this.widget.animateToSpecificPoint(point);
                      },
                    ),
                    RoundedOutlinedButton(
                      text: 'Editar detalles',
                      width: 140,
                      onPressed: () {
                        Navigator.pushNamed(context, '/EditPropertyScreen');
                      },
                    ),
                  ],
                ),
              ),
              Center(
                child: RoundedOutlinedButton(
                  text: 'Encontrar inmuebles cercanos',
                  width: 260,
                  onPressed: () {
                    _showNearbyPropertiesOptions(item);
                  },
                ),
              ),
              SizedBox(height: 10.0,)
            ],
          ));
    }

    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 10.0, left: 20.0),
          child: Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: 'Busca una propiedad'),
                  onChanged: (text) {
                    setState(() {
                      _loadingSearchProperties = true;
                    });
                    if(_searchByAddress){
                      searchProperty(text).then((onValue) {
                        setState(() {
                          _loadingSearchProperties = false;
                        });
                      });
                    } else {
                      searchNeighborhood(text).then((onValue){
                        setState(() {
                          _loadingSearchProperties = false; 
                        });
                      });
                    }                    
                  },
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (choice) {
                  choiceMenuAction(choice);
                },
                itemBuilder: (BuildContext context) {
                  return menuOptions.map((String choice) {
                    return PopupMenuItem(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              )
            ],
          ),
        ),
        SizedBox(height: 10.0,),
        
        SizedBox(
          height: 10.0,
        ),
        Center(
            child: Text(
                'Se están mostrando ${getItemCount(propertiesToShow)} elementos')),
        SizedBox(
          height: 10.0,
        ),
        Expanded(
          child: _loadingSearchProperties
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ListView.builder(
                  itemCount: getItemCount(propertiesToShow),
                  itemBuilder: (context, index) =>
                      _buildItem(context, index, propertiesToShow)),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingSearchProperties = false;
    _searchByAddress = true;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    if (locations == null &&
        modifyPropertiesService == null &&
        callbackObject == null) {
      locations = Provider.of<Locations>(context);
      callbackObject =
          CallbackObject(callBackFunction: this.searchASpecificProperty);
      modifyPropertiesService = Provider.of<ModifyPropertiesService>(context);
      locations.callbackContainer.callbackObject = callbackObject;
    }

    if (propertiesToShow == null) propertiesToShow = locations.properties;

    if (propertiesToShow.length == 0)
      _loadingSearchProperties = true;
    else
      _loadingSearchProperties = false;
    return _build();
  }

  @override
  bool get wantKeepAlive => true;
}
