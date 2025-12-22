import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class AddNewTaskProvider extends ChangeNotifier {
  bool _addNewTaskInProgress = false;
  String? _errorMessage;

  bool get getAddNewTaskInProgress => _addNewTaskInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> addNewTask(String title, String description) async {
    bool isSuccess = false;

    _addNewTaskInProgress = true;
    notifyListeners();

    Map<String, dynamic> requestBody = {
      "title" : title,
      "description" : description,
      "status" : "New"
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
        Urls.createNewTaskUrl,
        body: requestBody
    );

    if (response.isSuccess) {
      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _addNewTaskInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
