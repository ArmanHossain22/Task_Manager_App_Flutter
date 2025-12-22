import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/progress_task_list_provider.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  final ProgressTaskListProvider _progressTaskListProvider = ProgressTaskListProvider();

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_)=> _progressTaskListProvider,
      child: Scaffold(
        body: Consumer(
          builder: (context, ProgressTaskListProvider value, child) {
            return Visibility(
              visible: !_progressTaskListProvider.getProgressTaskListInProgress,
              replacement: CenterCircularProgress(),
              child: ListView.separated(
                itemCount: _progressTaskListProvider.progressTaskList.length,
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: _progressTaskListProvider.progressTaskList[index],
                    refreshList: () {
                      _getProgressTaskList();
                    },
                  );
                },
              ),
            );
          }
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    final bool isSuccess = await _progressTaskListProvider.getProgressTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _progressTaskListProvider.errorMessage!);
    }
  }
}
