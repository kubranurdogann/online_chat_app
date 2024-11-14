import 'dart:io';
import 'package:chat_app/common_widgets.dart';
import 'package:chat_app/consts.dart';
import 'package:chat_app/models/user_profile.dart';
import 'package:chat_app/services/alert_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/services/media_service.dart';
import 'package:chat_app/services/storage_service.dart';
import 'package:chat_app/signin_page.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  File? selectedImage;
  Uint8List? selectedImageBytes;
  bool isLoading = false;

  final GlobalKey<FormState> _signUpFormKey = GlobalKey();

  String? name, email, password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          width: MediaQuery.sizeOf(context).width,
          child: SafeArea(
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  child: Column(children: [
                    header("Create Account",
                        "Create an account so you can explore all the existing jobs "),
                    if (!isLoading)
                      Form(
                          key: _signUpFormKey,
                          child: Column(
                            children: [
                              _SelectImage(),
                              CustomFormField(
                                  hintText: "Name",
                                  validationRegEx: NAME_VALIDATION_REGEX,
                                  onSaved: (value) {
                                    setState(() {
                                      name = value;
                                    });
                                  }),
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
                              button(context, "Sign up", () => SignUp()),
                            ],
                          )),
                    if (!isLoading)
                      button2("Already have an accont", () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => SignIn()));
                      }),
                    if (!isLoading) continueWithButtons(),
                    if (isLoading)
                      Expanded(
                          child: Center(
                        child: CircularProgressIndicator(),
                      )),
                  ])))),
    );
  }

  Widget _SelectImage() {
    return GestureDetector(
      onTap: () async {
        MediaService _mediaService = MediaService();
        dynamic image = await _mediaService.pickImage();

        if (image != null && kIsWeb) {
          // Web'de Uint8List tipindeki resmi setState ile widget'a aktar
          setState(() {
            selectedImageBytes = image; // Uint8List
          });
        } else if (image != null) {
          // Mobilde File tipindeki resmi işleyebilirsin
          setState(() {
            selectedImage = image; // File
          });
        }
      },
      child: Stack(children: [
        CircleAvatar(
          radius: MediaQuery.of(context).size.width * 0.15,
          backgroundImage: kIsWeb
              ? (selectedImageBytes != null
                  ? MemoryImage(selectedImageBytes!)
                  : NetworkImage(PLACEHOLDER_PFP))
              : (selectedImage != null
                  ? FileImage(selectedImage!)
                  : NetworkImage(PLACEHOLDER_PFP)) as ImageProvider,
        ),
        Positioned(
          child: Icon(Icons.add_a_photo),
          bottom: 10,
          right: 10,
        ),
      ]),
    );
  }
void SignUp() async {
  setState(() {
    isLoading = true;
  });

  try {
    if ((_signUpFormKey.currentState?.validate() ?? false) &&
        (selectedImage != null || selectedImageBytes != null)) {
      _signUpFormKey.currentState?.save();

      AuthService _auth = AuthService();
      bool result = await _auth.register(email!, password!);

      if (result) {
        StorageService _storage = StorageService();
        String? picUrl;

        if (kIsWeb) {
          if (selectedImageBytes != null) {
            picUrl = await _storage.uploadUserPicBytes(
                file: selectedImageBytes!, uid: _auth.user!.uid);
          }
        } else {
          if (selectedImage != null) {
            picUrl = await _storage.uploadUserPic(
                file: selectedImage!, uid: _auth.user!.uid);
          }
        }

        if (picUrl != null) {
          DatabaseService _databaseService = DatabaseService();
          await _databaseService.createUserProfile(
              user: UserProfile(
                  uid: _auth.user!.uid, name: name, pfpURL: picUrl));
          CustomToast(
            message: "User Registered. Please Login",
            icon: Icons.check_circle,
            iconColor: Colors.green,
          ).show(context);

          Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SignIn()));
        } else {
          print("Failed to upload profile picture.");
        }
      } else {
        CustomToast(
          message: "User registration failed. Please try again.",
          icon: Icons.error,
          iconColor: Colors.red,
        ).show(context);
      }
    } else {
      if (selectedImage == null && selectedImageBytes == null) {
        CustomToast(
          message: "Please select an image",
          icon: Icons.error,
          iconColor: Colors.red,
        ).show(context);
      }
      print("Form is not valid.");
    }
  } catch (e) {
    CustomToast(
      message: "During sign up $e",
      icon: Icons.error,
      iconColor: Colors.red,
    ).show(context);
  }

  setState(() {
    isLoading = false;
  });
}

}
