import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class CompletedTaskListScreen extends StatefulWidget {
  const CompletedTaskListScreen({super.key});

  @override
  State<CompletedTaskListScreen> createState() =>
      _CompletedTaskListScreenState();
}

class _CompletedTaskListScreenState extends State<CompletedTaskListScreen> {
  bool _getCompletedTaskListInProgress = false;
  List<TaskModel> _completedTaskList = [];

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Visibility(
        visible: _getCompletedTaskListInProgress == false,
        replacement: SizedBox(height: 200, child: CenterCircularProgress()),
        child: ListView.separated(
          itemCount: _completedTaskList.length,
          primary: false,
          shrinkWrap: true,
          separatorBuilder: (context, index) {
            return SizedBox(height: 8);
          },
          itemBuilder: (context, index) {
            return TaskCard(
              taskModel: _completedTaskList[index],
              refreshList: () {
                _getCompletedTaskList();
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    _getCompletedTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getCompletedTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getCompletedTaskListInProgress = false;
    setState(() {});
  }
}
