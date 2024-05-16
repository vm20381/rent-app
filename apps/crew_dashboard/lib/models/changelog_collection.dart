import 'dart:convert';
import 'package:flutter/services.dart';

class ChangelogCollection {
  final List<ChangelogChange> changes;

  ChangelogCollection({required this.changes});

  factory ChangelogCollection.fromJson(List<dynamic> jsonList) {
    List<ChangelogChange> changes =
        jsonList.map((json) => ChangelogChange.fromJson(json)).toList();
    return ChangelogCollection(changes: changes);
  }

  static Future<ChangelogCollection> fromAsset(String path) async {
    final jsonString = await rootBundle.loadString(path);
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return ChangelogCollection.fromJson(jsonList);
  }
}

class ChangelogChange {
  final String version;
  final String date;
  final String description;
  final List<String> logs;

  ChangelogChange({
    required this.version,
    required this.date,
    required this.description,
    required this.logs,
  });

  factory ChangelogChange.fromJson(Map<String, dynamic> json) {
    return ChangelogChange(
      version: json['version'],
      date: json['date'],
      description: json['description'],
      logs: List<String>.from(json['logs']),
    );
  }

  factory ChangelogChange.empty() {
    return ChangelogChange(version: '', date: '', description: '', logs: []);
  }
}
