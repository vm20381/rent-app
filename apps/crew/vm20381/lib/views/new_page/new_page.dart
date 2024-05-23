// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vm20381/views/new_page_layouts/new_page_app_bar.dart';
import 'package:vm20381/views/new_page_layouts/new_page_drawer.dart';
import '/views/layouts/layout.dart';
import '/controllers/new_page/new_page_controller.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late NewPageController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(NewPageController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<NewPageController>(
        init: controller,
        builder: (controller) {
          return Scaffold(
            backgroundColor: Colors.indigo[900],

            drawer: MyDrawer(),
            appBar: MyAppBar(title: 'The New Page'),

            body: Center(
              child: SingleChildScrollView(
                child: Container(
                  height: 400,
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.indigo[600],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "You have made it to the New Page!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          //Navigate to 2nd Page
                          Navigator.pushNamed(context, '/second_page');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo[900],
                          foregroundColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 20,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 2, color: Colors.white),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        icon: Icon(Icons.airplanemode_active),
                        label: Text(
                          "Book a Flight",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
