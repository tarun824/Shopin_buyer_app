import 'package:buyer/features/login/data/services/log_in_services.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../utilities/textfield_input_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TextFieldLogin extends StatefulWidget {
  @override
  State<TextFieldLogin> createState() => _TextFieldLoginState();
}

class _TextFieldLoginState extends State<TextFieldLogin> {
  static const textFieldborderRadius = Constants.textFieldBorderRadius;
  static const sideTopPadding = Constants.sideTopPadding;

  TextEditingController _loginIDController = TextEditingController();

  TextEditingController _passwordController = TextEditingController();

  final _passwordFocusNode = FocusNode();

  String _LoginId = '';

  String _password = '';
  bool _passwordVisible = false;

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _passwordFocusNode.dispose();
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: sideTopPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    AppLocalizations.of(context)!.alreadyHaveAccount,
                    // "Aleady have account, Login",
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(fontSize: 25),
                  ),
                ),
                Center(
                  child: SizedBox(
                    height: _mediaQueryHeight * 0.4,
                    width: _mediaQueryWidth * 0.8,
                    child: Image.asset(
                      "assets/images/Login.jpg",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(AppLocalizations.of(context)!.enterEmail
                      // "Enter your Gmail Id"
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _loginIDController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
                    },
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration("Email ID",
                            "example@gmail.com", "Enter Valid Email ID"),
                    onChanged: (value) {
                      _LoginId = value;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: Text(AppLocalizations.of(context)!.enterPassword
                      // "Enter your Password"
                      ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: TextField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.done,
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Theme.of(context).primaryColorDark,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      hintText: "  password",
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 18),
                      enabledBorder: const OutlineInputBorder(
                        borderRadius: textFieldborderRadius,
                      ),
                    ),
                    onChanged: (value) {
                      _password = value;
                    },
                  ),
                ),
                _isLoading
                    ? const Padding(
                        padding: EdgeInsets.only(top: 45.0),
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                if (_LoginId.isEmpty && _password.isEmpty) {
                                  _showErrorDialog("Please Enter Gmail Id ");
                                } else if (_LoginId.isEmpty) {
                                  _showErrorDialog("Please Enter Gmail Id ");
                                } else if (_password.isEmpty) {
                                  _showErrorDialog("Please Enter password ");
                                }
                                if (_LoginId.isNotEmpty &&
                                    _password.isNotEmpty) {
                                  final _userId = await LogInServices()
                                      .LogIn(_LoginId, _password);

                                  if (_userId == null) {
                                    _showErrorDialog(
                                        "Please check internet, Try later");
                                  } else if (_userId[0] != 1) {
                                    _showErrorDialog(_userId[1].toString());
                                  } else {
                                    print(
                                        "This is from try got ha userId Pass");

                                    Navigator.pushReplacementNamed(
                                        context, "/mainPageNavigator",
                                        arguments: _userId[1].toString());
                                  }
                                }
                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: Text(
                                AppLocalizations.of(context)!.submit,
                                // "Submit"
                              )),
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("ok"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
