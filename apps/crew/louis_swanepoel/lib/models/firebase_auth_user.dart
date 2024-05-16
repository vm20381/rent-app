import 'dart:convert';

import 'package:flutter/services.dart';
import '/helpers/services/json_decoder.dart';
import '/models/identifier_model.dart';

class FirebaseAuthUser extends IdentifierModel {
  final String email, displayName, role, lastSignInTime, creationTime, photoURL;

  FirebaseAuthUser(
    super.id,
    this.email,
    this.displayName,
    this.role,
    this.lastSignInTime,
    this.creationTime,
    this.photoURL,
  );

  static FirebaseAuthUser fromJSON(Map<String, dynamic> json) {
    JSONDecoder decoder = JSONDecoder(json);

    String email = decoder.getString('email');
    String displayName = decoder.getString('displayName');
    String role = decoder.getString('role');
    String lastSignInTime = decoder.getString('lastSignInTime');
    String creationTime = decoder.getString('creationTime');
    String photoURL = decoder.getString('photoURL');

    return FirebaseAuthUser(
      decoder.getId,
      email,
      displayName,
      role,
      lastSignInTime,
      creationTime,
      photoURL,
    );
  }

  static Map<String, FirebaseAuthUser> mapFromJSON(Map<String, dynamic> map) {
    return map
        .map((key, value) => MapEntry(key, FirebaseAuthUser.fromJSON(value)));
  }

  static List<FirebaseAuthUser> listFromJSON(List<dynamic> list) {
    return list.map((e) => FirebaseAuthUser.fromJSON(e)).toList();
  }

  static List<FirebaseAuthUser>? _dummyList;

  static Future<List<FirebaseAuthUser>> get dummyList async {
    if (_dummyList == null) {
      dynamic data = json.decode(await getData());
      _dummyList = listFromJSON(data);
    }
    return _dummyList!.sublist(0, 3);
  }

  static Future<String> getData() async {
    return await rootBundle
        .loadString('assets/datas/firebase_auth_user_data.json');
  }
}
