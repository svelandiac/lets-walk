import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/type_of_user.dart';
import 'package:lets_walk/src/ui/common-widgets/rounded_outlined_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectUserScreen extends StatefulWidget {
  @override
  _SelectUserScreenState createState() => _SelectUserScreenState();
}

class _SelectUserScreenState extends State<SelectUserScreen> {

  TypeOfUser typeOfUser;

  Future<void> changeUser(int value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('user', value);
    typeOfUser.value = value;
    return;
  }

  @override
  Widget build(BuildContext context) {

    typeOfUser = Provider.of<TypeOfUser>(context);
    
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Selecciona el usuario para continuar'
            ),
            SizedBox(height:40 ,),
            RoundedOutlinedButton(
              text: 'Usuario 01',
              onPressed: () {
                changeUser(1);
              },
            ),
            RoundedOutlinedButton(
              text: 'Usuario 02',
              onPressed: () {
                changeUser(2);
              },
            ),
            RoundedOutlinedButton(
              text: 'Usuario 03',
              onPressed: () {
                changeUser(3);
              },
            )
          ],
        ),
      ),
    );
  }
}