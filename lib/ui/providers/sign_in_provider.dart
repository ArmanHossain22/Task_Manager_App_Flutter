import 'package:flutter/material.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';

/// Controller
class SignInProvider extends ChangeNotifier {
  bool _signInProgress = false;
  String? _errorMessage;

  bool get signInInProgress => _signInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    bool isSuccess = false;

    _signInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {"email": email, "password": password};

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.loginUrl,
      body: requestBody,
    );

    _signInProgress = false;
    notifyListeners();

    if (response.isSuccess) {
      UserModel userModel = UserModel.fromJson(response.body['data']);
      String accessToken = response.body['token'];
      await AuthController.saveUserData(accessToken, userModel);

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    return isSuccess;
  }
}
