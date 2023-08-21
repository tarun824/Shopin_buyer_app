// import 'package:buyer/utilities/textfield_input_decoration.dart';
// import 'package:flutter/material.dart';

// class TextFieldWithHeadingWidget extends StatelessWidget {
//   // const TextFieldWithHeadingWidget({super.key});
//   TextFieldWithHeadingWidget(
//      {required this.heading, required this.controller, required this.focusNode, required this.labelText, required this.hintText, required this.errorText});
//   final String heading,labelText, hintText, errorText;
//   final TextEditingController controller;
//   final FocusNode focusNode; 
//   final String 
  


//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(heading),
//         Padding(
//           padding: const EdgeInsets.only(top: 5.0, bottom: 15),
//           child: TextField(
//             // style: TextStyle(
//             //   height: 3,
//             // ),
//             textAlignVertical: TextAlignVertical.center,
//             controller: controller,
//             textInputAction: TextInputAction.next,
//             // keyboardType: TextInputType.multiline,
//             onSubmitted: (_) {
//               FocusScope.of(context).requestFocus(focusNode);
//             },
//             decoration: TextfieldInputDecoration()
//                 //st parameter label,2nd hint Text ,3rd Error message
//                 .textfieldInputDecoration(labelText, hintText, errorText),
//             onChanged: (value) {
//               _signupId = value;
//             },
//           ),
//         ),
//       ],
//     );
//     ;
//   }
// }
