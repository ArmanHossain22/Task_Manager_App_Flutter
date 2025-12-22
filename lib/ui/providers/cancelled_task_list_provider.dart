import 'package:flutter/material.dart';

import '../../data/models/task_model.dart';
import '../../data/service/network_caller.dart';
import '../../data/utils/urls.dart';

/// Controller
class CancelledTaskListProvider extends ChangeNotifier {
  bool _getCancelledTaskListInProgress = false;
  String? _errorMessage;

  List<TaskModel> _cancelledTaskList = [];

  List<TaskModel> get cancelledTaskList => _cancelledTaskList;
  bool get getCancelledTaskListInProgress => _getCancelledTaskListInProgress;
  String? get errorMessage => _errorMessage;

  Future<bool> getCancelledTaskList() async {
    bool isSuccess = false;

    _getCancelledTaskListInProgress = true;
    notifyListeners();

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getCancelledTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _cancelledTaskList = taskList;

      _errorMessage = null;
      isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _getCancelledTaskListInProgress = false;
    notifyListeners();

    return isSuccess;
  }
}
