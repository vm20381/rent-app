import 'dart:convert';

import 'package:cloud_functions/cloud_functions.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart'; //
import 'package:image_picker/image_picker.dart';
import '/helpers/services/firebase_functions_service.dart';
import '/models/firebase_auth_user.dart';

class AuthService extends GetxService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Reactive State Management
  final Rxn<User> firebaseUser = Rxn<User>();
  RxMap<String, dynamic> userRoles = RxMap<String, dynamic>();

  User? get user => firebaseUser.value;
  bool get isLoggedIn => firebaseUser.value != null;

  @override
  void onInit() {
    super.onInit();
    firebaseUser.bindStream(
      _firebaseAuth.authStateChanges(),
    ); // Bind stream to listen to authentication state changes
    firebaseUser.listen((User? user) async {
      if (user != null) {
        userRoles.value = await _fetchAndSetUserRoles() ?? {};
      } else {
        userRoles.clear();
      }
    });
  }

  Future<Map<String, String>?> registerUser(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      // Optionally update the display name with the first and last names
      await user?.updateDisplayName("$firstName $lastName");
      return null; // Return null on successful registration
    } catch (e) {
      if (e is FirebaseAuthException) {
        return {e.code: e.message ?? "An error occurred"};
      }
      return {'error': 'An unexpected error occurred during registration'};
    }
  }

  Future<Map<String, String>?> loginUser(String email, String password) async {
    try {
      // Attempt to sign in the user using Firebase Auth
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        firebaseUser.value = userCredential.user; // Update the observable user
        return null; // Return null to signify success
      }
      return {
        'error': 'Unknown error occurred',
      }; // Generic error if no user found (shouldn't happen in theory)
    } catch (e) {
      if (e is FirebaseAuthException) {
        return {
          'error': e.message ?? 'An error occurred',
        }; // Return specific Firebase auth error messages
      }
      return {'error': 'An error occurred'};
    }
  }

  Future<void> signOut() async {
    if (kDebugMode) {
      final username = firebaseUser.value?.displayName;
      print('Signing out user: $username');
    }
    await _firebaseAuth.signOut();
    firebaseUser.value = null; // Clear the user value on sign out
  }

  static Future<Map<String, String>?> sendPasswordResetEmail(
    String email,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null; // On successful sending, return null
    } catch (e) {
      // Handle exceptions and return a map of errors
      if (e is FirebaseAuthException) {
        return {e.code: e.message ?? "An error occurred"};
      }
      return {'error': 'An unexpected error occurred'};
    }
  }

  // Get user roles from custom claims
  Future<Map<String, dynamic>?> _fetchAndSetUserRoles() async {
    if (!isLoggedIn) return null;
    final idTokenResult = await firebaseUser.value!.getIdTokenResult(true);
    // print('User roles: ${idTokenResult.claims}');
    return idTokenResult.claims;
  }

  bool hasRole(String role) {
    return userRoles['role'] == role;
  }

  Future<bool> setUserRole(String uid, String role) async {
    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
      'setUserRole',
    );

    try {
      print('setting role for $uid with role $role');
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'uid': uid,
          'role': role,
        },
      );
      if (kDebugMode) {
        print('role set $result');
      }
      // refresh user auth token
      print('refreshing user token');
      userRoles.value = (await _fetchAndSetUserRoles())!;
      return true;
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('FirebaseFunctionsException:');
        print(e.code);
        print(e.message);
        print(e.details);
      }
    }
    return false;
  }

  Future<List<FirebaseAuthUser>> loadAllUsers() async {
    final functionsService = Get.find<FirebaseFunctionService>();
    return await functionsService.callListFunction<FirebaseAuthUser>(
      'listUsers',
      listKey: 'users',
    );
  }

  Future<Map<String, String>?> updateDisplayName({
    String? firstName,
    String? lastName,
  }) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      String displayName =
          "${firstName ?? user.displayName?.split(' ').first} ${lastName ?? user.displayName?.split(' ').last}"
              .trim();
      try {
        await user.updateDisplayName(displayName);
        firebaseUser.value = _firebaseAuth
            .currentUser; // Refresh the user info in the observable

        return null; // Return null on successful update
      } catch (e) {
        if (e is FirebaseAuthException) {
          return {e.code: e.message ?? "Failed to update profile"};
        }
        return {'error': 'An unexpected error occurred during profile update'};
      }
    }
    return {'error': 'No user logged in'};
  }

  Future<Map<String, String>?> updateUserPhotoURL(String photoURL) async {
    User? user = _firebaseAuth.currentUser;
    if (user != null) {
      try {
        await user.updatePhotoURL(photoURL);
        firebaseUser.value = _firebaseAuth
            .currentUser; // Refresh the user info in the observable
        return null; // Return null on successful update
      } catch (e) {
        if (e is FirebaseAuthException) {
          return {e.code: e.message ?? "Failed to update profile"};
        }
        return {'error': 'An unexpected error occurred during profile update'};
      }
    }
    return {'error': 'No user logged in'};
  }

  Future<Map<String, String>?> updatePassword(String newPassword) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword);
      return null; // Success
    } catch (e) {
      if (e is FirebaseAuthException) {
        return {e.code: e.message ?? "An error occurred"};
      }
      return {'error': 'An unexpected error occurred during password update'};
    }
  }

  Future<String> uploadProfileImageToFirebaseStorage(XFile image) async {
    // Upload the image to Firebase Storage
    final HttpsCallable callable =
        FirebaseFunctions.instanceFor(region: 'europe-west1').httpsCallable(
      'uploadUserPhotoToBucket',
    );
    // List<int> bytes =
    //     utf8.encode(await image.readAsString()); // Convert string to bytes
    final String encodedBase64 =
        base64Encode(await image.readAsBytes()); // Encoding bytes to Base64
    // print("Encoded Base64: $encodedBase64");
    // print('file as string `$encodedBase64`');
    String downloadURL = '';
    try {
      final HttpsCallableResult result = await callable.call(
        <String, dynamic>{
          'uid': user!.uid,
          'imageData': encodedBase64,
          'filename': image.name,
        },
      );
      if (kDebugMode) {
        print('the response:');
        print('${result.data}');
      }
      downloadURL = result.data['downloadURL'];
    } on FirebaseFunctionsException catch (e) {
      if (kDebugMode) {
        print('FirebaseFunctionsException:');
        print(e.code);
        print(e.message);
        print(e.details);
      }
    }

    return downloadURL;
  }
}
