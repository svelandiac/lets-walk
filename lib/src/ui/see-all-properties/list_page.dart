import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/property.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:lets_walk/src/ui/common-widgets/color_rounded_button.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

enum ContactOptions {
  noContacted,
  contacted,
  busy,
  available,
  lost
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin<ListPage> {
  
  //Variables declaration

  Locations locations; 
  ModifyPropertiesService modifyPropertiesService;

  TextEditingController _searchController = TextEditingController();

  static String address = 'Dirección';
  static String state = 'Estado';
  static String description = 'Descripción';
  static String position = 'Posición';

  static String sortBy = 'Ordenar por';
  static String filterBy= 'Filtrar por';

  Map<ContactOptions, bool> _filterByStateOptions = {
    ContactOptions.available : false,
    ContactOptions.busy : false,
    ContactOptions.contacted : false,
    ContactOptions.lost : false,
    ContactOptions.noContacted : false
  };

  List<Property> propertiesToShow;

  bool _loadingSearchProperties;

  List<String> menuOptions = <String>[
    sortBy,
    filterBy
  ];
  
  List<String> sortOptions = <String>[
    address,
    state,
    description,
    position
  ];

  //Show dialogs

  void _showFilterByStateOptions(){

    showDialog(
      context: context,
      builder: (BuildContext context){
        return StatefulBuilder(
          builder: (context, setState){
            return AlertDialog(
              title: Text(
                'Filtrar por estado'
              ),
              content: Container(
                  height: 355,
                  child: Column(
                    children: <Widget>[
                      Text(
                        '¿Qué estados te gustaría seleccionar?'
                      ),
                      SizedBox(height: 15.0,),
                      ColorRoundedButton(
                        color: (_filterByStateOptions[ContactOptions.contacted]) ? Colors.green[200] : Colors.grey[100],
                        text: 'Contactado',
                        onPressed: () {
                          setState(() {
                            _filterByStateOptions[ContactOptions.contacted] = !_filterByStateOptions[ContactOptions.contacted]; 
                          });
                        },
                      ),
                      ColorRoundedButton(
                        color: (_filterByStateOptions[ContactOptions.noContacted]) ? Colors.red[200] : Colors.grey[100],
                        text: 'No contactado',
                        onPressed: () {
                          setState(() {
                            _filterByStateOptions[ContactOptions.noContacted] = !_filterByStateOptions[ContactOptions.noContacted]; 
                          });
                        },
                      ),
                      ColorRoundedButton(
                        color: (_filterByStateOptions[ContactOptions.busy]) ? Colors.yellow[200] : Colors.grey[100],
                        text: 'Ocupado',
                        onPressed: () {
                          setState(() {
                            _filterByStateOptions[ContactOptions.busy] = !_filterByStateOptions[ContactOptions.busy]; 
                          });
                        },
                      ),
                      ColorRoundedButton(
                        color: (_filterByStateOptions[ContactOptions.available]) ? Colors.blue[200] : Colors.grey[100],
                        text: 'Disponible',
                        onPressed: () {
                          setState(() {
                            _filterByStateOptions[ContactOptions.available] = !_filterByStateOptions[ContactOptions.available]; 
                          });
                        },
                      ),
                      ColorRoundedButton(
                        color: (_filterByStateOptions[ContactOptions.lost]) ? Colors.black26 : Colors.grey[100],
                        text: 'Perdido',
                        onPressed: () {
                          setState(() {
                            _filterByStateOptions[ContactOptions.lost] = !_filterByStateOptions[ContactOptions.lost]; 
                          });
                        },
                      ),
                      SizedBox(height: 15.0,),
                      RoundedOutlinedButton(
                        text: 'Filtrar',
                        width: 200,
                        onPressed: (){
                          filterProperties();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
            );
          },
        );
      }
    );
  }

  void _showSortOptions(){

    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            'Ordenar por'
          ),
          content: Container(
            height: 245,
            child: Column(
              children: <Widget>[
                Text(
                  '¿Cómo deseas ordenar los inmuebles?'
                ),
                SizedBox(height: 30.0,),
                RoundedOutlinedButton(
                  text: 'Por $address',
                  width: 200,
                  onPressed: (){
                    choiceSortAction(address);
                    Navigator.of(context).pop();
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $state',
                  width: 200,
                  onPressed: (){
                    choiceSortAction(state);                        
                    Navigator.of(context).pop();
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $description',
                  width: 200,
                  onPressed: (){
                    choiceSortAction(description);                       
                    Navigator.of(context).pop();
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $position',
                  width: 200,
                  onPressed: (){
                    choiceSortAction(position);                        
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  void _showFilterOptions(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(
            'Filtrar por',
          ),
          content: Container(
            height: 150,
            child: Column(
              children: <Widget>[
                Text('¿Cómo deseas filtrar los inmuebles?'),
                SizedBox(height: 30.0,),
                RoundedOutlinedButton(
                  text: 'Por $state',
                  width: 200,
                  onPressed: (){
                    Navigator.of(context).pop();
                    choiceFilterOption(state);
                  },
                ),
                RoundedOutlinedButton(
                  text: 'Por $position',
                  width: 200,
                  onPressed: (){
                    choiceFilterOption(position);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  //Choices

  void choiceSortAction(String choice){

    setState(() {

      if(choice == address){
        propertiesToShow.sort(
          (a, b){
            return a.address.toLowerCase().trim().compareTo(b.address.toLowerCase().trim());
          }
        );
      }

      if(choice == description){
        propertiesToShow.sort(
          (a, b){
            return a.description.toLowerCase().trim().compareTo(b.description.toLowerCase().trim());
          }
        );
      }

      if(choice == state){
        propertiesToShow.sort(
          (a, b){
            return a.isContacted.compareTo(b.isContacted);
          }
        );
      }

      if(choice == position){
        propertiesToShow.sort(
          (a, b){
            return a.geohash.compareTo(b.geohash);
          }
        );
      }

    });
    
  }

  void choiceFilterOption(String choice){
    if(choice == state){
      _showFilterByStateOptions();
    }
    if(choice == position){
      print('Filter by position');
    }
  }

  void choiceMenuAction(String choice){
    if(choice == sortBy)
      _showSortOptions();
    if(choice == filterBy)
      _showFilterOptions();
  }

  //Methods that modify propertiesToShow list

  Future filterProperties() async {

    propertiesToShow.clear();

    // setState(() {

    //   locations.properties.forEach((Property propertyFound){
    //     if(_filterByStateOptions[ContactOptions.contacted]){
    //       if(propertyFound.isContacted == 'contacted')
    //         propertiesToShow.add(propertyFound);
    //     }
        
    //     if(_filterByStateOptions[ContactOptions.noContacted]){
    //       if(propertyFound.isContacted == 'noContacted')
    //         propertiesToShow.add(propertyFound);
    //     }
          
    //     if(_filterByStateOptions[ContactOptions.busy]){
    //       if(propertyFound.isContacted == 'busy')
    //         propertiesToShow.add(propertyFound);
    //     }
           
    //     if(_filterByStateOptions[ContactOptions.available]){
    //       if(propertyFound.isContacted == 'available')
    //         propertiesToShow.add(propertyFound);
    //     }
              
    //     if(_filterByStateOptions[ContactOptions.lost]){
    //       if(propertyFound.isContacted == 'lost')
    //         propertiesToShow.add(propertyFound);
    //     }          
        
    //   });
    // });
  }

  Future searchProperty(String searchText) async {

    setState(() {
      if(searchText.length > 0){
        propertiesToShow.forEach((Property _property){
          if(_property.address.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())){
            _property.show = true;
          }
          else{
            _property.show = false;
          }
        });
      }
      else{
        propertiesToShow.forEach((Property _property){
          _property.show = true;
        });
      }
    });

  }

  int getItemCount(List<Property> _list){
    int _itemCount = 0;
    _list.forEach((Property _property){
      if(_property.show)
        _itemCount++;
    });
    return _itemCount;
  }
  
  Widget _build() {

    int realIndex(int fakeIndex){
      int counter = -1;
      int realIndex = 0;
      for(int i = 0 ; i < propertiesToShow.length ; i++){
        if(propertiesToShow.elementAt(i).show){
          counter++;
          realIndex = i;
        }
        if(counter == fakeIndex)
          break;
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Descripción: ',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18.0),
                  ),
                  Flexible(
                    child: Text(
                      item.description,
                      style: TextStyle(fontSize: 16.0),
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
                    onPressed: null,
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
            )
          ],
        )
      );
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
                  decoration: InputDecoration(
                    hintText: 'Busca una propiedad'
                  ),
                  onChanged: (text){
                    setState(() {
                      _loadingSearchProperties = true; 
                    });
                    searchProperty(text).then((onValue){
                      setState(() {
                        _loadingSearchProperties = false;
                      });
                    });
                  },
                ),
              ),
              PopupMenuButton<String> (
                onSelected: (choice){
                  choiceMenuAction(choice);
                },
                itemBuilder: (BuildContext context){
                  return menuOptions.map((String choice){
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
        Center(
          child: Text('Se están mostrando ${getItemCount(propertiesToShow)} elementos')
        ),
        SizedBox(height: 10.0,),
        Expanded(
          child: _loadingSearchProperties ?
            Center(
              child: CircularProgressIndicator(),
            ) :
            ListView.builder(
              itemCount: getItemCount(propertiesToShow),
              itemBuilder: (context, index) => _buildItem(context, index, propertiesToShow)
            ),
        )
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _loadingSearchProperties = false;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    modifyPropertiesService = Provider.of<ModifyPropertiesService>(context);
    locations = Provider.of<Locations>(context);

    if(propertiesToShow == null)
      propertiesToShow = locations.properties;
    return _build();
  }

  @override
  bool get wantKeepAlive => true;
}
