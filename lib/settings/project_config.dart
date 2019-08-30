import 'package:lets_walk/src/ui/add-new-property/new_property_screen.dart';
import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/main_screen.dart';
import 'package:lets_walk/src/ui/see-all-properties/edit_property_screen.dart';
import 'package:lets_walk/src/ui/see-all-properties/see_properties_screen.dart';

final routes = {
  "/LoginScreen": (context) => LoginScreen(),
  "/MainScreen": (context) => MainScreen(),
  "/NewPropertyScreen": (context) => NewPropertyScreen(),
  "/SeePropertiesScreen": (context) => SeePropertiesScreen(),
  "/EditPropertyScreen": (context) => EditPropertyScreen(),
};
