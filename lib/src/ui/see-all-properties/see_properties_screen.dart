import 'package:flutter/material.dart';

class SeePropertiesScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ver todos los inmuebles'),
        centerTitle: true,
      ),
      body: Center(
        child: Text('See properties screen'),
      ),
    );
  }

}