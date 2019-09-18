import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:lets_walk/src/ui/callbacks/callback_container.dart';
import 'package:lets_walk/src/ui/see-all-properties/list_page.dart';
import 'package:provider/provider.dart';
import 'map_page.dart';

class SeePropertiesScreen extends StatefulWidget{
 
  @override
  _SeePropertiesScreenState createState() => _SeePropertiesScreenState();
}

class _SeePropertiesScreenState extends State<SeePropertiesScreen> {

  static int _selectedIndex = 0;

  static PageController _pageController;
  static CallbackContainer callbackContainer = CallbackContainer();

  SavedMarkersService markersService;

  static Map mapWidget = Map(callbackContainer: callbackContainer,);
  static ListPage listWidget;

  List<Widget> _widgetOptions;
  Locations locations;

  void animateToSpecificPointInMap(GeoPoint point){

    setState(() {
      _selectedIndex = 1;
      _pageController.animateToPage(1,
      duration: Duration(milliseconds: 300), curve: Curves.ease);
      callbackContainer.callbackObject.callBackFunction(point);

    });
  }

  Future<void> changeToList() async {
    setState(() {
      _selectedIndex = 0;
      _pageController.animateToPage(0,
      duration: Duration(milliseconds: 300), curve: Curves.ease);
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = 0;
    _pageController = PageController(initialPage: 0);
    listWidget = ListPage(this.animateToSpecificPointInMap);
    _widgetOptions = <Widget>[
      listWidget,
      mapWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {

    print(_selectedIndex);

    if(locations == null && markersService == null){
      locations = Provider.of<Locations>(context);
      locations.changeToList = changeToList;
      markersService = SavedMarkersService(context);
      markersService.startQuery();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver los inmuebles añadidos'),
        centerTitle: true,
      ),
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.list, color: Colors.white,),
            title: Text('Ver en lista', style: TextStyle(color: Colors.white),),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map, color: Colors.white,),
            title: Text('Ver en mapa', style: TextStyle(color: Colors.white),),
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: (index){
          setState(() {
            _selectedIndex = index;
            _pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.ease);
          });
        },
      )
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

