import 'package:flutter/material.dart';
import 'package:lets_walk/src/models/user.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    final userInfo = Provider.of<User>(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Text('User email: ${userInfo.email}'),
            ],
          ),
        ),
      ),
    );
  }

}

