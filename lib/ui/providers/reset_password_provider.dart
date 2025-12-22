import 'package:flutter/material.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class ResetPasswordProvider extends ChangeNotifier {
  bool _resetPasswordInProgress = false;
  String? _errorMessage;

  bool get resetPasswordInProgress => _resetPasswordInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> resetPassword(String email, String otp, String password) async {
    bool isSuccess = false;

    _resetPasswordInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "otp": otp,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.recoveryResetPassword,
      body: requestBody,
    );

    _resetPasswordInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }
}
