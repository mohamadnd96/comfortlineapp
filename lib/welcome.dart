import 'package:comfortline/functions.dart';
import 'package:comfortline/globals.dart';
import 'package:comfortline/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

class WelcomePage extends StatefulWidget {
  final String space;
  const WelcomePage({this.space = "", super.key});

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
                          QuestionButton(
                            () {
                              context.goNamed('login',
                                  queryParameters: {'space': ''},
                                  extra: widget.space);
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
                                context.pushNamed('flow');
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
