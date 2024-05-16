import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:captainapp_crew_dashboard/controller/my_controller.dart';

import 'package:captainapp_crew_dashboard/models/product.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/products.dart';

class ProductController extends MyController {
  List<Product> products = [];
  DataTableSource? data;

  ProductController();

  @override
  void onInit() {
    super.onInit();

    Product.dummyList.then((value) {
      products = value;
      data = MyData(products);
      update();
    });
  }

  void goToCreateProduct() {
    Get.toNamed('/apps/assets/add_product');
  }
}
