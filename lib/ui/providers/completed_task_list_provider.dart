import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class CompletedTaskListProvider extends ChangeNotifier {
  bool _getCompletedTaskListInProgress = false;
  String? _errorMessage;

  List<TaskModel> _completedTaskList = [];

  List<TaskModel> get completedTaskList => _completedTaskList;
  bool get getCompletedTaskListInProgress => _getCompletedTaskListInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> getCompletedTaskList() async {
    bool isSuccess = false;

    _getCompletedTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getCompletedTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = taskList;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCompletedTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
