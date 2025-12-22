import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/reset_password_provider.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  final String email;
  final String otp;
  static const String name = "/reset-password";
  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ResetPasswordProvider _resetPasswordProvider = ResetPasswordProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _resetPasswordProvider,
      child: Scaffold(
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
                    "Set Password",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "Minimum length password 8 characters with Latter and number combination",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(hintText: "Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      } else if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTEController,
                    decoration: InputDecoration(hintText: "Confirm Password"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Confirm Password is required";
                      } else if (value.length < 6) {
                        return "Confirm Password must be at least 6 characters";
                      } else if (value != _passwordTEController.text) {
                        return "Password doesn't match";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder: (context, ResetPasswordProvider value, child){
                      return Visibility(
                        visible: !_resetPasswordProvider.resetPasswordInProgress,
                        replacement: CenterCircularProgress(),
                        child: FilledButton(
                          onPressed: _onTapSubmitButton,
                          child: Text("Submit"),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                            text: "Have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign In",
                                style: TextStyle(color: Colors.green),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignInButton,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      SignInScreen.name,
      (predicate) => false,
    );
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _resetPassword();
    }
  }

  Future<void> _resetPassword() async {
    final bool isSuccess = await _resetPasswordProvider.resetPassword(
      widget.email,
      widget.otp,
      _passwordTEController.text,
    );

    if (isSuccess) {
      showSnackBarMessage(context, "Password reset successfully");
      Navigator.pushNamedAndRemoveUntil(
        context,
        SignInScreen.name,
        (predicate) => false,
      );
    } else {
      showSnackBarMessage(context, _resetPasswordProvider.errorMessage!);
    }
  }
}
