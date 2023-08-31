import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

const Color yellowColor = Color.fromRGBO(255, 200, 0, 1);
const Color mainColor = Color.fromRGBO(55, 90, 100, 1);
const Color lightColor = Color(0xFFEDF4F5);
const Color grey = Color.fromRGBO(159, 159, 159, 1);
const Color lightgrey = Color.fromRGBO(242, 242, 242, 11);
const Color backColor = Color.fromRGBO(241, 241, 241, 1);
const Color lightRed = Color.fromRGBO(245, 237, 237, 1);
const Color red = Color.fromRGBO(255, 102, 102, 1);
const Color white = Colors.white;
const Color black = Colors.black;

class AppButton extends StatefulWidget {
  final Color color; // color of the button
  final void Function() action;
  final String text; // text on the button
  final bool animate; // ex : loading spinner
  final bool darkText; // default: false (at default the text in light)
  final bool loading; // show loading spinner
  const AppButton(
      this.color, this.action, this.text, // <=  have to ne initialized
      {this.animate = false,
      this.darkText = false, // <= we can initialize but not mandatory
      this.loading = false,
      super.key});
  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton> {
  double opacity =
      0.0; // (transparency) may change for animations or color change
  @override
  void initState() {
    // blends in
    if (widget.animate) {
      Future.delayed(const Duration(seconds: 2)).then((value) => {
            setState(() {
              opacity = 1;
            })
          });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(seconds: 1),
      opacity: widget.animate ? opacity : 1,
      child: ElevatedButton(
          style: ButtonStyle(
              fixedSize: const MaterialStatePropertyAll(Size.fromHeight(40)),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(
                  widget.color.withOpacity(widget.animate
                      ? opacity
                      : widget.loading
                          ? 0.5
                          : 1))),
          onPressed: widget.loading
              ? null
              : widget.action, // button can't be pressed while loading
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.text,
                style: TextStyle(
                  color: widget.darkText ? mainColor : Colors.white,
                  fontSize: 15,
                ),
              ),
              if (widget.loading) // if loading, show the loading spinner
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      height: 15, width: 15, child: progressIndicator()),
                )
            ],
          )),
    );
  }
}

class Buildings extends StatefulWidget {
  // building in the background (going up when first logging in)
  final bool animate;
  const Buildings(this.animate, {super.key});
  @override
  State<Buildings> createState() => _BuildingsState();
}

class _BuildingsState extends State<Buildings> with TickerProviderStateMixin {
  Animation<Offset> controller(double start, int duration) {
    return Tween<Offset>(
      begin: Offset(0.0, start),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: AnimationController(
        duration: Duration(milliseconds: widget.animate ? duration : 0),
        vsync: this,
      )..forward(),
      curve: Curves.easeInCubic,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 250),
          child: SvgPicture.asset(
            'images/b6.svg',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 300),
          child: SvgPicture.asset(
            'images/b5.svg',
          ),
        ),
        SlideTransition(
          position: controller(0.9, 1150),
          child: Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width / 3),
            // top: 70,
            child: SvgPicture.asset(
              'images/b3.svg',
            ),
          ),
        ),
        SlideTransition(
          position: controller(0.9, 1300),
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 3),
            // top: 70,
            child: SvgPicture.asset(
              'images/b2.svg',
            ),
          ),
        ),
        SlideTransition(
          position: controller(0.9, 1000),
          child: Padding(
            padding:
                EdgeInsets.only(left: MediaQuery.of(context).size.width / 1.4),
            // top: 70,
            child: SvgPicture.asset(
              'images/b1.svg',
            ),
          ),
        ),
        SlideTransition(
          position: controller(0.9, 1450),
          child: Padding(
            padding:
                EdgeInsets.only(right: MediaQuery.of(context).size.width / 1.4),
            // top: 70,
            child: SvgPicture.asset(
              'images/b4.svg',
            ),
          ),
        ),
      ],
    );
  }
}

// ignore: must_be_immutable
class OptionButton extends StatelessWidget {
  // no animation, no spinner
  Color color;
  void Function() action;
  String text;

  OptionButton(this.color, this.action, this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              )),
              fixedSize: const MaterialStatePropertyAll(Size.fromHeight(50)),
              elevation: const MaterialStatePropertyAll(0),
              backgroundColor: MaterialStatePropertyAll(color)),
          onPressed: action,
          child: Text(
            text,
            style: TextStyle(
              color: color == mainColor ? white : mainColor,
              fontSize: 15,
            ),
          )),
    );
  }
}

class QuestionButton extends StatefulWidget {
  final void Function() action;
  final Widget child;
  final String text;
  final bool fixed;
  const QuestionButton(this.action, this.text,
      {this.child = const SizedBox(), this.fixed = false, super.key});

