import 'package:flutter/material.dart';


import '../widgets/drawer.dart';

class About extends StatelessWidget {
  static const routeName = '/about';
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      drawer: MyDrawer(),
      appBar: AppBar(title: Text('About'),

       ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('This App is created by SUSHAN BANIYA'),),
         
        ],
      ),
    );
  }
}