import 'package:comfortline/code.dart';
import 'package:comfortline/flowpage.dart';
import 'package:comfortline/functions.dart';
import 'package:comfortline/material.dart';
import 'package:comfortline/qr.dart';
import 'package:comfortline/welcome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAs1fs9uYPu483Hn8ErMK4e52z1akC4mck",
            authDomain: "test1-8f077.firebaseapp.com",
            databaseURL:
                "https://test1-8f077-default-rtdb.europe-west1.firebasedatabase.app",
            projectId: "test1-8f077",
            storageBucket: "test1-8f077.appspot.com",
            messagingSenderId: "145770969403",
            appId: "1:145770969403:web:e405bf809bcc4424599f1e",
            measurementId: "G-CNV2HL7JS2"));
  } else {
    await Firebase.initializeApp();
  }
  runApp(const MyApp());
}

mixin FirebaseMessaging {}

final GoRouter _router = GoRouter(initialLocation: '/', routes: <RouteBase>[
  GoRoute(
      name: 'home',
      path: '/',
      builder: (context, state) => const Home(),
      routes: [
        GoRoute(
            name: 'login',
            path: 'login',
            builder: (context, state) => Code(
                space: state.uri.queryParameters['space']!,
                oldcode: state.extra.toString()),
            routes: [
              GoRoute(
                name: 'qrcode',
                path: 'scan',
                builder: (context, state) => QrScanner(() {
                  Future.delayed(const Duration(milliseconds: 500)).then(
                      (value) => showErrorPopup(context,
                          "The QR code you are trying to scan is not valid"));
                }),
              )
            ]),
        GoRoute(
            name: 'welcome',
            path: 'welcome',
            builder: (context, state) =>
                WelcomePage(space: state.extra.toString())),
        GoRoute(
            name: 'flow',
            path: 'vote',
            builder: (context, state) => const FlowPage())
      ]),
]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'Comfortline',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routerConfig: _router);
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
    if (FirebaseAuth.instance.currentUser != null) {
      readData('users').then((value) => {
            if (GoRouterState.of(context).fullPath != '/login' ||
                GoRouterState.of(context).uri.queryParameters.toString() ==
                    '{space: }')
              {
                if (value.child('space').value != '' &&
                    value.child('space').value != null)
                  {
                    wait(2000).then((value1) => context.goNamed('welcome',
                        extra: value.child("space").value.toString()))
                  }
                else
                  {
                    wait(2000).then((value) => context.goNamed('login',
                        queryParameters: {'space': ''}, extra: '0000'))
                  }
              }
          });
    } else {
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
                            setState(() {
                              loading = true;
                              firstuse = loading = false;
                            });
                            context.goNamed('login',
                                queryParameters: {'space': ''}, extra: '0000');
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
