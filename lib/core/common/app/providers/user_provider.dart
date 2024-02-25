import 'package:fivoza_learning/features/auth/data/models/user_model.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  LocalUserModel? _user;

  LocalUserModel? get user => _user;

  void initUser(LocalUserModel? user) {
    if (_user != user) _user = user;
  }

  set user(LocalUserModel? user) {
    if (_user != user) {
      _user = user;
      Future.delayed(Duration.zero, notifyListeners);
    }
  }
}
