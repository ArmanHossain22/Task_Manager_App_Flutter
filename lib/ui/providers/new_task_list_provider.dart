import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class NewTaskListProvider extends ChangeNotifier {
  bool _getNewTaskListInProgress = false;
  String? _errorMessage;

  List<TaskModel> _newTaskList = [];

  List<TaskModel> get newTaskList => _newTaskList;
  bool get getNewTaskListInProgress => _getNewTaskListInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> getNewTaskList() async {
    bool isSuccess = false;

    _getNewTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getNewTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = taskList;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getNewTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
