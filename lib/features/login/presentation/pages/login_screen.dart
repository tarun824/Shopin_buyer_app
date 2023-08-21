import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';

import '../widgets/textfields_login.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const borderRadius = Constants.borderRadius;
  static const sidePadding = Constants.sidePadding;
  bool isSignUp = true;

  @override
  Widget build(BuildContext context) {
    final mediaQueryHeight = MediaQuery.of(context).size.height;
    final mediaQueryWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 31.2, left: 31.3),
                  child: Container(
                    padding: sidePadding,
                    color: Colors.amber,
                    width: mediaQueryWidth,
                    height: 450,
                    child: Column(
                      children: [
                        TextFieldLogin(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
