import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:task_manager/ui/providers/forgot_password_verify_otp_provider.dart';
import 'package:task_manager/ui/screens/reset_password_screen.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/widgets/center_circular_progress.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

class ForgotPasswordVerifyOtpScreen extends StatefulWidget {
  const ForgotPasswordVerifyOtpScreen({super.key, required this.email});

  final String email;
  static const String name = "/forgot-password-verify-otp";
  @override
  State<ForgotPasswordVerifyOtpScreen> createState() =>
      _ForgotPasswordVerifyOtpScreenState();
}

class _ForgotPasswordVerifyOtpScreenState
    extends State<ForgotPasswordVerifyOtpScreen> {
  final TextEditingController _otpTEController = TextEditingController();
  final StreamController<ErrorAnimationType> errorController =
      StreamController<ErrorAnimationType>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final ForgotPasswordVerifyOtpProvider _forgotPasswordVerifyOtpProvider =
      ForgotPasswordVerifyOtpProvider();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => _forgotPasswordVerifyOtpProvider,
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
                    "OTP Verification",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    "A 6 digit verification OTP will has been sent to your email address",
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  PinCodeTextField(
                    controller: _otpTEController,
                    errorAnimationController: errorController,
                    length: 6,
                    obscureText: false,
                    keyboardType: TextInputType.number,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(5),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.white,
                      inactiveFillColor: Colors.white,
                      selectedFillColor: Colors.white,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    backgroundColor: Colors.transparent,
                    enableActiveFill: true,
                    appContext: context,
                    beforeTextPaste: (text) {
                      return true;
                    },
                    validator: (value) {
                      if (value == null || value.length < 6) {
                        return "OTP Missing";
                      } else {
                        return null;
                      }
                    },
                  ),
                  const SizedBox(height: 8),
                  Consumer(
                    builder:(context, ForgotPasswordVerifyOtpProvider value, child)
                    {
                      return Visibility(
                        visible: !_forgotPasswordVerifyOtpProvider
                            .verifyOtpInProgress,
                        replacement: CenterCircularProgress(),
                        child: FilledButton(
                          onPressed: _onTapVerifyButton,
                          child: Text("Verify"),
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
                            text: "Have account? ",
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

  void _onTapVerifyButton() {
    if (_formKey.currentState!.validate()) {
      _verifyOtp();
    } else {
      errorController.add(ErrorAnimationType.shake);
    }
  }

  Future<void> _verifyOtp() async {
    String otp = _otpTEController.text;
    final bool isSuccess = await _forgotPasswordVerifyOtpProvider.verifyOtp(
      widget.email,
      otp,
    );

    if (isSuccess) {
      showSnackBarMessage(context, "OTP Verified");
      Navigator.pushNamed(
        context,
        ResetPasswordScreen.name,
        arguments: {"email": widget.email, "otp": otp},
      );
    } else {
      showSnackBarMessage(
        context,
        _forgotPasswordVerifyOtpProvider.errorMessage!,
      );
    }
  }
}
