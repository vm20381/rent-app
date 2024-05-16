import 'package:example_package/example_package.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';
// import 'controller/deep_link_controller.dart';
import 'helpers/localizations/app_localization_delegate.dart';
import 'helpers/localizations/language.dart';
import 'helpers/services/auth_services.dart';
import 'helpers/services/firebase_functions_service.dart';
import 'helpers/services/navigation_service.dart';
import 'helpers/storage/local_storage.dart';
import 'helpers/theme/app_notifier.dart';
import 'helpers/theme/app_style.dart';
import 'helpers/theme/theme_customizer.dart';
import 'routes.dart';
// ignore: depend_on_referenced_packages

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  setPathUrlStrategy();

  await LocalStorage.init();
  AppStyle.init();

  await ThemeCustomizer.init();

  // await Translator.clearTrans();
  // Translator.getUnTrans();

  // services
  Get.put(AuthService());
  // // Get.put(DeepLinkController());
  Get.put(FirebaseFunctionService());
  Get.put(ExamplePackageService());

  runApp(
    ChangeNotifierProvider<AppNotifier>(
      create: (context) => AppNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppNotifier>(
      builder: (_, notifier, ___) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeCustomizer.instance.theme,
          navigatorKey: NavigationService.navigatorKey,
          initialRoute: "/",
          getPages: getPageRoute(),
          // onGenerateRoute: (_) => generateRoute(context, _),
          builder: (_, child) {
            NavigationService.registerContext(_);
            return Directionality(
              textDirection: AppTheme.textDirection,
              child: child ?? Container(),
            );
          },
          localizationsDelegates: [
            AppLocalizationsDelegate(context),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: Language.getLocales(),

          // home: ButtonsPage(),
        );
      },
    );
  }
}
