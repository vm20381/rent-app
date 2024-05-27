// user.dart
class UserModel {
  final String username;

  UserModel({required this.username});

  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      username: data['username'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'username': username,
    };
  }
}
