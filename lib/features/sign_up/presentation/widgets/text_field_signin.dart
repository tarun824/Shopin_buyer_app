// import 'package:buyer/features/login/data/services/log_in_services.dart';
// import 'package:buyer/features/logout/data/services/logout_service.dart';
// import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
// import 'package:buyer/utilities/constants.dart';
// import 'package:buyer/utilities/textfield_input_decoration.dart';
// import 'package:flutter/material.dart';
// import '../../../../data/data_sources/remote/set_user_data.dart';
// // import '../../data/services/log_in_services.dart';

// class TextFieldSignup extends StatefulWidget {
//   @override
//   State<TextFieldSignup> createState() => _TextFieldSignupState();
// }

// class _TextFieldSignupState extends State<TextFieldSignup> {
//   // const TextFieldLogin({super.key});
//   static const textFieldborderRadius = Constants.textFieldBorderRadius;

//   TextEditingController _loginIDController = TextEditingController();

//   TextEditingController _passwordController = TextEditingController();

//   // final _LoginIdFocusNode = FocusNode();

//   final _passwordFocusNode = FocusNode();

//   String _LoginId = '';

//   String _password = '';

//   void dispose() {
//     super.dispose();
//     // _LoginIdFocusNode.dispose();
//     _passwordFocusNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         TextField(
//           controller: _loginIDController,
//           textInputAction: TextInputAction.next,
//           // keyboardType: TextInputType.multiline,
//           onSubmitted: (_) {
//             FocusScope.of(context).requestFocus(_passwordFocusNode);
//           },
//           decoration: TextfieldInputDecoration()
//               //st parameter label,2nd hint Text ,3rd Error message
//               .textfieldInputDecoration(
//                   "Email ID", "Enter your Email ID", "Enter Valid Email ID"),
//           onChanged: (value) {
//             _LoginId = value;
//           },
//         ),
//         TextField(
//           controller: _passwordController,
//           focusNode: _passwordFocusNode,
//           textInputAction: TextInputAction.done,
//           decoration: TextfieldInputDecoration().textfieldInputDecoration(
//               "Enter Password", "Password", "Wrong Password"),
//           //  InputDecoration(
//           //   hintText: "Password",
//           //   label: Text("Enter Password"),
//           //   errorText: "Wrong Password",
//           //   contentPadding: EdgeInsets.symmetric(horizontal: 3, vertical: 3),
//           //   enabledBorder: OutlineInputBorder(
//           //     borderRadius: textFieldborderRadius,
//           //   ),
//           // ),
//           onChanged: (value) {
//             _password = value;
//           },
//         ),
//         ElevatedButton(
//             onPressed: () async {
//               final _userId = await LogInServices().LogIn(_LoginId, _password);
//               Navigator.pushReplacementNamed(context, "/homescreen",
//                   arguments: _userId);
//             },
//             child: Text("Submit")),
//         ElevatedButton(
//             onPressed: () {
//               Logoutservice().logout();
//             },
//             child: Text("Logout")),
//         ElevatedButton(
//             onPressed: () {
//               print(TryAutoLogin().tryAutoLogin());
//             },
//             child: Text("try")),
//       ],
//     );
//   }
// }
