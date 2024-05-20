import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex.dart';
import 'package:captainapp_crew_dashboard/helpers/widgets/my_flex_item.dart';
import 'package:captainapp_crew_dashboard/models/changelog_collection.dart';
import 'package:captainapp_crew_dashboard/views/layouts/layout.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangelogScreen extends StatefulWidget {
  const ChangelogScreen({super.key});

  @override
  State<ChangelogScreen> createState() => _ChangelogScreenState();
}

class _ChangelogScreenState extends State<ChangelogScreen> {
  late ChangelogController controller;
  late Future<ChangelogCollection> _changelogCollection;

  @override
  void initState() {
    super.initState();
    controller = Get.put(ChangelogController());
    _changelogCollection =
        ChangelogCollection.fromAsset('assets/datas/changelog.json');
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder(
        init: controller,
        builder: (controller) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder<ChangelogCollection>(
                  future: _changelogCollection,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error: ${snapshot.error}"));
                      }
                      return Text(snapshot.data!.changes[0].version);
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ChangelogController extends GetxController {}
