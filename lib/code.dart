import 'dart:ffi';

import 'package:comfortline/components/qr.dart';
import 'package:comfortline/fixedpage.dart';
import 'package:comfortline/functions/functions.dart';
import 'package:comfortline/globals.dart';
import 'package:comfortline/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import 'welcome.dart';

class Code extends StatefulWidget {
  String oldcode;
  Code({this.oldcode = "0000", super.key});

  @override
  State<Code> createState() => _CodeState();
}

TextEditingController controller1 = TextEditingController();
TextEditingController controller2 = TextEditingController();
TextEditingController controller3 = TextEditingController();
TextEditingController controller4 = TextEditingController();
TextEditingController controller5 = TextEditingController();
TextEditingController controller6 = TextEditingController();
TextEditingController controller7 = TextEditingController();
TextEditingController controller8 = TextEditingController();

class _CodeState extends State<Code> {
  bool loading = false;
  late FocusNode node1 = FocusNode();
  late FocusNode node2 = FocusNode();
  late FocusNode node3 = FocusNode();
  late FocusNode node4 = FocusNode();
  late FocusNode node5 = FocusNode();
  late FocusNode node6 = FocusNode();
  late FocusNode node7 = FocusNode();
  late FocusNode node8 = FocusNode();

  String getCode() {
    return controller1.text +
        controller2.text +
        controller3.text +
        controller4.text +
        controller5.text +
        controller6.text +
        controller7.text +
        controller8.text;
  }

  @override
  void dispose() {
    super.dispose();
    controller1.clear();
    controller2.clear();
    controller3.clear();
    controller4.clear();
    controller5.clear();
    controller6.clear();
    controller7.clear();
    controller8.clear();
  }

