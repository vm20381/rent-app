import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '/helpers/services/auth_services.dart';
import '/helpers/theme/theme_customizer.dart';
import '../my_controller.dart';

class LayoutController extends MyController {
  final authService = Get.find<AuthService>();
  final QuillEditorController quillHtmlEditor = QuillEditorController();

  final RxString photoURL = "".obs; // Reactive photo URL

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.addTable,
    ToolBarStyle.blockQuote,
    ToolBarStyle.clean,
    ToolBarStyle.clearHistory,
    ToolBarStyle.codeBlock,
    ToolBarStyle.directionLtr,
    ToolBarStyle.directionRtl,
    ToolBarStyle.editTable,
    ToolBarStyle.headerOne,
    ToolBarStyle.headerTwo,
    ToolBarStyle.image,
    ToolBarStyle.indentAdd,
    ToolBarStyle.indentMinus,
    ToolBarStyle.link,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.redo,
    ToolBarStyle.strike,
    ToolBarStyle.video,
  ];

  ThemeCustomizer themeCustomizer = ThemeCustomizer();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> scrollKey = GlobalKey();

  // LayoutController() {
  //   save = false;
  // }

  @override
  void onInit() {
    super.onInit();
    photoURL.value = authService.user?.photoURL ?? "";
    authService.firebaseUser.listen((user) {
      photoURL.value = user?.photoURL ?? "";
    });
  }

  @override
  void onReady() {
    super.onReady();
    ThemeCustomizer.addListener(onChangeTheme);
  }

  void onChangeTheme(ThemeCustomizer oldVal, ThemeCustomizer newVal) {
    themeCustomizer = newVal;
    update();

    if (newVal.rightBarOpen) {
      scaffoldKey.currentState?.openEndDrawer();
    } else {
      scaffoldKey.currentState?.closeEndDrawer();
    }
  }

  enableNotificationShade() {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom, SystemUiOverlay.top]);
  }

  disableNotificationShade() {
    // SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
  }

  void logout() async {
    await authService.signOut();
    Get.offAllNamed(
      '/auth/login',
    ); // Navigate to login screen and remove all previous routes
  }

  @override
  void dispose() {
    super.dispose();
    ThemeCustomizer.removeListener(onChangeTheme);
  }
}
