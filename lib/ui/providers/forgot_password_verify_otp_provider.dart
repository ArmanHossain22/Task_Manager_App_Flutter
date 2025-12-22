import 'package:flutter/material.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class ForgotPasswordVerifyOtpProvider extends ChangeNotifier {
  bool _verifyOtpInProgress = false;
  String? _errorMessage;

  bool get verifyOtpInProgress => _verifyOtpInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> verifyOtp(String email, String otp) async {
    bool isSuccess = false;

    _verifyOtpInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getRecoverVerifyOtpUrl(email, otp),
    );

    _verifyOtpInProgress = false;
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
