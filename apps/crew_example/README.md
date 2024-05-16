# Captain App Crew Example

Welcome to the Captain App Crew Example Repo!

If you've found yourself here and not read the main README, please do so [here](../../README.md).

In this directory you will find a flutter app with your name on it! This app is a simple example of a flutter app that has some basic functionality in place for you to build upon.

From here:

```bash
cd <your-github-username>
flutter run
```


### Whats In The Example

```bash
.
├── README.md
├── android
├── assets
├── build
├── ios
└── web
├── test
├── lib
│   ├── controllers
│   ├── helpers
│   ├── models
│   ├── views
│   └── widgets
│   ├── firebase_options.dart
│   ├── routes.dart
│   ├── images.dart
│   ├── main.dart
├── melos_crew_example.iml
├── pubspec.lock
├── pubspec.yaml
├── analysis_options.yaml
├── firebase.json
```

Above is the top level structure of the app. This is a relatively standard flutter app with a few extra files that are specific to our way of organising things.

In a flutter project, the `lib` directory is where the vast majority of the code will live. Flutter abstracts away the platform specific code into the `android`, `ios` and `web` directories, which keeps it all nicely separated. 

In the `lib` directory you will find `main.dart` which is the entry point for the app. This is where the app is initialised and the routes are defined.

The `pubspec.yaml` file is where all the dependencies for the app are defined. This is where you would add any new packages that you want to use in the app.

To include a local package from the `packages` directory, you can add the following to the `pubspec.yaml` under `dependencies`:


```yaml
<name-of-the-package>:
```
e.g. to include the `example_package` package into the crew_example app, you would add:

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
  provider: ^6.0.5
  # The following adds the Cupertino Icons font to your application.
  # Use with the CupertinoIcons class for iOS style icons.
  cupertino_icons: ^1.0.6
  cloud_firestore: ^4.17.3
  firebase_core: ^2.31.0
  firebase_auth: ^4.19.5
  shared_preferences: ^2.1.1
  cloud_functions: ^4.7.3
  get: ^4.3.8
  get_server: ^1.2.1
  firebase_storage: ^11.7.3
  feather_icons: ^1.2.0
  image_picker: ^1.0.0
  google_maps_flutter: ^2.2.8
  lucide_icons: ^0.257.0
  url_launcher: ^6.1.11
  url_strategy: ^0.2.0
  google_fonts: ^6.2.1
  font_awesome_flutter: ^10.7.0
  syncfusion_flutter_charts: ^25.2.4
  flutter_blurhash: ^0.8.2
  quill_html_editor: ^2.2.8
  example_package: //left blank - melos will link the package locally
  ```

  Then ensure to run `melos bootstrap` to link the package to the app.

  
