import 'package:flutter/material.dart';

import '../screens/overview.dart';
import '../screens/about.dart';


class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.blue,
        child: ListView(children: [
          SizedBox(height: 100),
      ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.add),
        ),
        title: Text('ADDING SCREEN'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed('/');
        }
      ),
      ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.laptop_chromebook),
        ),
        title: Text('OVERVIEW SCREEN'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(Overview.routeName);
        }
      ),
      ListTile(
        leading: CircleAvatar(
          child: Icon(Icons.supervised_user_circle),
        ),
        title: Text('ABOUT'),
        onTap: () {
          Navigator.of(context).pushReplacementNamed(About.routeName);
        }
      ),
    ]));
  }
}
