import 'package:flutter/material.dart';

class UserModel extends ChangeNotifier {
  String? _username;
  String? _email;
  String? _password;
  String? _reEnteredPassword;

  UserModel({
    String? username,
    String? email,
    String? password,
    String? reEnteredPassword,
  }) {
    _username = username ?? '';
    _email = email ?? '';
    _password = password ?? '';
    _reEnteredPassword = reEnteredPassword ?? '';
  }

  // Getters
  String? get username => _username;
  String? get email => _email;
  String? get password => _password;
  String? get reEnteredPassword => _reEnteredPassword;

  // Setters with notifyListeners
  void setUsername(String value) {
    _username = value;
    notifyListeners();
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();
  }

  void setPassword(String value) {
    _password = value;
    notifyListeners();
  }

  void setConfirmedPassword(String value) {
    _reEnteredPassword = value;
    notifyListeners();
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      "confirmPassword": reEnteredPassword,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      reEnteredPassword: json['confirmPassword'] ?? '',
    );
  }
}
