import 'dart:async';

import 'package:captainapp_crew_dashboard/controller/my_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:uni_links/uni_links.dart';

class DeepLinkController extends MyController {
  late StreamSubscription _linkSubscription;

  @override
  void onInit() async {
    super.onInit();
    final initialLink = await getInitialLink();
    if (initialLink != null) {
      if (kDebugMode) {
        print('Initial link: $initialLink');
      }
      _handleDeepLink(initialLink);
    }
    if (kDebugMode) {
      print('Listening to deep links');
    }
    // if is web ignore the deep links
    if (kIsWeb) {
      return;
    }
    _linkSubscription = linkStream.listen(
      (String? link) {
        if (link != null) {
          _handleDeepLink(link);
        }
      },
      onError: (err) {
        if (kDebugMode) {
          print('Error on deep link: $err');
        }
      },
    );
  }

  @override
  void onClose() {
    _linkSubscription.cancel();
    if (kDebugMode) {
      print('Deep link controller disposed');
    }
    super.onClose();
  }

  void _handleDeepLink(String link) {
    final uri = Uri.parse(link);
    if (uri.host == 'captainapp-crew-2024.web.app' &&
        uri.pathSegments.first == 'entities') {
      if (kDebugMode) {
        print('Handling deep link: $link');
      }
      final uid = uri.pathSegments[1];
      Get.toNamed('/entities/$uid');
    }
  }
}
