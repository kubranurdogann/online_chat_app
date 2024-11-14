import 'package:chat_app/home_page.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/common_widgets.dart';
import 'package:chat_app/consts.dart';
import 'package:chat_app/register.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final GlobalKey<FormState> _SignInFormKey = GlobalKey();
  DatabaseService _dbService = DatabaseService();

  bool isLoading = false;

  String? email, password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Column(children: [
                    header("Login here", "Welcome back. You've been missed!"),
                    SizedBox(
                      height: 50,
                    ),
                    Form(
                        key: _SignInFormKey,
                        child: Column(
                          children: [
                            CustomFormField(
                                hintText: "Email",
                                validationRegEx: EMAIL_VALIDATION_REGEX,
                                onSaved: (value) {
                                  setState(() {
                                    email = value;
                                  });
                                }),
                            CustomFormField(
                                hintText: "Password",
                                validationRegEx: PASSWORD_VALIDATION_REGEX,
                                obscureText: true,
                                onSaved: (value) {
                                  setState(() {
                                    password = value;
                                  });
                                }),
                            button(context, "Sign in", () => signIn()),
                          ],
                        )),
                    button2("Create new account", () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => SignUp()));
                    }),
                    continueWithButtons()
                  ])))),
    );
  }

  void signIn() async {
    setState(() {
      isLoading = true;
    });

    if (_SignInFormKey.currentState?.validate() ?? false) {
      _SignInFormKey.currentState?.save();

      AuthService authService = AuthService();
      bool success = await authService.login(email!, password!);

      if (success) {
        setState(() {
          isLoading = false;
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
        Future.delayed(const Duration(milliseconds: 500), () {
        
        });
      } else {
        setState(() {
          isLoading = false;
        });
        CustomToast(
          message: "Login failed. Try again.",
          icon: Icons.error,
          iconColor: Colors.red,
        ).show(context);
      }
    } else {
      CustomToast(
        message: "Please enter a valid email and password.",
        icon: Icons.error,
        iconColor: Colors.red,
      ).show(context);
    }
  }
}
