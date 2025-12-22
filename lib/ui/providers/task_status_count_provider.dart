import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_count_model.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class TaskStatusCountProvider extends ChangeNotifier {
  bool _getTaskCountInProgress = false;
  String? _errorMessage;

  List<TaskCountModel> _taskStatusCountList = [];

  List<TaskCountModel> get taskStatusCountList => _taskStatusCountList;
  bool get getTaskCountInProgress => _getTaskCountInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> getTaskStatusCountList() async {
    bool isSuccess = false;

    _getTaskCountInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getTaskStatusCountUrl,
    );

    if (response.isSuccess) {
      List<TaskCountModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = taskList;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getTaskCountInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
