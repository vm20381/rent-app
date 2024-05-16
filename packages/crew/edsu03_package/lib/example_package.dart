library example_package;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// A Calculator.
class Calculator {
  // a note... this is not a good example of where to put state for a service for a package.
  // You will have to manage the lifecycle of this class yourself.
  // It's better to use a GetX controller for state management.
  // if you'd like to get your head around this I recommend implementing a Singleton pattern and using GetX to make it globally available.

  // state
  int memory = 0;

  /// is for doc strings. I.e. you will see that when you hover over a method in VSCode.

  /// Returns [value] plus 1.
  int addOne(int value) => value + 1;

  /// Saves [value] to memory.
  void saveToMemory(int value) {
    memory = value;
  }

  /// Retrieves the last value saved to memory.
  /// Returns 0 if no value has been saved.
  int retrieveFromMemory() => memory;
}

// a Widget
class ExamplePackageWidget extends StatelessWidget {
  final String message;
  const ExamplePackageWidget({
    super.key,
    this.message = 'Hello, package widget!',
  });

  @override
  Widget build(BuildContext context) {
    return const Text('Hello, packages!');
  }
}

// a [Get] service
class ExamplePackageService extends GetxService {
  // To skip all that singleton stuff, you can use GetX services.
  String getHello() => 'Hello, Get Service from package!';
}
