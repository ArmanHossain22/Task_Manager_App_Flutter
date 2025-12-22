import 'package:flutter/material.dart';

import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class SignUpProvider extends ChangeNotifier {
  bool _signUpInProgress = false;
  String? _errorMessage;

  bool get signUpInProgress => _signUpInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> signUp(
    String email,
    String firstName,
    String lastName,
    String mobile,
    String password,
  ) async {
    bool isSuccess = false;

    _signUpInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email": email,
      "firstName": firstName,
      "lastName": lastName,
      "mobile": mobile,
      "password": password,
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.registrationUrl,
      body: requestBody,
    );

    _signUpInProgress = false;
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
