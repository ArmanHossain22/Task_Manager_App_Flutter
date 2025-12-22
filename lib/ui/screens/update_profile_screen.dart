import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/providers/update_profile_provider.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/photo_picker.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = "/update-profile";
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _pickedImage;

  final UpdateProfileProvider _updateProfileProvider = UpdateProfileProvider();

  @override
  void initState() {
    super.initState();
    final UserModel userModel = AuthController.user!;
    _emailTEController.text = userModel.email;
    _firstNameTEController.text = userModel.firstName;
    _lastNameTEController.text = userModel.lastName;
    _mobileTEController.text = userModel.mobile;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _updateProfileProvider,
      child: Scaffold(
        appBar: TMAppBar(isFromUpdateProfile: true),
        body: ScreenBackground(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 60),
                  Text(
                    "Update Profile",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: PhotoPicker(pickedImage: _pickedImage),
                  ),
                  TextFormField(
                    enabled: false,
                    controller: _emailTEController,
                    decoration: InputDecoration(hintText: "Email"),
                  ),
                  TextFormField(
                    controller: _firstNameTEController,
                    decoration: InputDecoration(hintText: "First Name"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "First name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(hintText: "Last Name"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Last name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: InputDecoration(hintText: "Mobile"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Mobile is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: "Password"),
                    validator: (value) {
                      String password = value ?? "";
                      if (password.isNotEmpty && password.length < 6) {
                        return "Password have to be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, UpdateProfileProvider value, child){
                      return Visibility(
                        visible: !_updateProfileProvider.updateProfileInProgress,
                        replacement: CenterCircularProgress(),
                        child: FilledButton(
                          onPressed: _onTapUpdateButton,
                          child: Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    XFile? image = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      _pickedImage = image;
      setState(() {});
    }
  }

  void _onTapUpdateButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    final bool isSuccess = await _updateProfileProvider.updateProfile(
      _emailTEController.text.trim(),
      _firstNameTEController.text.trim(),
      _lastNameTEController.text.trim(),
      _mobileTEController.text.trim(),
      _passwordTEController.text,
      _pickedImage,
    );

    if (isSuccess) {
      showSnackBarMessage(context, "Profile Updated");
    } else {
      showSnackBarMessage(context, _updateProfileProvider.errorMessage!);
    }
  }
}
