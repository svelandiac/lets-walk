import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/locations.dart';
import 'package:lets_walk/src/models/type_of_user.dart';
import 'package:lets_walk/src/services/saved_markers_service.dart';
import 'package:lets_walk/src/ui/callbacks/callback_container.dart';
import 'package:lets_walk/src/ui/see-all-properties/list_page.dart';
import 'package:provider/provider.dart';
import 'package:lets_walk/src/ui/see-all-properties/map_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class User03MainScreen extends StatefulWidget{
 
  @override
  _User03MainScreenState createState() => _User03MainScreenState();
}

class _User03MainScreenState extends State<User03MainScreen> {

  static int _selectedIndex = 0;

  static PageController _pageController;
  static CallbackContainer callbackContainer = CallbackContainer();

  SavedMarkersService markersService;

  TypeOfUser typeOfUser;

  static Map mapWidget = Map(callbackContainer: callbackContainer,);
  static ListPage listWidget;

  List<Widget> _widgetOptions;
  Locations locations;

  Future<void> changeUser(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user', value);
    typeOfUser.value = value;
    return;
  }

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

    typeOfUser = Provider.of<TypeOfUser>(context);

    if(locations == null && markersService == null){
      locations = Provider.of<Locations>(context);
      locations.changeToList = changeToList;
      markersService = SavedMarkersService(context);
      markersService.startQuery();
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar los inmuebles'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.power_settings_new,
              color: Colors.white,
            ),
            onPressed: () {
              changeUser(null);
            },
          )
        ],
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

