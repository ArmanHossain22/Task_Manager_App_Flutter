import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_count_model.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  bool _getTaskCountInProgress = false;
  bool _getNewTaskListInProgress = false;
  List<TaskModel> _newTaskList = [];
  List<TaskCountModel> _taskStatusCountList = [];

  @override
  void initState() {
    super.initState();
    _getTaskStatusCountList();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: RefreshIndicator(
          onRefresh: () async {
            _getTaskStatusCountList();
            _getNewTaskList();
          },
          child: Column(
            spacing: 8,
            children: [
              const SizedBox(),
              _buildTaskSummaryListView(),
              Visibility(
                visible: _getNewTaskListInProgress == false,
                replacement: SizedBox(
                  height: 200,
                  child: CenterCircularProgress(),
                ),
                child: ListView.separated(
                  itemCount: _newTaskList.length,
                  primary: false,
                  shrinkWrap: true,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 8);
                  },
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskModel: _newTaskList[index],
                      refreshList: () {
                        _getNewTaskList();
                        _getTaskStatusCountList();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddButton,
        child: Icon(Icons.add),
      ),
    );
  }

  SizedBox _buildTaskSummaryListView() {
    return SizedBox(
      height: 60,
      child: Visibility(
        visible: _getTaskCountInProgress == false,
        replacement: CenterCircularProgress(),
        child: ListView.builder(
          itemCount: _taskStatusCountList.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Card(
              elevation: 0,
              margin: EdgeInsets.only(left: 8),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Text(
                      _taskStatusCountList[index].sum.toString(),
                      style: TextTheme.of(context).titleMedium,
                    ),
                    Text(
                      _taskStatusCountList[index].id,
                      style: TextTheme.of(context).labelSmall,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getTaskStatusCountList() async {
    _getTaskCountInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getTaskStatusCountUrl,
    );

    if (response.isSuccess) {
      List<TaskCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        list.add(TaskCountModel.fromJson(jsonData));
      }
      _taskStatusCountList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getTaskCountInProgress = false;
    setState(() {});
  }

  Future<void> _getNewTaskList() async {
    _getNewTaskListInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getNewTaskListUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> taskList = [];
      for (Map<String, dynamic> jsonData in response.body['data']) {
        taskList.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = taskList;
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }

    _getNewTaskListInProgress = false;
    setState(() {});
  }

  void _onTapAddButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name).then((onValue) {
      _getTaskStatusCountList();
      _getNewTaskList();
    });
  }
}
