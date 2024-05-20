import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/models/customer.dart';
import 'package:captainapp_crew_dashboard/views/apps/assets/customers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CustomersController extends MyController {
  List<Customer> customers = [];
  DataTableSource? data;

  CustomersController();

  int currentPage = 1;

  @override
  void onInit() {
    super.onInit();

    Customer.dummyList.then((value) {
      customers = value;
      data = MyData(customers);
      update();
    });
  }

  void goToDashboard() {
    Get.toNamed('/dashboard');
  }
}
