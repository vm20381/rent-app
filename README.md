# Captain App Crew Repo

Welcome to the Captain App Crew Repo!

This repo is a place for the Captain App Crew to collaborate, learn and experiment with app development projects.

Between the 17th - 24th May, we are running a **Learning Challenge Week**, this is an opportunity for you to dive into Flutter, learn as much as possible, work together and have fun! The following week we will have a prize ceremony, where the best contributors will be rewarded with rum! Read on to find out more...

If you want to dive straight into something challenging, you can skip to section [Harder Challenges](#harder-challenges).

If not, follow the instructions below to get started, then have a go at the [Warm Up Challenges](#warm-up-challenges).

If you get stuck, ask ChatGPT for help. If ChatGPT fails you, paste:

```
/meet [livehare link]
```

into the 'live-share' slack channel. Here we want to encourage collaboration, please help each other. We are looking for team players at Captain App.

If help isn't available synchronously, open an issue on the repository on github, and we will help as soon as possible asynchronously.

# Prizes

We have some exciting prizes to award at the end of the **Learning Week Challenge**. Here are the prizes up for grabs:

-   **Most People In A Live Share Session**: The person who manages to get the most people in a live share session at one time. This is to encourage collaboration and teamwork. Screenshot for proof - share in the slack channel.

-   **Dashboard Mania**: The person who contributes the most to the crew dashboard app. This is to encourage people to work together on the same project. 

-   **Most Creative App**: The person who creates the most creative app. This is to encourage people to think outside the box and come up with new ideas.

-   **Most Helpful Crew Member**: The person who helps the most people during the week. This is to encourage people to help each other and work together.

-   **Most Improved**: The person who shows the most improvement during the week. This is to encourage people to learn and grow.

# Getting Started

A little housekeeping to begin. Make sure you have completed the following:

### General Advice

-   Enable Copilot; you can get it free by adding your University email to your GitHub account.

-   Use ChatGPT; if in doubt, ask ChatGPT.

-   This is not an individual challenge, we want you to work together, help each other, use each others packages, ui and widgets. Working together will yield the best results.
-   Commit regularly, use the naming convention, `feat(your-name): what you did in this commit`.
-   If you think its cheating, its probably not. Use ChatGPT, Copilot, StackOverflow, Google, and any other resources you can think of. Short of paying someone on Fiverr to do it for you, anything goes.
-   Here are a couple of helpful videos to get you started:
   
https://youtu.be/1xipg02Wu8s?si=dCdUDN_MPl2Zzg0x

https://youtu.be/FdgDgcrDeNI?si=Wb5PkoVYMlyWJEdw

## VS Code Setup

If you don't have Visual Studio Code installed, you can download it [here](https://code.visualstudio.com/).

This is our recommended IDE for Flutter development (and all other development). It has a lot of great extensions that will help you with your development.

## Recommended VS Code Extensions

We highly recommend you install the following extensions in your Visual Studio Code:

-   Live Share (required)
-   Dart
-   Flutter
-   Live Server
-   Github Copilot (pretty much required)
-   Github Copilot Chat
-   Genie (ChatGPT built into VS Code)
-   Code Time
-   Code Spell Checker
-   Prettier
-   Better Comments (comments are more fun with colours)
-   vscode-icons (makes finding files easier)
-   Git Graph
-   Git Blame

## Flutter Dev Environment Setup

Time to get your Flutter development environment set up. Follow the instructions in the [Flutter documentation](https://flutter.dev/docs/get-started/install).

For simplicity, we recommend the setup for web first, this will be the fastest way to get started. You can always add mobile later.

Once you think you have installed the flutter SDK, run the following command to verify:

```bash
flutter doctor
```

If there are any issues, send it to ChatGPT, and it will help you solve it.

Minimum requirements for Web:

```
Running flutter doctor...
Doctor summary (to see all details, run flutter doctor -v):
[✓] Flutter (Channel stable, 3.22.0, on macOS 14.4.0 23E214 darwin-arm64, locale en)
[!] Android toolchain - develop for Android devices
[✓] Chrome - develop for the web
[!] Xcode - develop for iOS and macOS (Xcode not installed)
[!] Android Studio (not installed)
[✓] VS Code (version 1.89)
[✓] Connected device (1 available)
[✓] Network resources

! Doctor found issues in 3 categories.
```

With this you can run a flutter app on the web.

## Repository Structure

Below is the directory structure of this flutter project. The project is a monorepo bootstrapped by [Melos](https://pub.dev/packages/melos). Melos allows for us to have multiple flutter apps in the same project, and share code between them.

All flutter apps are in the `apps` directory. All shared packages are in the `packages` directory. All firebase cloud functions are in the `functions` directory.

For a deeper explanation of the structure of a flutter app, view the Readme in the `apps/crew_example` directory, [here](apps/crew_example/README.md).

```
.
├── README.md
├── apps
│   ├── crew
│   ├── crew_dashboard
│   └── crew_example
├── firebase.json
├── firestore.indexes.json
├── firestore.rules
├── functions
│   ├── examples
│   └── user_management
├── local
│   ├── local_firebase_admin
│   └── local_linear_admin
├── melos.yaml
├── melos_captainapp_crew.iml
├── packages
│   └── example_package
├── pubspec.lock
├── pubspec.yaml
├── remoteconfig.template.json
└── storage-cors-config.json
```

As you can see, there are 3 directories within the `apps` directory.

`Crew_dashboard` is full bells and whistles flutter app, it has lots of widgets, styling, and functionality.

`Crew_example` is a stripped back version of `crew_dashboard`, it has the same core utility as the dashboard, i.e. authentication, navigation, and state management, but without all the pages.

`Crew` is a directory full of flutter apps for you. Everyone gets their own app to work on. You can do whatever you like with your app, but we have some challenges for you to complete. That being said if you have a great idea for a feature or full app, go for it!

# Running your App

First run:

```bash
 melos bootstrap
```

This will link all the packages, and apps that are in this repository together.

Then navigate to the `apps/crew/<your-github-username>` directory and run the following command to run in a browser:

```bash
flutter run -d chrome
```

(If you want to run it on a mobile device, ask ChatGPT for help, it can run you through the specifics for your machine)

To login see the `README.md` in the `apps/crew/<your-github-username>`.

# The First Challenge

### Add a page

The first challenge is to add a new page to your app. This page can be anything you like.

We subscribe to the MVC (Model View Controller) pattern in this project, so you will need to create a new controller for your page, and a new view.
See [medium article](https://medium.com/@Faiz_Rhm/understanding-mvc-architecture-in-flutter-a-comprehensive-guide-with-examples-5d1a372c7eaf) for brief explanation. You can probably figure it out from the codebase, but if you're struggling, ask ChatGPT.

Start by making an empty controller for the new page.

```dart
import 'package:get/get.dart';

class NewPageController extends GetxController {
  // Add your controller logic here
}
```

Next make a new view.

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '/views/layouts/layout.dart';
import '/controllers/new_page/new_page_controller.dart';

class NewPage extends StatefulWidget {
  const NewPage({Key? key}) : super(key: key);

  @override
  _NewPageState createState() => _NewPageState();
}

class _NewPageState extends State<NewPage> {
  late NewPageController controller;

  @override
  void initState() {
    super.initState();
    controller = NewPageController();
  }

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<NewPageController>(
        init: controller,
        builder: (controller) {
          return Container();
        },
      ),
    )
  }
}
```

Finally, add the new page to your app's navigation. This means adding it as a route to routes.dart and adding a button to navigate to the new page.

The simplest place to add the button is in left_bar.dart.

*Get* is your friend, you can use it for navigation anywhere with `Get.toNamed('/new_page')`. However, for the sake of code maintainability, we'd like all application logic to happen in the controllers.

i.e. Let's say you wanted to add a navigation button on your new page, in your controller you'd add a function like this:

```dart

class NewPageController extends GetxController {
  void navigateToNewPage() {
    Get.toNamed('/new_page');
  }
}
```

then in your view you'd call this function like this:

```dart
ElevatedButton(
  onPressed: controller.navigateToNewPage,
  child: Text('Navigate to New Page'),
)
```

similarly we'd like to see all state to be managed in the controllers, and not in the views. This way we can manage when the view is updated (rebuilt) using get's update() method built into the controllers.

Imagine we are subscribing to a stream in our controller, for example, let's subscribe to the user's roles from the Auth Service (you have this already), we want to update the view when the user's roles change. We can do this by calling `update()` in the controller.

```dart
class NewPageController extends GetxController {
  // first we need to get the AuthService - It get's created in the main.dart file. That's why we can use Get.find() to get it.
  // To learn more about Dependency Injection in Flutter, check out the GetX documentation: https://pub.dev/packages/get
  final authService = Get.find<AuthService>();

  // create a variable to hold the user's roles
  String userRole = '';

  @override
  void onInit() {
    authService.userRoles.listen((claims) {
      // roles as you'll find (hover over with mouse) is a map of <String, Dynamic> as fetched from the claims made in the user's JWT known in firebase as ID Tokens.
      if (claims == null) {
        // no role, return
        userRole = '';
        update();
        return;
      }
      // NB: Big brownie points if you refactor the user_management api to handle multiple roles, it's not a hard challenge, we're just suffering error carried forward having set this up in a rush. Careful not to break the existing functionality (we can revert if you do).
      userRole = roles['role'];
      // update the view when the user's roles change
      update();
    });
  }
}
```

There are 'cleverer' ways to do this, again, *Get* is your friend, let's try that again, but this time using the `Obx` widget.

```dart
import 'package:flutter/material.dart';

class NewPage extends StatelessWidget {
  final controller = Get.find<NewPageController>();

  @override
  Widget build(BuildContext context) {
    return Layout(
      child: GetBuilder<NewPageController>(
        init: controller,
        builder: (controller) {
          return Obx(() {
            return Text(controller.userRole);
          });
        },
      ),
    );
  }
}
```

Observables (Rx/Obx) are a powerful tool in *Get/GetX*, they manage the lifecycle of the widget for you, so you don't have to worry about calling `update()` in the controller.

This time we will setup our userRole as an observable in the controller.

```dart
import 'package:get/get.dart';

class NewPageController extends GetxController {
  final authService = Get.find<AuthService>();

  RxString userRole = ''.obs;

  @override
  void onInit() {
    authService.userRoles.listen((claims) {
      if (claims == null) {
        userRole.value = '';
        return;
      }
      // by virtue of being an observable, this will update the view automagically, plus be more efficient than calling update() since it will only update the part of the view that needs updating rather than calling the build method of the entire view.
      userRole.value = roles['role'];
    });
  }
}
```

NB: You can make observables out of any type you like using Rxn<T>, RxList<T>, RxMap<K, V>, RxSet<T>, RxInt, RxDouble, RxBool, etc.

That's it, with this understood, GPT and copy and paste, we now believe you are armed with the knowledge to complete any of the following challenges. Bring others along with you, help them, the best way to cement your knowledge is to teach it.

# How to deploy YOUR site

```bash
firebase login
```
(Use learn@captainapp.co.uk)


```bash
firebase deploy --only hosting:your-github-username
```

Note, you may need to enable experimental web hosting as prompted.

# Other Challenges 

By all means, we want you to explore, have a play around and see what you can come up with. However, if you're looking for some inspiration, here are some challenges you could try:

1.  **Make a ToDo List** - Create a page on your app that allows users to add, edit and delete tasks.

2.  **Make it collaborative** Maintain the tasks as part of a collection in Firestore and stream them to all users in real-time.

If you've got this far, you're doing great! If you've got stuck, remember to ask each other, us or ChatGPT for help. Also, steal code from your peers, there's no point struggling when someone else has already solved the problem, its a bonus if you can understand the code you've stolen. We do want it to run.

3. **Make a chat page** - Create a page on your app that allows users to send messages to each other. You can steal the code from the `crew_dashboard` app, it has a chat view already. You can make the requests from client side, this challenge isn't about security. Use Openai or Gemini's api. (Openai is probably easier because it's better documented and didn't only come out on Wednesday).

4. **Make a file browser** - Create a page on your app that allows users to upload and download files. You can use Firebase Storage for this.

5. **Extend** - Extend the functionality of the dashboard app, or your own, bring others into a live share and get them to help you, this is the best practice for the real job. Make the chat collaborative (real time via firestore), add drag and drop between windows on the file browser. Honestly you could keep going with challenges 3 and 4 forever, they are pretty open ended.

These are just a few ideas to get you started. Feel free to come up with your own ideas and challenges. Remember, the goal is to learn and have fun!

Point of interest: to note is that we are not looking for the most complex solution, we are looking for the most elegant solution. The solution that is the most maintainable, the most readable, and the most efficient.

Another point: If you've breezed through these challenges, sure we could set you harder ones, but we'd rather you help your peers. We are looking for team players, not individuals. The more capable our team as a whole, the further this adventure will go.

Go forth!
READ THE READMEs.

See you on Slack!
