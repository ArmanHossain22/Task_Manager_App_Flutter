import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/data/service/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const String name = "/sign-up";
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _signUpInProgress = false;

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
                    "Join With Us",
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
                    controller: _firstNameTEController,
                    decoration: InputDecoration(
                      hintText: "First Name",
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "First name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _lastNameTEController,
                    decoration: InputDecoration(
                      hintText: "Last Name",
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "Last name is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _mobileTEController,
                    decoration: InputDecoration(
                      hintText: "Mobile",
                    ),
                    validator: (String? value){
                      if(value?.trim().isEmpty ?? true)
                      {
                        return "Mobile is required";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: true,
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
                    visible: !_signUpInProgress,
                    replacement: CenterCircularProgress(),
                    child: FilledButton(
                        onPressed: _onTapSignUpButton,
                        child: Icon(Icons.arrow_circle_right_outlined )
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: Column(
                      children: [
                        RichText(
                            text: TextSpan(
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w500
                                ),
                                text: "Already have an account? ",
                                children: [
                                  TextSpan(
                                      text: "Sign In",
                                      style: TextStyle(
                                          color: Colors.green
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = _onTapSignInButton
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
    Navigator.pushNamed(context, SignInScreen.name);
  }

  void _onTapSignUpButton(){
    if(_formKey.currentState!.validate())
    {
      _signUp();
    }
  }

  Future<void> _signUp() async
  {
    _signUpInProgress = true;
    setState(() {

    });

    Map<String, dynamic> requestBody = {
      "email" : _emailTEController.text.trim(),
      "firstName" : _firstNameTEController.text.trim(),
      "lastName" : _lastNameTEController.text.trim(),
      "mobile" : _mobileTEController.text.trim(),
      "password" : _passwordTEController.text
    };

    NetworkResponse response = await NetworkCaller.postRequest(
      Urls.registrationUrl,
      body: requestBody,
    );

    _signUpInProgress = false;
    setState(() {

    });

    if(response.isSuccess)
    {
      _clearTextFields();
      showSnackBarMessage(context, "Registration Successful! Please Sign in.");
    }
    else
    {
      showSnackBarMessage(context, response.errorMessage);
    }
  }

  void _clearTextFields()
  {
    _emailTEController.clear();
    _firstNameTEController.clear();
    _lastNameTEController.clear();
    _mobileTEController.clear();
    _passwordTEController.clear();
  }

  @override
  void dispose() {

    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
