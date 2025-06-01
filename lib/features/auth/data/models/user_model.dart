import '../../domain/entities/user.dart';

class UserModel extends User {
  UserModel({required super.token});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(token: json['token']);
  }
}
