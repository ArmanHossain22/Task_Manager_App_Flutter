import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class ProgressTaskListProvider extends ChangeNotifier {
  bool _getProgressTaskListInProgress = false;
  String? _errorMessage;

  List<TaskModel> _progressTaskList = [];

  List<TaskModel> get progressTaskList => _progressTaskList;
  bool get getProgressTaskListInProgress => _getProgressTaskListInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> getProgressTaskList() async {
    bool isSuccess = false;

    _getProgressTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getProgressTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = taskList;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getProgressTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
