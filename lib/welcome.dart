import 'package:comfortline/flowpage.dart';
import 'package:comfortline/functions/functions.dart';
import 'package:comfortline/globals.dart';
import 'package:comfortline/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

import 'code.dart';

class WelcomePage extends StatefulWidget {
  String space;
  WelcomePage({this.space = "", super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  Map data = {};
  String q = '';
  bool loadOptions = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: Stack(children: [
        Container(
          height: 250,
          width: double.infinity,
          color: mainColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              colSpace(50),
              SvgPicture.asset(
                'images/logo.svg',
              ),
              colSpace(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  appText("Welcome to Space ${widget.space}", 22, white),
                ],
              ),
            ],
          ),
        ),
        Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(15, 220, 15, 15),
              // padding: const EdgeInsets.all(15),
              // width: double.infinity,
              // height: 180,
              // decoration: BoxDecoration(
              //     color: Colors.white, borderRadius: BorderRadius.circular(20)),
              // alignment: Alignment.topCenter,
              // // height: 520.0,
              // child: Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.stretch,
              //   children: [
              //     Container(
              //       width: 22,
              //       decoration: const BoxDecoration(
              //           color: yellowColor,
              //           borderRadius: BorderRadius.only(
              //               topLeft: Radius.circular(20),
              //               bottomLeft: Radius.circular(20))),
              //     ),
              //     Column(
              //       mainAxisAlignment: MainAxisAlignment.center,
              //       children: [
              //         Image(image: AssetImage('images/building.png')),
              //         colSpace(10),
              //         appText("Today you can work from the\nXXX and YYY spaces",
              //             14, mainColor,
              //             align: TextAlign.center, fontWeight: FontWeight.w500)
              //       ],
              //     ),
              //     rowSpace(20)
              //   ],
              // ),
            ),
            FutureBuilder(
                future: readData(Paths.usersFeedbacks),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done ||
                      data.isNotEmpty) {
                    if (data.isEmpty && snapshot.data.value != null) {
                      q = snapshot.data.value['iot'] ?? '';
                      data = snapshot.data.value;
                    }
                    return Container(
                      margin: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      padding: const EdgeInsets.all(15),
                      width: double.infinity,
                      // height: 90,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      alignment: Alignment.topCenter,
                      // height: 520.0,
                      child: Column(
                        children: [
                          questionButton(
                            () {
                              context.goNamed('code',
                                  queryParameters: {'oldcode': widget.space});
                            },
                            widget.space != ""
                                ? 'You are now in the space (${widget.space}) click to change'
                                : "Please indicate the office number you are working in",
                            fixed: true,
                          ),
                          colSpace(10),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: InkWell(
                              onTap: () {
                                // readData(Paths.hasResponded)
                                //     .then((value) => print(value.value));
                                context.goNamed('flow');
                              },
                              child: Container(
                                padding: const EdgeInsets.all(15),
                                width: double.infinity,
                                // height: 90,
                                decoration: BoxDecoration(
                                    color: mainColor,
                                    borderRadius: BorderRadius.circular(20)),
                                alignment: Alignment.topCenter,
                                // height: 520.0,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      'images/qmark.svg',
                                    ),
                                    rowSpace(10),
                                    Flexible(
                                      child: appText(
                                          "Do you want to tell us how you find the indoor environment? ",
                                          14,
                                          white,
                                          fontWeight: FontWeight.w500),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                          //   children: [
                          //     SvgPicture.asset(
                          //       'images/qmark2.svg',
                          //     ),
                          //     rowSpace(10),
                          //     Flexible(
                          //       child: appText(
                          //           "Will you work from the office tomorrow? (optional)",
                          //           14,
                          //           mainColor,
                          //           fontWeight: FontWeight.w500),
                          //     )
                          //   ],
                          // ),
                          // colSpace(10),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Expanded(
                          //       child: AppButton(
                          //         q == 'y' ? mainColor : lightColor,
                          //         () {
                          //           setState(() {
                          //             q = 'y';
                          //           });
                          //           newRequest(
                          //               Paths.updateInOfficeTomorrow, 'y');
                          //         },
                          //         "YES",
                          //         darkText: q != 'y',
                          //       ),
                          //     ),
                          //     rowSpace(10),
                          //     Expanded(
                          //       child: AppButton(
                          //         q == 'n' ? mainColor : lightColor,
                          //         () {
                          //           setState(() {
                          //             q = 'n';
                          //           });
                          //           newRequest(
                          //               Paths.updateInOfficeTomorrow, 'n');
                          //         },
                          //         "NO",
                          //         darkText: q != 'n',
                          //       ),
                          //     ),
                          //     rowSpace(10),
                          //     Expanded(
                          //       child: AppButton(
                          //         q == 'm' ? mainColor : lightColor,
                          //         () {
                          //           setState(() {
                          //             q = 'm';
                          //           });
                          //           newRequest(
                          //               Paths.updateInOfficeTomorrow, 'm');
                          //         },
                          //         "MAYBE",
                          //         darkText: q != 'm',
                          //       ),
                          //     ),
                          //   ],
                          // ),

                          // colSpace(20),
                        ],
                      ),
                    );
                  } else {
                    return progressIndicator();
                  }
                }),
          ],
        ),
      ]),
    );
  }
}
