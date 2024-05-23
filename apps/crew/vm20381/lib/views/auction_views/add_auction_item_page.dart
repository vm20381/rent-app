import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vm20381/controllers/auction_controllers/add_auction_item_controller.dart';
import '/views/layouts/layout.dart';


class AddAuctionItemPage extends StatefulWidget {  //Stateful Widget for AddAuctionItemPage
  const AddAuctionItemPage({Key? key}) : super(key: key);

  @override
  _AddAuctionItemPageState createState() => _AddAuctionItemPageState();
}

class _AddAuctionItemPageState extends State<AddAuctionItemPage> {  //State Class for AddAuctionItemPage
  late AddAuctionItemController controller;

  @override
  void initState() {    //Called when this object is created
    super.initState();
    controller = Get.put(AddAuctionItemController());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Auction Item'),
      ),

      body: Layout(
        child: GetBuilder<AddAuctionItemController>(  // rebuilds the widget when the controller's state changes
          init: controller,              //initialize the controller
          builder: (controller) {
            return Form(           //Form widget to create a an Auction Item
              key: GlobalKey<FormState>(),
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextFormField(    //Input field for the description of the item
                      controller: controller.descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description';
                        }
                        return null;
                      },
                    ),
                    TextFormField(      //Input field for the starting bid of the item
                      controller: controller.startingBidController,
                      decoration: InputDecoration(labelText: 'Starting Bid'),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a starting bid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.pickImages,   //Calls the pickImages method (from controller) when the user taps on the button, and updates the UI
                      child: Text('Pick Images'),
                    ),
                    SizedBox(height: 20),
                    controller.images != null
                        ? Wrap(       //Displays the images selected by the user
                            children: controller.images!
                                .map((image) => Image.memory(image, width: 100, height: 100)) //Displays the images selected by the user
                                .toList(),              //Converts the images to a list
                          )
                        : Container(),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: controller.uploadItem,  //Calls the uploadItem method (from controller) when the user taps on the button
                      child: Text('Submit'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
