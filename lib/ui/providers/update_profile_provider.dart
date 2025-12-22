import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:image_picker/image_picker.dart';

import '../../data/models/user_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/auth_controller.dart';

/// Controller
class UpdateProfileProvider extends ChangeNotifier {
  bool _updateProfileInProgress = false;
  String? _errorMessage;

  bool get updateProfileInProgress => _updateProfileInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> updateProfile(
      String email,
      String firstName,
      String lastName,
      String mobile,
      String password,
      XFile? pickedImage
      ) async {
    bool isSuccess = false;

    _updateProfileInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "email" : email,
      "firstName" : firstName,
      "lastName" : lastName,
      "mobile" : mobile
    };

    if(password.isNotEmpty)
    {
      requestBody["password"] = password;
    }

    if(pickedImage != null)
    {
      /// Image Should be less than 100KB
      Uint8List imageBytes = await pickedImage.readAsBytes();
      requestBody["photo"] = base64Encode(imageBytes);
    }

    final NetworkResponse response = await NetworkCaller.postRequest(
        Urls.updateProfileUrl,
        body: requestBody
    );

    if(response.isSuccess)
    {
      requestBody['_id'] = AuthController.user!.id;
      AuthController.updateUserData(UserModel.fromJson(requestBody));

      _errorMessage = null;
      isSuccess = true;
    }
    else
    {
      _errorMessage = response.errorMessage;
    }

    _updateProfileInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
