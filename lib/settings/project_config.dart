import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/screens/user-01/add_property_user_01_screen.dart';
import 'package:lets_walk/src/ui/screens/user-02/add_property_user_02_screen.dart';
import 'package:lets_walk/src/ui/screens/user-02/user_02_main_screen.dart';
import 'package:lets_walk/src/ui/see-all-properties/edit_property_screen.dart';
import 'package:lets_walk/src/ui/see-all-properties/see_properties_screen.dart';

final routes = {
  "/LoginScreen": (context) => LoginScreen(),
  "/User02MainScreen": (context) => User02MainScreen(),
  "/User01MainScreen": (context) => AddPropertyUser01Screen(),
  "/SeePropertiesScreen": (context) => SeePropertiesScreen(),
  "/EditPropertyScreen": (context) => EditPropertyScreen(),
  "/AddPropertyUser01Screen" : (context) => AddPropertyUser01Screen(),
  "/AddPropertyUser02Screen" : (context) => AddPropertyUser02Screen()
};
