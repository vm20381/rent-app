import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vm20381/helpers/utils/spring_scroll_behaviour.dart';
import '/controllers/auction_controllers/auction_items_controller.dart';
import '/views/layouts/layout.dart';

// Page to display any listed auction items
/*
class AuctionItemsPage extends StatelessWidget {
 

  @override
  _AuctionItemsPageState createState() => _AuctionItemsPageState();
}
*/

class AuctionItemsPage extends StatelessWidget {
  const AuctionItemsPage({super.key});

  /*
  @override
  void initState() {
    super.initState();
    controller = Get.put(AuctionItemsController());
    controller.fetchAuctionItems();
  }
  */

  @override
  Widget build(BuildContext context) {
    final AuctionItemsController controller = Get.put(AuctionItemsController()); // Moved outside the build method
    print("Building AuctionItemsPage");
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auction Items'),
      ),
      body: Layout(
        child: Obx(() {
        //builder: (controller) {
            if (controller.isLoading.value) {
              //If the controller is still loading, display a loading indicator
              print("Loading");
              return const Center(child: CircularProgressIndicator());
            } else if (controller.auctionItems.isEmpty) {
              print("No auction items available.");
              return const Center(
                child: Text(
                  'No auction items available.',
                ),
              ); //If there are no auction items, display a message
            } else {
              print(
                "Auction items available: ${controller.auctionItems.length}",
              );
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(
                  parent: const AlwaysScrollableScrollPhysics(),
                  decelerationRate: ScrollDecelerationRate.values[1],
                ),
                child: Column(
                  children: controller.auctionItems.map((item) {
                    print("Displaying item: ${item.description}");
                    return Card(
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.description),
                            SizedBox(height: 8.0),
                            if (item.imageUrls.isNotEmpty)
                              Center(
                                child: Image.network(
                                  item.imageUrls[0], // Display the first image
                                  height: 200,
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                ),
                              ),
                              SizedBox(height: 8.0),
                              Text('Current Bid: \$${item.currentBid}'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // Navigate to a detailed page where users can place bids
                            Get.toNamed('/auction_item_detail', arguments: item,);
                          },
                          child: const Text('Bid'),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }
          }),
        ),
      
    );
  }
}