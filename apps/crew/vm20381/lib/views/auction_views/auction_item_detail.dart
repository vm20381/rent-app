import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/controllers/auction_controllers/auction_item_detail_controller.dart';
import '/models/auction_item.dart';
import '/views/layouts/layout.dart';

// Page to display the details of a specific auction item, and allow users to place bids
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
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    item.description,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 16),
                Container(
                  height: 200,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: item.imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Image.network(
                          item.imageUrls[index],
                          fit: BoxFit.contain,
                          width: 200,
                          height: 200,
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Current Bid: \$${item.currentBid}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: controller.bidController,
                  decoration: InputDecoration(labelText: 'Your Bid'),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.placeBid,
                  child: Text('Place Bid'),
                ),
                SizedBox(height: 20),
                Obx(() {
                  if (controller.isLoading == true) {
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
      ),
    );
  }
}
