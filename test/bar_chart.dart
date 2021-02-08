// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';

// class BarChart extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.all(5.0),
//       child: Column(
//         children: <Widget>[
//           Text(
//             'Weekly Spending',
//             style: TextStyle(
//                 fontSize: 20.0,
//                 fontWeight: FontWeight.bold,
//                 letterSpacing: 1.2,
//                 fontFamily: 'Montserrat'),
//           ),
//           SizedBox(height: 5.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(Icons.arrow_back),
//                 iconSize: 30.0,
//                 onPressed: () {},
//               ),
//               Text(
//                 'Feb 10.2020 - Feb 16.2020',
//                 style: TextStyle(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 14.0,
//                     letterSpacing: 1.5,
//                     fontFamily: 'Montserrat'),
//               ),
//               IconButton(
//                 icon: Icon(Icons.arrow_forward),
//                 iconSize: 30.0,
//                 onPressed: () {},
//               ),
//             ],
//           ),
//           SizedBox(height: 30.0),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: <Widget>[
//               Bar(
//                 label: 'Su',
//               ),
//               Bar(
//                 label: 'Mo',
//               ),
//               Bar(
//                 label: 'Tu',
//               ),
//               Bar(
//                 label: 'We',
//               ),
//               Bar(
//                 label: 'Th',
//               ),
//               Bar(
//                 label: 'Fr',
//               ),
//               Bar(
//                 label: 'Sa',
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
