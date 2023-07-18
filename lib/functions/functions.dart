//Material functions

import 'package:comfortline/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../material.dart';

Future push(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    PageRouteBuilder(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (_, a, __, c) => FadeTransition(opacity: a, child: c),
    ),
  );
}

Future<UserCredential> signUp() async {
  String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
  UserCredential user;
  user = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: '$timestamp@technicalcomfortline.hobo', password: timestamp);
  wait(4000).then((value) {
    FirebaseMessaging.instance.subscribeToTopic("0000");
  });

  return user;
}

Future<void> newRequest(request, data) {
  return FirebaseDatabase.instance
      .ref('usersRequests/${FirebaseAuth.instance.currentUser!.uid}/$request')
      .set(data);
}

Future<DataSnapshot> readData(path) {
  return FirebaseDatabase.instance
      .ref('$path/${FirebaseAuth.instance.currentUser!.uid}')
      .get();
}

Future<Object?> checkLocationCode(code) async {
  Object? result = {};
  await FirebaseDatabase.instance.ref('spacesID/$code').get().then((value) {
    result = value.value;
  });
  return result;
}

Future pushReplace(BuildContext context, Widget page) {
  return Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

void pop(BuildContext context) {
  return Navigator.of(context).pop();
}

Future showErrorPopup(BuildContext context, String errortext) {
  return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: ((context) {
        return Container(
          decoration: const BoxDecoration(
              color: white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          height: 180,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              appText(
                "Error",
                16,
                Colors.red,
              ),
              colSpace(20),
              appText(errortext, 14, grey),
              colSpace(40),
              Container(
                margin: const EdgeInsets.only(left: 30, right: 30),
                width: double.infinity,
                child: AppButton(mainColor, () {
                  Navigator.of(context).pop();
                }, "Return"),
              )
            ],
          ),
        );
      }));
}
