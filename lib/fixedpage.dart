// import 'package:comfortline/code.dart';

// import 'package:comfortline/functions/functions.dart';
// import 'package:comfortline/globals.dart';
// import 'package:comfortline/material.dart';
// import 'package:comfortline/welcome.dart';
// import 'package:flutter/material.dart';
// // ignore: depend_on_referenced_packages
// import 'package:flutter_svg/flutter_svg.dart';

// class FixedPage extends StatefulWidget {
//   String space;
//   FixedPage({required this.space, super.key});

//   @override
//   State<FixedPage> createState() => _FixedPageState();
// }

// class _FixedPageState extends State<FixedPage> {
//   Map data = {};
//   // bool edit = false;
//   bool loading = false;
//   bool loadOptions = false;
//   bool q1changed = false;
//   bool q2changed = false;
//   int q1 = -1;
//   String q2 = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backColor,
//       body: Stack(children: [
//         Container(
//           height: 250,
//           width: double.infinity,
//           color: mainColor,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               colSpace(50),
//               SvgPicture.asset(
//                 'images/logo.svg',
//               ),
//               colSpace(60),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // SvgPicture.asset(
//                   //   'images/qmark.svg',
//                   // ),
//                   // rowSpace(10),
//                   appText("Welcome to space ${widget.space}", 22, white),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         Container(
//           margin: const EdgeInsets.fromLTRB(15, 220, 15, 15),
//           padding: const EdgeInsets.all(15),
//           width: double.infinity,
//           decoration: BoxDecoration(
//               color: Colors.white, borderRadius: BorderRadius.circular(20)),
//           alignment: Alignment.topCenter,
//           // height: 520.0,
//           child: FutureBuilder(
//               future: readData('users'),
//               builder: (BuildContext context, AsyncSnapshot snapshot) {
//                 if (snapshot.connectionState == ConnectionState.done ||
//                     data.isNotEmpty) {
//                   if (snapshot.data.value['fixedDeskAnswer'] == 1 &&
//                       data.isEmpty) {
//                     q1 = 1;
//                   } else if (snapshot.data.value['fixedDeskAnswer'] == 0 &&
//                       data.isEmpty) {
//                     q1 = 0;
//                   }
//                   if (snapshot.data.value['individualOpenAnswer'] == 'i' &&
//                       data.isEmpty) {
//                     q2 = 'i';
//                   } else if (snapshot.data.value['individualOpenAnswer'] ==
//                           'o' &&
//                       data.isEmpty) {
//                     q2 = 'o';
//                   }
//                   if (data.isEmpty) data = snapshot.data.value;
//                   return SingleChildScrollView(
//                     child: Column(
//                       children: [
//                         AnimatedRotation(
//                           turns: 10,
//                           duration: const Duration(milliseconds: 500),
//                           child: Image.asset("images/gear.png"),
//                         ),
//                         colSpace(20),
//                         appText(
//                             "Please reply to the following questions to help building your profile.",
//                             15,
//                             mainColor,
//                             fontWeight: FontWeight.w600),
//                         colSpace(30),
//                         questionButton(
//                           () {},
//                           "Do you have a fixed desk?",
//                           child: SizedBox(
//                             height: 30,
//                             child: Row(
//                               children: [
//                                 AppButton(q1 == 1 ? mainColor : grey, () {
//                                   q1changed = true;
//                                   setState(() {
//                                     q1 = 1;
//                                   });
//                                 }, "Yes"),
//                                 rowSpace(15),
//                                 AppButton(q1 == 0 ? mainColor : grey, () {
//                                   q1changed = true;
//                                   setState(() {
//                                     q1 = 0;
//                                   });
//                                 }, "No"),
//                               ],
//                             ),
//                           ),
//                         ),
//                         colSpace(15),
//                         questionButton(
//                           () {},
//                           "Is it an individual office or an open space?",
//                           child: SizedBox(
//                             height: 30,
//                             child: Row(
//                               children: [
//                                 AppButton(q2 == "i" ? mainColor : grey, () {
//                                   q2changed = true;
//                                   setState(() {
//                                     q2 = 'i';
//                                   });
//                                 }, "Indiviual office"),
//                                 rowSpace(15),
//                                 AppButton(q2 == 'o' ? mainColor : grey, () {
//                                   q2changed = true;
//                                   setState(() {
//                                     q2 = 'o';
//                                   });
//                                 }, "Open space"),
//                               ],
//                             ),
//                           ),
//                         ),
//                         colSpace(15),
//                         questionButton(
//                           () {
//                             pushReplace(context, Code(oldcode: data['space']));
//                           },
//                           data['space'] != ''
//                               ? 'You are now in the space (${data['space']}) click to change'
//                               : "Please indicate the office number you are working in",
//                           fixed: true,
//                         ),
//                         colSpace(20),
//                         Container(
//                           margin: EdgeInsets.all(10),
//                           width: double.infinity,
//                           child: AppButton(
//                             mainColor,
//                             () async {
//                               if (q1 != -1 &&
//                                   q2 != '' &&
//                                   data['space'] != null) {
//                                 setState(() {
//                                   loading = true;
//                                 });

//                                 if (q1changed) {
//                                   await newRequest(
//                                       Paths.updateFixedDeskAnswer, q1);
//                                 }
//                                 if (q2changed) {
//                                   await newRequest(
//                                       Paths.updateIndividualOpenAnswer, q2);
//                                 }
//                                 setState(() {
//                                   loading = false;
//                                 });

//                                 // ignore: use_build_context_synchronously
//                                 push(context, WelcomePage());
//                               } else {
//                                 showErrorPopup(
//                                     context, "Please fill the questions");
//                               }
//                             },
//                             "Continue",
//                             loading: loading,
//                           ),
//                         )
//                       ],
//                     ),
//                   );
//                 } else {
//                   return progressIndicator();
//                 }
//               }),
//         ),
//       ]),
//     );
//   }
// }
