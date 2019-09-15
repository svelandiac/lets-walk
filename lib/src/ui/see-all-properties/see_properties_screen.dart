import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/ui/callbacks/callback_container.dart';
import 'package:lets_walk/src/ui/see-all-properties/list_page.dart';
import 'map_page.dart';

class SeePropertiesScreen extends StatefulWidget{
 
  @override
  _SeePropertiesScreenState createState() => _SeePropertiesScreenState();
}

class _SeePropertiesScreenState extends State<SeePropertiesScreen> {

  static int _selectedIndex = 0;

  static PageController _pageController;
  static CallbackContainer callbackContainer = CallbackContainer();

  static Map mapWidget = Map(callbackContainer: callbackContainer,);
  static ListPage listWidget;

  List<Widget> _widgetOptions;

  void animateToSpecificPointInMap(GeoPoint point){

    setState(() {
      _selectedIndex = 0;
      _pageController.animateToPage(0,
      duration: Duration(milliseconds: 300), curve: Curves.ease);
      callbackContainer.callbackObject.callBackFunction(point);

    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    listWidget = ListPage(this.animateToSpecificPointInMap);
    _widgetOptions = <Widget>[
      mapWidget,
      listWidget,
    ];
  }

  @override
  Widget build(BuildContext context) {

    
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
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Ver en mapa'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            title: Text('Ver en lista'),
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
}

