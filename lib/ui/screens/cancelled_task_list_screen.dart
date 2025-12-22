import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/cancelled_task_list_provider.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/task_card.dart';

import '../widgets/snack_bar_message.dart';

class CancelledTaskListScreen extends StatefulWidget {
  const CancelledTaskListScreen({super.key});

  @override
  State<CancelledTaskListScreen> createState() =>
      _CancelledTaskListScreenState();
}

class _CancelledTaskListScreenState extends State<CancelledTaskListScreen> {
  final CancelledTaskListProvider _cancelledTaskListProvider = CancelledTaskListProvider();

  @override
  void initState() {
    super.initState();
    _getCancelledTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _cancelledTaskListProvider,
      child: Scaffold(
        body: Consumer(
          builder: (context, CancelledTaskListProvider value, child){
            return Visibility(
              visible: !_cancelledTaskListProvider.getCancelledTaskListInProgress,
              replacement: CenterCircularProgress(),
              child: ListView.separated(
                itemCount: _cancelledTaskListProvider.cancelledTaskList.length,
                primary: false,
                shrinkWrap: true,
                separatorBuilder: (context, index) {
                  return SizedBox(height: 8);
                },
                itemBuilder: (context, index) {
                  return TaskCard(
                    taskModel: _cancelledTaskListProvider.cancelledTaskList[index],
                    refreshList: () {
                      _getCancelledTaskList();
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

  Future<void> _getCancelledTaskList() async {
    final bool isSuccess = await _cancelledTaskListProvider.getCancelledTaskList();
    if (!isSuccess) {
      showSnackBarMessage(context, _cancelledTaskListProvider.errorMessage!);
    }
  }
}
