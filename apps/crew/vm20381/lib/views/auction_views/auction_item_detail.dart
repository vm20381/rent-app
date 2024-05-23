import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/auction_controllers/auction_item_detail_controller.dart';
import '/models/auction_item.dart';
import '/views/layouts/layout.dart';

//Page to display the details of a specific auction item, and allow users to place bids

class AuctionItemDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuctionItem item = Get.arguments;
    final AuctionItemDetailController controller = Get.put(AuctionItemDetailController(item));

    return Scaffold(
      appBar: AppBar(
        title: Text(item.description),
      ),
      body: Layout(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Current Bid: \$${item.currentBid}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold), 
              ),
              TextFormField(        //Input field for the user's bid
                controller: controller.bidController,
                decoration: InputDecoration(labelText: 'Your Bid'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              ElevatedButton(    //Button to place a bid
                onPressed: controller.placeBid,
                child: Text('Place Bid'),
              ),
              Obx(() {          //Obx widget to listen for changes in the controller's state
                if (controller.isLoading == true) {     //If the controller is still loading, display a loading indicator, else display an error message if there is one
                  return CircularProgressIndicator();
                } else if (controller.errorMessage.isNotEmpty) {
                  return Text(controller.errorMessage.value, style: TextStyle(color: Colors.red));
                } else {
                  return Container();
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
