import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vm20381/helpers/utils/spring_scroll_behaviour.dart';
import '/controllers/auction_controllers/auction_items_controller.dart';
import '/views/layouts/layout.dart';


//Page to display any listed auction items

class AuctionItemsPage extends StatefulWidget {
  const AuctionItemsPage({Key? key}) : super(key: key);

  @override
  _AuctionItemsPageState createState() => _AuctionItemsPageState();
}

class _AuctionItemsPageState extends State<AuctionItemsPage> {
  late AuctionItemsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AuctionItemsController());
    controller.fetchAuctionItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Auction Items'),
      ),
      body: Layout(
        child: GetBuilder<AuctionItemsController>(        // rebuilds the widget when the controller's state changes
          init: controller,              //initialize the controller
          builder: (controller) {
            print("Building UI...");
            if (controller.isLoading == true) {         //If the controller is still loading, display a loading indicator
              print("Loading");
              return Center(child: CircularProgressIndicator());
            } else if (controller.auctionItems.isEmpty) {
              print("No auction items available.");
              return Center(child: Text('No auction items available.'));   //If there are no auction items, display a message
            } else {
              print("Auction items available: ${controller.auctionItems.length}");
              return ScrollConfiguration(
                behavior: SpringScrollBehavior(),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.auctionItems.length,      //Display the list of auction items
                        itemBuilder: (context, index) {                 //For each item, display its description, current bid, and a button to place a bid
                          final item = controller.auctionItems[index];
                          print("Displaying item: ${item.description}");
                          return Card(
                            child: ListTile(
                              title: Text(item.description),
                              subtitle: Text('Current Bid: \$${item.currentBid}'),
                              trailing: ElevatedButton(
                                onPressed: () {
                                  // Navigate to a detailed page where users can place bids
                                  Get.toNamed('/auction_item_detail', arguments: item);
                                },
                                child: Text('Bid'),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
