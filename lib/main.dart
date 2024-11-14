import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/signin_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  await setup();
  runApp(const MyApp());
}

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
    try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,  // currentPlatform platformu otomatik tanır
    );
    print("Firebase başarıyla başlatıldı.");
  } catch (e) {
    print("Firebase başlatılamadı: $e");
  }
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.quicksandTextTheme()
        ),
      home: SignIn(),
    );
  }
}