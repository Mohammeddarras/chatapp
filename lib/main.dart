import 'package:chatapp/screens/chat_screen.dart';
import 'package:chatapp/screens/login_screen.dart';
import 'package:chatapp/screens/registration_screen.dart';
import 'package:chatapp/screens/user_list.dart';
import 'package:chatapp/screens/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
    initialRoute: WelcomeScreen.id,
      routes: {
    WelcomeScreen.id: (context) => WelcomeScreen(),
    LoginScreen.id: (context) => LoginScreen(),
    RegistrationScreen.id: (context) => RegistrationScreen(),
    ChatScreen.id: (context) => ChatScreen(),
    UsersList.id: (context) => UsersList(),
    }
    );
  }
}
