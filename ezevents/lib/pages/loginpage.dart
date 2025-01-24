import 'package:ezevents/pages/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();

  bool isLogin = true;

  register() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fields should not be empty!"),
        ),
      );

      return;
    }

    String email = emailController.text;
    String pass = passController.text;

    final firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: pass);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Registered Successfully!"),
      ));

      setState(() {
        isLogin = true;
      });

      // Navigator.of(context).pushAndRemoveUntil(
      //   MaterialPageRoute(
      //     builder: (context) => LoginPage(),
      //   ),
      //   (route) => false,
      // );
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Registration Error!"),
        ),
      );
    }
  }

  login() async {
    if (emailController.text.isEmpty || passController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fields should not be empty!"),
        ),
      );

      return;
    }

    String email = emailController.text;
    String pass = passController.text;

    final firebaseAuth = FirebaseAuth.instance;

    try {
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: pass);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => MainPage(
            uid: userCredential.user!.uid,
          ),
        ),
        (route) => false,
      );
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Login Error!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? loginPage() : registerPage();
  }

  registerPage() {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Register with EzEvents!",
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(hintText: "Password"),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: register,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 90),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Register",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogin = true;
                  });
                },
                child: Text(
                  "Already a member? Sign in here!",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  loginPage() {
    return Scaffold(
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Welcome to EzEvents!",
                style: TextStyle(fontSize: 40),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: emailController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(hintText: "Email"),
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: passController,
                onTapOutside: (event) =>
                    FocusManager.instance.primaryFocus?.unfocus(),
                decoration: InputDecoration(hintText: "Password"),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: login,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 90),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10)),
                  child: Text(
                    "Continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isLogin = false;
                  });
                },
                child: Text(
                  "Not a member yet? Register here!",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
