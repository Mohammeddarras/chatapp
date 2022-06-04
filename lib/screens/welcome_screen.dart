import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {

  static const String id = "welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override

  void getCurrentUser() async {
    var user = await FirebaseAuth.instance.currentUser;
    if (user != null) {
      Navigator.pushNamed(context, ChatScreen.id);
    }
  }

  void initState(){
   super.initState();
   getCurrentUser();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  child: Image.asset("images/logo1.png"),
                  height: 60.0,
                ),
                Text(
                  "Flash Chat",style: TextStyle(fontSize: 45.0,fontWeight: FontWeight.w900),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding
              (
              padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Material(
              elevation: 5.0,
              color: Colors.lightBlueAccent,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                onPressed: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                },
                minWidth: 200.0,
                height: 48.0,
                child: Text("Login"),
              ),
            ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlue,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: (){
                    Navigator.pushNamed(context, RegistrationScreen.id);
                  },
                  minWidth: 200.0,
                  height: 48.0,
                  child: Text("Register"),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
