import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/ui/see-all-properties/list_page.dart';
import 'map_page.dart';

class SeePropertiesScreen extends StatefulWidget{
 
  @override
  _SeePropertiesScreenState createState() => _SeePropertiesScreenState();
}

class _SeePropertiesScreenState extends State<SeePropertiesScreen> {

  int _selectedIndex = 0;

  PageController _pageController;

  static Map mapWidget = Map();
  static ListPage listWidget = ListPage();

  List<Widget> _widgetOptions = <Widget>[
    mapWidget,
    listWidget
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir un nuevo inmueble'),
        centerTitle: true,
      ),
      body: PageView(
        physics:new NeverScrollableScrollPhysics(),
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
          )
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