  @override
  State<QuestionButton> createState() => _QuestionButtonState();
}

class _QuestionButtonState extends State<QuestionButton> {
  bool expanded = false;
  bool showchild = false;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: InkWell(
        onTap: widget.fixed
            ? widget.action
            : () {
                setState(() {
                  expanded = !expanded;
                });
                if (expanded) {
                  wait(200).then((value) {
                    setState(() {
                      showchild = true;
                    });
                  });
                } else {
                  setState(() {
                    showchild = false;
                  });
                }
              },
        child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.all(12),
            height: expanded ? 110 : 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18.0), color: lightColor),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        widget.text,
                        textAlign: TextAlign.start,
                        style: const TextStyle(
                          color: mainColor,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (!widget.fixed)
                      const Icon(
                        Icons.arrow_drop_down_rounded,
                        color: mainColor,
                        size: 35,
                      ),
                  ],
                ),
                if (showchild && !widget.fixed) colSpace(12),
                if (showchild && !widget.fixed) widget.child
              ],
            )),
      ),
    );
  }
}

Widget widgetIf(bool condition, Widget child) {
  if (condition) {
    return child;
  } else {
    return const SizedBox();
  }
}

Future showBottomModal(context) => showModalBottomSheet(
    // message that shows when we submit the answer
    backgroundColor: Colors.transparent,
    context: context,
    builder: ((context) {
      return Container(
        decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        height: 250,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/complete.svg',
            ),
            colSpace(20),
            appText("Completed", 16, Colors.black),
            colSpace(20),
            appText("Thank you for giving your feedback", 14, grey),
            colSpace(40),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              width: double.infinity,
              child: AppButton(mainColor, () {
                Navigator.of(context).pop(); // goes back to parent widget
                Navigator.of(context).pop();
              }, "Continue"),
            )
          ],
        ),
      );
    }));

Future showLogoutModal(context) => showModalBottomSheet(
    // log out sheet
    backgroundColor: Colors.transparent,
    context: context,
    builder: ((context) {
      return Container(
        decoration: const BoxDecoration(
            color: white,
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        height: 310,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'images/qmark2.svg',
            ),
            colSpace(20),
            appText("Sign out", 16, Colors.black),
            colSpace(20),
            appText(
                "The entered space is does not belong to your current building\nPlease click Sign out to be able to change building",
                14,
                grey,
                align: TextAlign.center),
            colSpace(40),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              width: double.infinity,
              child: AppButton(mainColor, () {
                Navigator.of(context).pop();
              }, "Return"),
            ),
            colSpace(5),
            Container(
              margin: const EdgeInsets.only(left: 30, right: 30),
              width: double.infinity,
              child: AppButton(yellowColor, () {
                Navigator.of(context).pop();
                FirebaseAuth.instance.signOut();
                context.goNamed('home');
              }, "Sign out"),
            )
          ],
        ),
      );
    }));

Future<dynamic> wait(int milliseconds) =>
    Future.delayed(Duration(milliseconds: milliseconds));

SizedBox rowSpace(double space) => SizedBox(
      // add horizontal space (double) between widgets
      width: space,
    );
SizedBox colSpace(double space) => SizedBox(
      // add vertical space (double) between widgets
      height: space,
    );

Center progressIndicator() => const Center(
      // spinner (for loading)
      child: CircularProgressIndicator(
        color: mainColor,
      ),
    );

Text appText(
        String text, double fontSize, Color color, // simple text custom made
        {TextAlign align = TextAlign.start,
        FontWeight fontWeight = FontWeight.normal}) =>
    Text(
      text,
      style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          height: 1.5),
      textAlign: align,
    );

class CodeInput extends StatelessWidget {
  final TextEditingController controller; // every input should have a controller
  final FocusNode node; // target node when we input a number
  final void Function(String) onChanged;
  final bool enabled;
  const CodeInput(this.controller, this.onChanged, this.node,
      {this.enabled = true, super.key});
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged, // when we changes the number, execute this action
      maxLength: 1, // just one number per input
      // obscureText: true,
      // obscuringCharacter: "*",
      inputFormatters: <TextInputFormatter>[
        FilteringTextInputFormatter.digitsOnly
      ],
      enabled:
          enabled, // for example when it's loading you cannot change the input
      keyboardType: TextInputType.number,
      focusNode: node,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      style: const TextStyle(fontWeight: FontWeight.bold),
      decoration: InputDecoration(
          counterText: "",
          contentPadding: const EdgeInsets.all(0),
          border: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),
          ),
          fillColor: lightColor,
          filled: true),
    );
  }
}
