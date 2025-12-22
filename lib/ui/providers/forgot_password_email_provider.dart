import 'package:flutter/material.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class ForgotPasswordEmailProvider extends ChangeNotifier {
  bool _forgotPasswordInProgress = false;
  String? _errorMessage;

  bool get forgotPasswordInProgress => _forgotPasswordInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> forgotPasswordRecovery(String email) async {
    bool isSuccess = false;

    _forgotPasswordInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getForgotPasswordUrl(email),
    );

    _forgotPasswordInProgress = false;
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
