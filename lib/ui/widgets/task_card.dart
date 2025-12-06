import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class TaskCard extends StatefulWidget {
  final TaskModel taskModel;
  final VoidCallback refreshList;

  const TaskCard({
    super.key,
    required this.taskModel,
    required this.refreshList,
  });

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _changeStatusInProgress = false;
  bool _deleteTaskInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        tileColor: Colors.white,
        title: Text(widget.taskModel.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.taskModel.description,
              style: TextStyle(color: Colors.grey),
            ),
            Text("Date: ${widget.taskModel.createdDate}"),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getTaskStatusColor(widget.taskModel.status),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    widget.taskModel.status,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Spacer(),
                Visibility(
                  visible: !_changeStatusInProgress,
                  replacement: CenterCircularProgress(),
                  child: IconButton(
                    onPressed: _showChangeStatusDialog,
                    icon: Icon(Icons.edit, color: Colors.grey),
                  ),
                ),
                Visibility(
                  visible: !_deleteTaskInProgress,
                  replacement: CenterCircularProgress(),
                  child: IconButton(
                    onPressed: _deleteTask,
                    icon: Icon(Icons.delete, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showChangeStatusDialog() {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Change Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("New"),
                trailing: Icon(_isCurrentStatus("New") ? Icons.done : null),
                onTap: () {
                  _onTapChangeTaskType("New");
                },
              ),
              ListTile(
                title: Text("Progress"),
                trailing: Icon(
                  _isCurrentStatus("Progress") ? Icons.done : null,
                ),
                onTap: () {
                  _onTapChangeTaskType("Progress");
                },
              ),
              ListTile(
                title: Text("Cancelled"),
                trailing: Icon(
                  _isCurrentStatus("Cancelled") ? Icons.done : null,
                ),
                onTap: () {
                  _onTapChangeTaskType("Cancelled");
                },
              ),
              ListTile(
                title: Text("Completed"),
                trailing: Icon(
                  _isCurrentStatus("Completed") ? Icons.done : null,
                ),
                onTap: () {
                  _onTapChangeTaskType("Completed");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _onTapChangeTaskType(String status) {
    if (_isCurrentStatus(status)) {
      return;
    }
    Navigator.pop(context);
    _changeStatus(status);
  }

  bool _isCurrentStatus(String status) {
    return widget.taskModel.status == status;
  }

  Future<void> _changeStatus(String status) async {
    _changeStatusInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getTaskStatusUrl(widget.taskModel.id, status),
    );

    if (response.isSuccess) {
      widget.refreshList();
    } else {
      _changeStatusInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Future<void> _deleteTask() async {
    _deleteTaskInProgress = true;
    setState(() {});

    final NetworkResponse response = await NetworkCaller.getRequest(
      Urls.getDeleteTaskUrl(widget.taskModel.id),
    );

    if (response.isSuccess) {
      widget.refreshList();
    } else {
      _deleteTaskInProgress = false;
      setState(() {});
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  Color _getTaskStatusColor(String status)
  {
    switch(status) {
      case "New":
        return Colors.blue;
      case "Progress":
        return Colors.amber;
      case "Cancelled":
        return Colors.red;
      case "Completed":
        return Colors.green;
      default:
        return Colors.pink;
    }
  }
}
