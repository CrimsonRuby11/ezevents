import 'package:ezevents/firebase_options.dart';
import 'package:ezevents/pages/loginpage.dart';
import 'package:ezevents/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ezevents/pages/event_proposal.dart';
import 'package:ezevents/pages/venue_booking.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color.fromRGBO(101, 150, 112, 1),
            primary: Color.fromRGBO(101, 150, 112, 1),
            secondary: Color.fromRGBO(141, 129, 103, 1)),
        textTheme: GoogleFonts.montserratTextTheme().copyWith(),
      ),
      home: FirebaseAuth.instance.currentUser != null
          ? MainPage(
              uid: FirebaseAuth.instance.currentUser!.uid,
            )
          : LoginPage(),
    );
  }
}