  bool loadOptions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: SingleChildScrollView(
        child: Stack(children: [
          Container(
            height: 250,
            width: double.infinity,
            color: mainColor,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // center the comfortline logo
              children: [
                colSpace(50),
                SvgPicture.asset(
                  'images/logo.svg',
                ),
                colSpace(60),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 200, 15, 15), // T=200, 200 px from the top of the page
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.topCenter,
                  height: 300.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      colSpace(30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          appText("ENTER THE", 16, black),
                          rowSpace(3),
                          appText("8-DIGITS CODE", 16, black,
                              fontWeight: FontWeight.bold),
                        ],
                      ),
                      colSpace(20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller1, (x) { // x = the number of the input
                                if (x.isEmpty) {
                                } else {
                                  node2.requestFocus();
                                }
                              }, node1)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller2, (x) {
                                if (x.isEmpty) {
                                  node1.requestFocus();
                                } else {
                                  node3.requestFocus();
                                }
                              }, node2)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller3, (x) {
                                if (x.isEmpty) {
                                  node2.requestFocus();
                                } else {
                                  node4.requestFocus();
                                }
                              }, node3)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller4, (x) {
                                if (x.isEmpty) {
                                  node3.requestFocus();
                                } else {
                                  node5.requestFocus();
                                }
                              }, node4)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller5, (x) {
                                if (x.isEmpty) {
                                  node4.requestFocus();
                                } else {
                                  node6.requestFocus();
                                }
                              }, node5)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller6, (x) {
                                if (x.isEmpty) {
                                  node5.requestFocus();
                                } else {
                                  node7.requestFocus();
                                }
                              }, node6)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller7, (x) {
                                if (x.isEmpty) {
                                  node6.requestFocus();
                                } else {
                                  node8.requestFocus();
                                }
                              }, node7)),
                          rowSpace(3),
                          SizedBox(
                              width: 35,
                              child: CodeInput(controller8, (x) {
                                if (x.isEmpty) {
                                  node7.requestFocus();
                                } else {}
                              }, node8))
                        ],
                      ),
                      colSpace(20),
                      appText("That was distributed by your administrator", 14,
                          grey),
                      colSpace(20),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: AppButton(
                              yellowColor,
                              () async {
                                String code = getCode();
                                if (code.length == 8 &&
                                    int.tryParse(code) != null) {              // checks the format of the code
                                  if (widget.oldcode
                                              .toString()
                                              .substring(0, 4) ==              // gets building code (first 4 digits) and checks if it changed 
                                          code.substring(0, 4) ||
                                      widget.oldcode == "0000") {              // if we had no building (first building)
                                    setState(() {
                                      loading = true;                          // if it didnt change or if first building, load and do the FireBase sign up
                                    });
                                    checkLocationCode(code).then((value) async {
                                      if (value != null) {                      // if space exists
                                        if (FirebaseAuth.instance.currentUser == // if new user, sign up and subscribe to building topics
                                            null) {
                                          await signUp();
                                          await wait(2000);
                                          await newRequest(
                                              Paths.updateLocation, code);
                                          FirebaseMessaging.instance            // topic = notification plugin from FireBase used for example if the owner wants to notify people from specific spaces
                                              .subscribeToTopic(code);          // subscribe to SPACE
                                          FirebaseMessaging.instance
                                              .subscribeToTopic(
                                                  code.substring(0, 4));        // subscribe to BUILDING
                                          FirebaseMessaging.instance
                                              .subscribeToTopic(
                                                  code.substring(0, 6));        // subscribe to FLOOR of building
                                        } else {                                // if user exists but has no space, subscribe to new one
                                          await newRequest(
                                              Paths.updateLocation, code);
                                          await readData('users')
                                              .then((oldspace) {
                                            if (oldspace
                                                    .child('building')
                                                    .value ==
                                                '') {                           // '' (empty string) because this is the case you got kicked out of the building (therefor it's not 0000) <= RARE
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(code);
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(
                                                      code.substring(0, 4));
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(
                                                      code.substring(0, 6));
                                            } else {                            // if user exists and has a space, unsubscribe from old one first, then subscribe to new one
                                              FirebaseMessaging.instance
                                                  .unsubscribeFromTopic(oldspace
                                                      .child('space')
                                                      .value
                                                      .toString());
                                              FirebaseMessaging.instance
                                                  .unsubscribeFromTopic(oldspace
                                                      .child('space')
                                                      .value
                                                      .toString()
                                                      .substring(0, 4));
                                              FirebaseMessaging.instance
                                                  .unsubscribeFromTopic(oldspace
                                                      .child('space')
                                                      .value
                                                      .toString()
                                                      .substring(0, 6));
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(code);
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(
                                                      code.substring(0, 4));
                                              FirebaseMessaging.instance
                                                  .subscribeToTopic(
                                                      code.substring(0, 6));
                                            }
                                          });
                                        }
                                        await wait(4000);
                                        setState(() {
                                          loading = false;
                                        });
                                        // ignore: use_build_context_synchronously
                                        pushReplace(
                                            context, WelcomePage(space: code));
                                        // });
                                      } else {                                      // if space doesn't exists
                                        setState(() {
                                          loading = false;
                                        });
                                        showErrorPopup(context,
                                            "The entered code does not match any space");
                                      }
                                    });
                                  } else {                                          // else from if (line 210) => If building changed, log out
                                    showLogoutModal(context);
                                  }
                                } else {                                            // if format is invalid
                                  showErrorPopup(
                                      context, "The entered code is not valid");
                                }
                              },
                              "CONTINUE",
                              loading: loading,
                            )),
                      )
                    ],
                  ),
                ),
                colSpace(20),
                appText("OR", 24, black), // OR between the 8 Digit and the QR Contrainers
                colSpace(20),
                InkWell(
                  onTap: () {
                    push(context, QrScanner(() {
                      Future.delayed(const Duration(milliseconds: 500)).then(
                          (value) => showErrorPopup(context,
                              "The QR code you are trying to scan is not valid"));
                    }));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      children: [
                        Image.asset(
                          'images/qr.png',
                        ),
                        rowSpace(20),
                        appText("Scan any HOBO QR code in\nyour building", 16,
                            grey),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }
}
