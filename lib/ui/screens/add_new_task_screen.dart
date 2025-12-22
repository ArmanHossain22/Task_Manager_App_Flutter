import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/add_new_task_provider.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class AddNewTaskScreen extends StatefulWidget {
  const AddNewTaskScreen({super.key});

  static const String name = "add-new-task";
  @override
  State<AddNewTaskScreen> createState() => _AddNewTaskScreenState();
}

class _AddNewTaskScreenState extends State<AddNewTaskScreen> {
  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final AddNewTaskProvider _addNewTaskProvider = AddNewTaskProvider();
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _addNewTaskProvider,
      child: Scaffold(
        appBar: TMAppBar(),
        body: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 36),
                  Text(
                    "Add New Task",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _titleTEController,
                    decoration: InputDecoration(
                      hintText: "Subject",
                    ),
                    validator: (String? value)
                    {
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "Subject is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionTEController,
                    decoration: InputDecoration(
                      hintText: "Description",
                    ),
                    maxLines: 5,
                    validator: (String? value)
                    {
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "Description is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, AddNewTaskProvider value, child){
                      return Visibility(
                        visible: !_addNewTaskProvider.getAddNewTaskInProgress,
                        replacement: CenterCircularProgress(),
                        child: FilledButton(
                            onPressed: _onTapCreateButton,
                            child: Icon(Icons.arrow_circle_right_outlined )
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
        )
      ),
    );
  }

  void _onTapCreateButton(){
    if(_formKey.currentState!.validate())
    {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async
  {
    final bool isSuccess = await _addNewTaskProvider.addNewTask(
      _titleTEController.text.trim(),
      _descriptionTEController.text.trim()
    );

    if(isSuccess)
    {
      _clearTextFields();
      showSnackBarMessage(context, "New Task Added!");
    }
    else
    {
      showSnackBarMessage(context, _addNewTaskProvider.errorMessage!);
    }
  }

  void _clearTextFields()
  {
    _titleTEController.clear();
    _descriptionTEController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}
