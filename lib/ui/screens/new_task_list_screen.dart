import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/new_task_list_provider.dart';
import 'package:task_manager/ui/providers/task_status_count_provider.dart';
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
  final TaskStatusCountProvider _taskStatusCountProvider = TaskStatusCountProvider();
  final NewTaskListProvider _newTaskListProvider = NewTaskListProvider();

  @override
  void initState() {
    super.initState();
    _getTaskStatusCountList();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => _taskStatusCountProvider),
        ChangeNotifierProvider(create: (_) => _newTaskListProvider),
      ],
      child: Scaffold(
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
                Consumer(
                  builder: (context, NewTaskListProvider value, child) {
                    return Visibility(
                      visible: !_newTaskListProvider.getNewTaskListInProgress,
                      replacement: SizedBox(
                        height: 200,
                        child: CenterCircularProgress(),
                      ),
                      child: ListView.separated(
                        itemCount: _newTaskListProvider.newTaskList.length,
                        primary: false,
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 8);
                        },
                        itemBuilder: (context, index) {
                          return TaskCard(
                            taskModel: _newTaskListProvider.newTaskList[index],
                            refreshList: () {
                              _getNewTaskList();
                              _getTaskStatusCountList();
                            },
                          );
                        },
                      ),
                    );
                  }
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _onTapAddButton,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  SizedBox _buildTaskSummaryListView() {
    return SizedBox(
      height: 60,
      child: Consumer(
        builder: (context, TaskStatusCountProvider value, child){
          return Visibility(
            visible: !_taskStatusCountProvider.getTaskCountInProgress,
            replacement: CenterCircularProgress(),
            child: ListView.builder(
              itemCount: _taskStatusCountProvider.taskStatusCountList.length,
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
                          _taskStatusCountProvider.taskStatusCountList[index].sum.toString(),
                          style: TextTheme.of(context).titleMedium,
                        ),
                        Text(
                          _taskStatusCountProvider.taskStatusCountList[index].id,
                          style: TextTheme.of(context).labelSmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _getTaskStatusCountList() async {
    final bool isSuccess = await _taskStatusCountProvider.getTaskStatusCountList();
    if (!isSuccess) {
      showSnackBarMessage(context, _taskStatusCountProvider.errorMessage!);
    }
  }

  void _onTapAddButton() {
    Navigator.pushNamed(context, AddNewTaskScreen.name).then((onValue) {
      _getTaskStatusCountList();
      _getNewTaskList();
    });
  }

  Future<void> _getNewTaskList() async {
    final bool isSuccess = await _newTaskListProvider.getNewTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _newTaskListProvider.errorMessage!);
    }
  }
}
