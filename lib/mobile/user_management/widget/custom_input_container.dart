import 'package:flutter/material.dart';
import 'package:websocket_mobile/mobile/user_management/screen/forgot_password_screen.dart';
import 'package:websocket_mobile/mobile/user_management/service/user_service.dart';
import 'package:websocket_mobile/mobile/user_management/service/validation_service.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_button.dart';
import 'package:websocket_mobile/mobile/user_management/widget/custom_text_input.dart';

class CustomInputContainer extends StatefulWidget {
  CustomInputContainer({
    required this.usernameController,
    required this.passwordController,
    required this.isLogin,
    required this.onPressed,
    required this.enabled,
    this.confirmPasswordController,
    this.emailController,
    Key? key,
  }) : super(key: key);
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final TextEditingController? emailController;
  final bool isLogin;
  final void Function() onPressed;
  bool enabled;

  @override
  State<CustomInputContainer> createState() => _CustomInputContainerState();
}

class _CustomInputContainerState extends State<CustomInputContainer> {
  final formKey = GlobalKey<FormState>();
  UserService userService = UserService();
  ValidationService validationService = ValidationService();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.enabled) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.brown,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: GestureDetector(
              onTap: () {
                // its needed so the context wont pop on a tap on the container
              },
              child: SingleChildScrollView(
                clipBehavior: Clip.none,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.white70,
                        spreadRadius: 3,
                        offset: Offset(1.5, 3),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextInput(
                            hint: 'username',
                            controller: widget.usernameController,
                            validator: ValidationService.validateUsername(
                              widget.usernameController.text,
                            ),
                          ),
                          CustomTextInput(
                            hint: 'password',
                            controller: widget.passwordController,
                            isPassword: true,
                            validator: widget.isLogin
                                ? ValidationService.validateLoginPassword(
                                    widget.passwordController.text,
                                  )
                                : ValidationService.validateRegisterPassword(
                                    widget.passwordController.text,
                                  ),
                          ),
                          if (!widget.isLogin)
                            CustomTextInput(
                              hint: 'confirm password',
                              controller: widget.confirmPasswordController!,
                              isPassword: true,
                              validator:
                                  ValidationService.validateConfirmPassword(
                                widget.passwordController.text,
                                widget.confirmPasswordController!.text,
                              ),
                            ),
                          if (!widget.isLogin)
                            CustomTextInput(
                              hint: 'email',
                              controller: widget.emailController!,
                              keyboardType: TextInputType.emailAddress,
                              validator: ValidationService.validateEmail(
                                widget.emailController!.text,
                              ),
                            ),
                          if (widget.isLogin)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pushNamed(
                                    context,
                                    ForgotPasswordScreen.routeName,
                                  );
                                },
                                child: const Text(
                                  'Forgot password',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Colors.brown,
                                  ),
                                ),
                              ),
                            ),
                          Padding(
                            padding: EdgeInsets.only(
                              top: widget.isLogin ? 0.0 : 20.0,
                            ),
                            child: CustomButton(
                              enabled: widget.enabled,
                              onPressed: () async {
                                if (!widget.enabled) return;
                                setState(() {
                                  widget.enabled = false;
                                });
                                if (formKey.currentState!.validate()) {
                                  widget.onPressed();
                                  //enabled = true;
                                } else {
                                  widget.enabled = true;
                                }
                                setState(() {});
                              },
                              width: MediaQuery.of(context).size.width * 0.5,
                              text: widget.isLogin ? 'Login' : 'Register',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
