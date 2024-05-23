// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  MyAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      elevation: 0,
      leading: Builder(
        builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
      ),
      actions: [IconButton(onPressed: () {} , icon: Icon(Icons.search), color: Colors.white)],
      backgroundColor: Colors.indigo[400],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
