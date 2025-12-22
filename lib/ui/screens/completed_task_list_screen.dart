import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/completed_task_list_provider.dart';
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
  final CompletedTaskListProvider _completedTaskListProvider = CompletedTaskListProvider();

  @override
  void initState() {
    super.initState();
    _getCompletedTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _completedTaskListProvider,
      child: Scaffold(
        body: Consumer(
          builder: (context, CompletedTaskListProvider value, child){
            return Visibility(
              visible: !_completedTaskListProvider.getCompletedTaskListInProgress,
              replacement: CenterCircularProgress(),
              child: ListView.separated(
                itemCount: _completedTaskListProvider.completedTaskList.length,
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: _completedTaskListProvider.completedTaskList[index],
                    refreshList: () {
                      _getCompletedTaskList();
                    },
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _getCompletedTaskList() async {
    final bool isSuccess = await _completedTaskListProvider.getCompletedTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _completedTaskListProvider.errorMessage!);
    }
  }
}
