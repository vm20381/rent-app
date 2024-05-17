import 'dart:convert';

import 'package:captainapp_crew_dashboard/helpers/services/json_decoder.dart';
import 'package:captainapp_crew_dashboard/images.dart';
import 'package:captainapp_crew_dashboard/models/identifier_model.dart';
import 'package:flutter/services.dart';

class Discover extends IdentifierModel {
  final String name, address, image;

  Discover(super.id, this.name, this.address, this.image);

  static Discover fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String name = decoder.getString('name');
    String address = decoder.getString('address');
    String image = Images.randomImage(Images.avatars);

    return Discover(decoder.getId, name, address, image);
  }

  static List<Discover> listFromJSON(List<dynamic> list) {
    return list.map((e) => Discover.fromJSON(e)).toList();
  }

  static List<Discover>? _dummyList;

  static Future<List<Discover>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 10);
  }

  static Future<String> getData() async {
    return await rootBundle.loadString('assets/datas/discovery_data.json');
  }
}
