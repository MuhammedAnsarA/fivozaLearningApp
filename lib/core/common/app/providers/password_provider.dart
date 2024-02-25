import 'package:flutter/material.dart';

class PasswordProvider with ChangeNotifier {
  bool _passwordVisible = true;

  bool get passwordVisible => _passwordVisible;

  void togglePasswordVisibility() {
    _passwordVisible = !_passwordVisible;
    notifyListeners();
  }
}
