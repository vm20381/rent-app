import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_form_validator.dart';
import 'package:flutter/material.dart';

enum Status {
  online,
  offline,
  draft;

  const Status();
}

class AddProductController extends MyController {
  MyFormValidator basicValidator = MyFormValidator();
  Status selectedGender = Status.online;

  @override
  void onInit() {
    super.onInit();
    basicValidator.addField(
      'name',
      label: "Product Name",
      required: true,
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'shop_name',
      label: "shop_name",
      required: true,
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'description',
      label: "description",
      required: true,
      controller: TextEditingController(),
    );
    basicValidator.addField(
      'tags',
      label: "Tags",
      required: true,
      controller: TextEditingController(),
    );
  }

  String selectedQuantity = "Fashion";

  void onSelectedQty(String qty) {
    selectedQuantity = qty;
    update();
  }

  bool showOnline = true;

  void setOnlineType(bool value) {
    showOnline = value;
    update();
  }

  final List<String> categories = [];

  void onChangeGender(Status? value) {
    selectedGender = value ?? selectedGender;
    update();
  }
}
