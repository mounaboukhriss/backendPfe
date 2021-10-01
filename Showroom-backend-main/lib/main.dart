import 'package:firebase/firebase.dart';
import 'package:flutter/material.dart';
import 'package:showroom_backend/views/login/login_screen.dart';

void main() {
  initializeApp(
      apiKey: "AIzaSyAWlORwF5Z1cE8aySpYurR8BUa7nI9SRQ8",
      authDomain: "showroom-app-81183.firebaseapp.com",
      databaseURL: "https://showroom-app-81183-default-rtdb.firebaseio.com",
      projectId: "showroom-app-81183",
      storageBucket: "showroom-app-81183.appspot.com");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginScreen(),
      ),
    );
  }
}
