import 'package:firebase_auth/firebase_auth.dart';
import 'package:townteam_app/features/auth/domain/entites/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    // required super.name,
    required super.email,
    // required super.surName,
    required super.password,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      // name: user.displayName ?? "",
      email: user.email ?? "",
      // surName: '',
      password: "", // We don't store the password in the model
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      // name: json['name'] as String,
      email: json['email'] as String,
      // surName: '',
      password: '', // Password is not stored in JSON
    );
  }
}
