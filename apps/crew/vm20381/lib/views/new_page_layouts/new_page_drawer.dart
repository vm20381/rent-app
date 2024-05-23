// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor:  Colors.indigo[400],
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text("H O M E", style: TextStyle(color: Colors.white, fontSize: 20)),
            onTap: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          ListTile(
            leading: Icon(Icons.airplanemode_active, color: Colors.white),
            title: Text("Book a Flight", style: TextStyle(color: Colors.white, fontSize: 20)),
            onTap: () {
              Navigator.pushNamed(context, '/second_page');
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: Colors.white),
            title: Text("Profile", style: TextStyle(color: Colors.white, fontSize: 20)),
            onTap: () {
              Navigator.pushNamed(context, '/my-profile');
            },
          ),
        ],
      ),
    );
  }
}
