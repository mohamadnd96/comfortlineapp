import 'package:comfortline/code.dart';
import 'package:comfortline/fixedpage.dart';
import 'package:comfortline/functions/functions.dart';

import 'package:comfortline/material.dart';
import 'package:comfortline/welcome.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // uses FireBase Core depedencie
  await Firebase.initializeApp();
  runApp(const MyApp());
}

mixin FirebaseMessaging {} // unimportant (notifications)

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const Home());
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool firstuse = false;
  bool animate = true;
  bool loading = false;

  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Future<bool> checkLogin() async {
    if (FirebaseAuth.instance.currentUser != null) { // if logged in
      readData('users').then((value) => {
            if (value.child('space').value != '' &&    // if user in a space
                value.child('space').value != null)
              {
                wait(2000).then((value1) => pushReplace(context,
                    WelcomePage(space: value.child('space').value.toString())))
              }
            else // else
              {wait(2000).then((value) => pushReplace(context, Code()))}
          });
    } else { // if not logged in 
      setState(() {
        firstuse = true;
      });
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appText("WELCOME TO", 18, Colors.black,
                    fontWeight: FontWeight.bold),
                colSpace(10),
                appText("Comfortline", 32, yellowColor,
                    fontWeight: FontWeight.bold),
                colSpace(10),
                appText(
                    "The app that will make buildings operate based on your needs.",
                    16,
                    grey),
                colSpace(60),
                if (firstuse)
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          yellowColor,
                          () async {
                            animate = false;
                            // signUp().then((value) {
                            setState(() {
                              loading = true;
                              firstuse = loading = false;
                            });
                            pushReplace(context, Code());
                            // });
                          },
                          "Continue",
                          animate: true,
                          loading: loading,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          Buildings(animate)
        ],
      ),
    );
  }
}
