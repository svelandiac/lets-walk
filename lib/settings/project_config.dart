import 'package:lets_walk/src/ui/add-new-estate/new_estate_screen.dart';
import 'package:lets_walk/src/ui/login_screen.dart';
import 'package:lets_walk/src/ui/main_screen.dart';
import 'package:lets_walk/src/ui/see-all-properties/see_properties_screen.dart';

final routes = {
  "/LoginScreen": (context) => LoginScreen(),
  "/MainScreen": (context) => MainScreen(),
  "/NewEstateScreen": (context) => NewEstateScreen(),
  "/SeePropertiesScreen": (context) => SeePropertiesScreen()

};
