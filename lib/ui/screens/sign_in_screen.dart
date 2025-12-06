import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/models/user_model.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/controllers/auth_controller.dart';
import 'package:task_manager/ui/screens/forgot_password_email_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_holder_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = "/sign-in";
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _signInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
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
                    "Get Started With",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    decoration: InputDecoration(
                      hintText: "Email",
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "Email is required";
                      }
                      else if (!EmailValidator.validate(value ?? ""))
                      {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    obscureText: true,
                    controller: _passwordTEController,
                    decoration: InputDecoration(
                      hintText: "Password",
                    ),
                    validator: (String? value){
                      if(value?.isEmpty ?? true)
                      {
                        return "Password is required";
                      }
                      else if (value!.length < 7)
                      {
                        return "Password must be at least 7 characters";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  Visibility(
                    visible: !_signInProgress,
                    replacement: CenterCircularProgress(),
                    child: FilledButton(
                      onPressed: _onTapSignInButton,
                      child: Icon(Icons.arrow_circle_right_outlined )
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        TextButton(
                          onPressed: _onTapForgotPasswordButton,
                          child: Text("Forgot Password?")
                        ),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w500
                            ),
                            text: "Don't have an account? ",
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: Colors.green
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = _onTapSignUpButton
                              )
                            ]
                          )
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          ),
        )
      ),
    );
  }

  void _onTapSignInButton(){
    if(_formKey.currentState!.validate())
    {
      _callSignInAPI();
    }
  }

  Future<void> _callSignInAPI() async
  {
    _signInProgress = true;
    setState(() {

    });

    Map<String, dynamic> requestBody = {
      "email": _emailTEController.text.trim(),
      "password": _passwordTEController.text
    };

    final NetworkResponse response = await NetworkCaller.postRequest(
      Urls.loginUrl,
      body: requestBody
    );

    _signInProgress = true;
    setState(() {

    });

    if(response.isSuccess)
    {
      UserModel userModel = UserModel.fromJson(response.body['data']);
      String accessToken = response.body['token'];
      await AuthController.saveUserData(accessToken, userModel);

      Navigator.pushReplacementNamed(
          context,
          MainBottomNavHolderScreen.name
      );
    }
    else
    {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _onTapForgotPasswordButton(){
    Navigator.pushNamed(
        context,
        ForgotPasswordEmailScreen.name
    );
  }

  void _onTapSignUpButton(){
    Navigator.pushNamed(
        context,
        SignUpScreen.name
    );
  }
}
