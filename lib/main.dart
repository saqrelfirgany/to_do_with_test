import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_with_test/screens/home_screen.dart';
import 'package:to_do_with_test/screens/login_screen.dart';
import 'package:to_do_with_test/services/auth.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          ///Check Errors
          if (snapshot.hasError) {
            print(snapshot.hasError.toString());
            return const Scaffold(body: Center(child: Text("Error")));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return const Root();
          }
          return const Scaffold(body: Center(child: Text("Loading")));
        },
      ),
    );
  }
}

class Root extends StatefulWidget {
  const Root({Key? key}) : super(key: key);

  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: Auth(auth: _auth).user,
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.data?.uid == null) {
            return Login(auth: _auth, firestore: _firestore);
          } else {
            return Home(auth: _auth, firestore: _firestore);
          }
        } else {
          return const Scaffold(body: Center(child: Text("Loading...")));
        }
      }, //Auth stream
    );
  }
}
