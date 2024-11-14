import 'package:flutter/material.dart';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final RegExp validationRegEx;
  final void Function(String?) onSaved;
  final bool obscureText;

  const CustomFormField({
    super.key,
    required this.hintText,
    required this.validationRegEx,
    required this.onSaved,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        child: TextFormField(
          onSaved: onSaved,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hintText,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "This field cannot be empty";
            }
            if (!validationRegEx.hasMatch(value)) {
              return "Enter valid ${hintText.toUpperCase()}";
            }
            return null;
          },
        ),
      ),
    );
  }
}

Widget header(String title, String subtitle) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Text(
        title,
        style: TextStyle(
            fontSize: 35,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 84, 29, 186)),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Text(
            textAlign: TextAlign.center,
            subtitle,
            style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w500,
                color: Colors.black)),
      ),
    ],
  );
}

Widget forgotPasswordButton() {
  return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
    TextButton(
      onPressed: () {},
      child: Text(
        "Forgot password?",
        style: TextStyle(
          fontSize: 15,
          color: Color.fromARGB(255, 84, 29, 186),
        ),
      ),
    ),
  ]);
}

Widget button(BuildContext context, text, onPressed) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 25),
    child: SizedBox(
        width: MediaQuery.sizeOf(context).width,
        height: 40,
        child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 84, 29, 186),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10), // Border radius değeri
              ),
            ),
            child: Text(
              "$text",
              style: TextStyle(color: Colors.white, fontSize: 17),
            ))),
  );
}

Widget button2(String text, VoidCallback onPressed) {
  return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(color: Colors.black, fontSize: 17),
      ));
}

Widget continueWithButtons() {
  return Column(
    children: [
      SizedBox(
        height: 10,
      ),
      Text(
        "or continue with",
        style: TextStyle(color: Color.fromARGB(255, 84, 29, 186), fontSize: 15),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 216, 233),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    '../lib/images/google-logo.png',
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 216, 233),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    '../lib/images/facebook-logo.png',
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Container(
                width: 50,
                height: 40,
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 216, 216, 233),
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                    '../lib/images/apple-logo.png',
                  ),
                )),
          ),
        ],
      )
    ],
  );
}
