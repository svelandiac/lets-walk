import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin<ListPage> {
  Locations locations;
  ModifyPropertiesService modifyPropertiesService;

  TextEditingController _searchController = TextEditingController();

  static String address = 'Dirección';
  static String state = 'Estado';
  static String description = 'Descripción';
  static String position = 'Posición';

  static String sortBy = 'Ordenar por';
  static String filterBy= 'Filtrar por';

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

  void choiceSortAction(String choice){
    if(choice == address)
      locations.sortBy(SortOption.address);

    if(choice == state)
      locations.sortBy(SortOption.state);

    if(choice == description)
      locations.sortBy(SortOption.description);

    if(choice == position)
      locations.sortBy(SortOption.position);
  }

  void choiceFilterOption(){
    
  }
  
  Widget _build() {

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
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + address),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        choiceSortAction(address);
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + state),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        choiceSortAction(state);                        
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + description),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        choiceSortAction(description);                        
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + position),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        choiceSortAction(position);                        
                        Navigator.of(context).pop();
                      },
                    ),
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
              height: 168,
              child: Column(
                children: <Widget>[
                  Text('¿Cómo deseas filtrar los inmuebles?'),
                  SizedBox(height: 30.0,),
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + state),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Container(
                    width: 200,
                    child: OutlineButton(
                      child: Text('Por ' + position),
                      shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                      borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                      highlightedBorderColor: Colors.black,
                      onPressed: (){
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      );
    }

    void choiceMenuAction(String choice){
      if(choice == sortBy)
        _showSortOptions();
      if(choice == filterBy)
        _showFilterOptions();
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
                ),
              ),
              PopupMenuButton<String> (
                //icon: Icon(Icons.sort),
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
        Expanded(
          child: ListView.builder(
            itemCount: locations.properties.length,
            itemBuilder: (context, index) => _buildItem(context, index)),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    locations = Provider.of<Locations>(context);
    modifyPropertiesService = Provider.of<ModifyPropertiesService>(context);
    return _build();
  }

  Widget _buildItem(context, index) {
    var item = locations.properties.elementAt(index);

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
                  OutlineButton(
                    child: Text('Ver en mapa'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Colors.black, style: BorderStyle.solid),
                    highlightedBorderColor: Colors.black,
                    onPressed: () {},
                  ),
                  OutlineButton(
                    child: Text('Editar detalles'),
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(
                        color: Colors.black, style: BorderStyle.solid),
                    highlightedBorderColor: Colors.black,
                    onPressed: () {
                      Navigator.pushNamed(context, '/EditPropertyScreen');
                    },
                  ),
                ],
              ),
            )
          ],
        ));
  }

  @override
  bool get wantKeepAlive => true;
}
