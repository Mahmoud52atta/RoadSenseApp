import 'package:firebase_auth/firebase_auth.dart';
import 'package:road_sense_app/features/auth/actions/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.name,
    required super.email,
    required super.password,
    required super.phone,
  });

  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      name: user.displayName ?? '',
      email: user.email ?? '',
      password: user.uid,
      phone: user.phoneNumber ?? '',
    );
  }
}
