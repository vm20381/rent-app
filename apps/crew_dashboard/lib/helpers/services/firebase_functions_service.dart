import 'package:captainapp_crew_dashboard/models/firebase_auth_user.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

class FirebaseFunctionService {
  final FirebaseFunctions functions =
      FirebaseFunctions.instanceFor(region: 'europe-west1');

  Future<List<T>> callListFunction<T>(
    String functionName, {
    Map<String, dynamic>? parameters,
    String? listKey,
  }) async {
    try {
      HttpsCallable callable = functions.httpsCallable(functionName);
      final HttpsCallableResult result = await callable.call(parameters);

      if (result.data is List) {
        return (result.data as List)
            .map<T>((item) => fromJson<T>(item))
            .toList();
      } else if (result.data is Map<String, dynamic> && listKey != null) {
        if (result.data.containsKey(listKey)) {
          return (result.data[listKey] as List)
              .map<T>((item) => fromJson<T>(item))
              .toList();
        } else {
          throw Exception("Key '$listKey' not found in data");
        }
      } else {
        throw Exception(
          "Expected data to be a List or a Map containing the key '$listKey', but got ${result.data.runtimeType}",
        );
      }
    } on FirebaseFunctionsException catch (error) {
      if (kDebugMode) {
        print('FirebaseFunctionsException:');
        print(error.code);
        print(error.details);
        print(error.message);
      }
      throw Exception("Error calling function $functionName");
    }
  }

  Future<void> callCreateFunction(
    String functionName,
    Map<String, dynamic> parameters,
  ) async {
    try {
      HttpsCallable callable = functions.httpsCallable(functionName);
      await callable.call(parameters);
      if (kDebugMode) {
        print('User successfully created with parameters $parameters');
      }
    } on FirebaseFunctionsException catch (error) {
      if (kDebugMode) {
        print('FirebaseFunctionsException when creating user:');
        print(error.code);
        print(error.details);
        print(error.message);
      }
      throw Exception(
        "Error creating user with function $functionName: ${error.message}",
      );
    }
  }

  T fromJson<T>(dynamic json) {
    // Provide conversion from JSON to your types here
    if (T == FirebaseAuthUser) {
      final user = FirebaseAuthUser.fromJSON(json) as T;
      return user;
    } else {
      throw Exception(
        "Type $T is not supported by callListFunction's fromJson",
      );
    }
  }
}
