import 'dart:async';

import 'package:comfortline/material.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'functions/functions.dart';
import 'globals.dart';

class FlowPage extends StatefulWidget {
  const FlowPage({super.key});

  @override
  State<FlowPage> createState() => _FlowPageState();
}

class _FlowPageState extends State<FlowPage> {
  final CarouselController _controller =
      CarouselController(); // controller of the slider
  moveNext(int id) {
    // id of the page (0 to 3)
    if (id == 3) {
      // setState(() {
      //   loadSubmit = true;
      // });
    } else {
      // if not on last page, move to next page
      Timer(const Duration(milliseconds: 500), () {
        _controller.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      });
    }
  }

  Map data = {}; // question + answer saved in a map
  bool loadSubmit = false; // answered all questions
  bool sad = false;
  bool loading = false;
  List questions = [
    // array of questions
    {
      'id': 0,
      'title': 'AIR QUALITY',
      'question': 'How do you find Air quality?',
      'loadsadoptions': false,
      'loadneutraloptions': false,
      'sadsubanswers': [
        'The air is stuffy',
        'I want more fresh air',
        'There are many odors',
      ],
      'neutralsubanswers': [
        'I\'m neither satisfied neither dissatisfied',
        'I don\'t understand the question',
        'I don\'t have a clear option',
      ],
      'answer': {
        'a': '0',
        's': '0'
      }, // a = answer (none(0), happy (1), neutral (2), sad(3)), s = subanswer (none(0), ans1(1), ans2(2), ans3(3))
    },
    {
      'id': 1,
      'title': 'THERMAL COMFORT',
      'loadsadoptions': false,
      'loadneutraloptions': false,
      'sadsubanswers': [
        'I prefer a warmer place',
        'I prefer a colder place',
      ],
      'neutralsubanswers': [
        'I\'m neither satisfied neither dissatisfied',
        'I don\'t understand the question',
        'I don\'t have a clear option',
      ],
      'question': 'How do you find thermal comfort?',
      'answer': {'a': '0', 's': '0'}
    },
    {
      'id': 2,
      'title': 'VISUAL COMFORT',
      'loadsadoptions': false,
      'loadneutraloptions': false,
      'sadsubanswers': [
        'The light is too low',
        'There is too much light',
        'There is not enough natural light',
      ],
      'neutralsubanswers': [
        'I\'m neither satisfied neither dissatisfied',
        'I don\'t understand the question',
        'I don\'t have a clear option',
      ],
      'question': 'How do you find visual comfort? (light level)',
      'answer': {'a': '0', 's': '0'}
    },
    {
      'id': 3,
      'title': 'ACOUSTIC COMFORT',
      'loadsadoptions': false,
      'loadneutraloptions': false,
      'sadsubanswers': [
        'There is too much ambient noise',
        'I cannot talk in privacy',
        'The colleagues speak too loud',
      ],
      'neutralsubanswers': [
        'I\'m neither satisfied neither dissatisfied',
        'I don\'t understand the question',
        'I don\'t have a clear option',
      ],
      'question': 'How do you find acoustic comfort?',
      'answer': {'a': '0', 's': '0'}
    },
  ];
  int _current = 0; // current page (0, 1, 2, 3)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backColor,
      body: SizedBox(
        height: double.infinity,
        child: Stack(children: [
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
                    SvgPicture.asset(
                      'images/qmark.svg',
                    ),
                    rowSpace(10),
                    appText("Ask feedback", 22, white),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 205),
            child: CarouselSlider(
              carouselController: _controller,
              options: CarouselOptions(
                height: double.infinity,
                viewportFraction: 1,
                enlargeCenterPage: true,
                enlargeFactor: 0.1,
                initialPage: _current,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                },
              ),
              items: questions.map((i) {
                return FutureBuilder(
                    future: readData(Paths.usersFeedbacks),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done ||     // user answered all the questions or some questions already got answered
                          data.isNotEmpty) {
                        if (data.isEmpty && snapshot.data.value != null) {
                          data = snapshot.data.value;
                          if (data['feedback'] != null) {
                            Map a = data['feedback'];
                            int i = 0;
                            a.forEach((key, value) {                              // repeated 4 times (1 for each question)
                              questions.elementAt(i)['answer'] = value;
                              questions.elementAt(i)['loadneutraloptions'] =
                                  (value['a'] == '2');
                              questions.elementAt(i)['loadsadoptions'] =
                                  (value['a'] == '3');

                              i += 1;
                            });
                          }
                        }
                        return Builder(
                          builder: (BuildContext context) {
                            return AnimatedContainer(                                     // can extend to show questions
                                alignment: Alignment.topCenter,
                                height: double.infinity,
                                curve: Curves.easeIn,
                                duration: const Duration(milliseconds: 300),
                                margin: EdgeInsets.fromLTRB(
                                    15,
                                    15,
                                    15,
                                    (i['answer']['a'] == "3" ||                          // adapts the high depending on the happy option or the neutral / sad option
                                            i['answer']['a'] == "2")
                                        ? MediaQuery.of(context).size.height -
                                            660
                                        : MediaQuery.of(context).size.height -
                                            460),
                                padding: const EdgeInsets.all(15),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        decoration: const BoxDecoration(
                                            border: Border(
                                                bottom: BorderSide(
                                                    width: 1.0,
                                                    color: mainColor))),
                                        child:
                                            appText(i['title'], 12, mainColor)),
                                    colSpace(25),
                                    appText(i['question'], 16, mainColor),
                                    colSpace(35),
                                    Row(                                              // row for the 3 faces
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,        
                                      children: [                                     // one inkwell for each face logo (can tap on it)
                                        InkWell(                                      // HAPPY
                                          onTap: () {                                 // when ever we tap on the faces
                                            setState(() {
                                              i['answer']['a'] = "1";
                                              i['loadsadoptions'] = false;
                                              i['loadneutraloptions'] = false;
                                            });
                                            moveNext(i['id']);                        // automatic move to next question if happy is selected 
                                          },
                                          child: FaceButton("images/happy.svg",
                                              i['answer']['a'] == "1"),
                                        ),
                                        InkWell(                                      // NEUTRAL
                                          onTap: () {
                                            setState(() {
                                              i['answer']['a'] = "2";
                                              i['loadsadoptions'] = false;
                                              wait(300).then((value) {
                                                setState(() {
                                                  i['loadneutraloptions'] =
                                                      true;
                                                });
                                              });
                                            });
                                          },
                                          child: FaceButton(
                                              "images/neutral.svg",
                                              i['answer']['a'] == "2"),
                                        ),
                                        InkWell(                                      // SAD
                                          onTap: () {
                                            setState(() {
                                              i['answer']['a'] = "3";
                                              i['loadneutraloptions'] = false;
                                            });

                                            wait(300).then((value) {
                                              setState(() {
                                                i['loadsadoptions'] = true;
                                              });
                                            });
                                          },
                                          child: FaceButton(
                                            "images/sad.svg",
                                            i['answer']['a'] == "3",
                                          ),
                                        ),
                                      ],
                                    ),
                                    widgetIf(                                               // widget if for the 3 sad optional answers
                                      i['answer']['a'] == "3" &&
                                          i['loadsadoptions'],
                                      // if (i['answer']['a'] == "3" && i['loadsadoptions'])
                                      Column(
                                        children: [
                                          colSpace(30),
                                          OptionButton(                                     // first sad optional answer
                                              i['answer']['s'] == "1"
                                                  ? mainColor
                                                  : lightgrey, () {
                                            setState(() {
                                              i['answer']['s'] = "1";
                                            });
                                            moveNext(i['id']);
                                          }, i['sadsubanswers'][0]),
                                          colSpace(15),
                                          OptionButton(                                     // second sad optional answer
                                              i['answer']['s'] == "2"
                                                  ? mainColor
                                                  : lightgrey, () {
                                            setState(() {
                                              i['answer']['s'] = "2";
                                            });
                                            moveNext(i['id']);
                                          }, i['sadsubanswers'][1]),
                                          if (i['title'] != 'THERMAL COMFORT')
                                            colSpace(15),
                                          if (i['title'] != 'THERMAL COMFORT')
                                            OptionButton(                                     // third sad optional answer
                                                i['answer']['s'] == "3"
                                                    ? mainColor
                                                    : lightgrey, () {
                                              setState(() {
                                                i['answer']['s'] = "3";
                                              });
                                              moveNext(i['id']);
                                            }, i['sadsubanswers'][2]),
                                        ],
                                      ),
                                    ),
                                    widgetIf(                                                 // widget if for the 3 neutral optional answers
                                      i['answer']['a'] == "2" &&
                                          i['loadneutraloptions'],
                                      // if (i['answer']['a'] == "3" && i['loadsadoptions'])
                                      Column(
                                        children: [
                                          colSpace(30),
                                          OptionButton(                                      // first neutral optional answer
                                              i['answer']['s'] == "1"
                                                  ? mainColor
                                                  : lightgrey, () {
                                            setState(() {
                                              i['answer']['s'] = "1";
                                            });
                                            moveNext(i['id']);
                                          }, i['neutralsubanswers'][0]),
                                          colSpace(15),
                                          OptionButton(                                      // second neutral optional answer
                                              i['answer']['s'] == "2"
                                                  ? mainColor
                                                  : lightgrey, () {
                                            setState(() {
                                              i['answer']['s'] = "2";
                                            });
                                            moveNext(i['id']);
                                          }, i['neutralsubanswers'][1]),
                                          colSpace(15),
                                          OptionButton(                                      // third neutral optional answer
                                              i['answer']['s'] == "3"
                                                  ? mainColor
                                                  : lightgrey, () {
                                            setState(() {
                                              i['answer']['s'] = "3";
                                            });
                                            moveNext(i['id']);
                                          }, i['neutralsubanswers'][2]),
                                        ],
                                      ),
                                    )
                                  ],
                                ));
                          },
                        );
                      } else {                                                              // spinner if data is empty or connection state is not done
                        return progressIndicator();
                      }
                    });
              }).toList(),
            ),
          ),
          if (_current == 3)                                                                // if last question, show submit button
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 680, 25, 14),
              child: AppButton(
                mainColor,
                () async {
                  setState(() {
                    loading = true;
                  });
                  Map answerResult = {
                    "a": questions.elementAt(0)['answer'],
                    "b": questions.elementAt(1)['answer'],
                    "c": questions.elementAt(2)['answer'],
                    "d": questions.elementAt(3)['answer'],
                  };
                  await newRequest(Paths.updateFeedback, answerResult);
                  setState(() {
                    loading = false;
                  });
                  // ignore: use_build_context_synchronously
                  showBottomModal(context);                                       // submit button declared in material.dart
                },
                "SUBMIT ANSWERS",
                loading: loading,
              ),
            ),
          Positioned.fill(                                                        // 4 dots in the center changing with the carousel slider
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: questions.map(
                  (image) {
                    int index = questions.indexOf(image);
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                      width: _current == index ? 20 : 8.0,
                      height: 8.0,
                      margin: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 2.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: _current == index ? mainColor : grey),
                    );
                  },
                ).toList(), // this was the part the I had to add
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

class FaceButton extends StatefulWidget {
  final String img;
  final bool clicked;
  const FaceButton(this.img, this.clicked, {super.key});
  @override
  State<FaceButton> createState() => _FaceButtonState();
}

class _FaceButtonState extends State<FaceButton> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 81,
          height: 81,
          decoration: BoxDecoration(
              color: widget.clicked ? mainColor : Colors.transparent,
              borderRadius: BorderRadius.circular(50)),
        ),
        SvgPicture.asset(
          widget.img,
        ),
        // Padding(
        //   padding: const EdgeInsets.only(bottom: 65, left: 65),
        //   child: Icon(
        //     Icons.check_circle,
        //     color: yellowColor,
        //   ),
        // )
      ],
    );
  }
}
