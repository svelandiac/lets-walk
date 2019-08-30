import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/services/modify_properties_service.dart';
import 'package:provider/provider.dart';

class ListPage extends StatefulWidget {

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> with AutomaticKeepAliveClientMixin<ListPage>{

  Locations locations;
  ModifyPropertiesService modifyPropertiesService;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    locations = Provider.of<Locations>(context);
    modifyPropertiesService = Provider.of<ModifyPropertiesService>(context);
    return ListView.builder(
      itemCount: locations.properties.length,
      itemBuilder: (context, index) => _buildItem(context, index)
    );
  }

  Widget _buildItem(context, index){

    var item = locations.properties.elementAt(index);

    Widget isContacted(){
      Widget result;

      switch (item.isContacted) {
        case 'noContacted':
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.red
            ),
          );
          break;
        case 'contacted':
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green
            ),
          );
          break;
        case 'busy':
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow
            ),
          );
          break;
        case 'available':
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue
            ),
          );
          break;
        case 'lost':
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
            ),
          );
          break;
        default:
          result = Container(
            width: 15.0,
            height: 15.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black
            ),
          );
          break;
      }

      return result;

    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ExpansionTile(
          title: Row(
            children: <Widget>[
              Text(
                item.address,
                style: TextStyle(
                  fontSize: 20.0
                )
              ),
              Spacer(),
              isContacted()
            ],
          ), 
          onExpansionChanged: (expanded){
            if(expanded)
              modifyPropertiesService.property = item;
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.description,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5
                    ),
                  ),
                  Flexible(
                    child: Text(
                      item.contactNumber,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0
                    ),
                  ),
                  Flexible(
                    child: (item.isContacted == 'noContacted') ? Text(
                      'No contactado',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.red, 
                        fontWeight: FontWeight.bold
                      ),
                    ) : 
                    Text(
                      'Contactado',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.green, 
                        fontWeight: FontWeight.bold
                      ),
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
                      fontWeight: FontWeight.bold,
                      fontSize: 16.5
                    ),
                  ),
                  Flexible(
                    child: Text(
                      (item.photos.length == 1) ? 
                      '${item.photos.length} imagen': 
                      '${item.photos.length} imágenes'
                      ,
                      style: TextStyle(
                        fontSize: 16.0
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  )
                ],
              ),
            ),
            (item.photos.isNotEmpty) ?
            Padding(
              padding: EdgeInsets.all(8.0),
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/Silver-Balls-Swinging.gif',
                image: item.photos.first,
              ),
            ) :
            Container(),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  OutlineButton(
                    child: Text('Ver en mapa'),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                    highlightedBorderColor: Colors.black,
                    onPressed: (){

                    },
                  ),
                  OutlineButton(
                    child: Text('Editar detalles'),
                    shape: RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.black, style: BorderStyle.solid),
                    highlightedBorderColor: Colors.black,
                    onPressed: (){
                      Navigator.pushNamed(context, '/EditPropertyScreen');
                    },
                  ),
                ],
              ),
            )
          ],
        )
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

