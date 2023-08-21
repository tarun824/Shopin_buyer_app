// import 'dart:ffi';

import 'package:buyer/features/sign_up/data/services/create_db_new_user_service.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/textfield_input_decoration.dart';
import 'package:flutter/material.dart';

class SignupDataCollectionScreen extends StatefulWidget {
  final Map<String, String> userdata;
  SignupDataCollectionScreen({super.key, required this.userdata});
  @override
  State<SignupDataCollectionScreen> createState() =>
      _SignupDataCollectionScreenState();
}

class _SignupDataCollectionScreenState
    extends State<SignupDataCollectionScreen> {
  final sideTopPadding = Constants.sideTopPadding;

  TextEditingController _userNameController = TextEditingController();
  TextEditingController _phNumberController = TextEditingController();
  TextEditingController _sideAddressController = TextEditingController();
  TextEditingController _cityController = TextEditingController();
  TextEditingController _countryController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  TextEditingController _pinNumberController = TextEditingController();

  final _phnumberFocusNode = FocusNode();
  final _sideAddressFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final _pinNumberFocusNode = FocusNode();

  String _userName = '';
  int _phNumber = 0;
  String _sideAddress = '';
  String _city = '';
  String _country = '';
  String _state = '';
  int _pinNumber = 0;

  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _phnumberFocusNode.dispose();
    _sideAddressFocusNode.dispose();
    _cityFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _pinNumberFocusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _mediaQueryHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
        child: Padding(
          padding: sideTopPadding,
          child: SizedBox(
            height: _mediaQueryHeight * 0.9,
            width: _mediaQueryWidth,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Fill your Details",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(
                  thickness: 2,
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 15.0),
                  child: Text("Enter your Name"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _userNameController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_phnumberFocusNode);
                    },
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration(
                            "Name", "Your Name", "Enter Valid Name"),
                    onChanged: (value) {
                      _userName = value;
                    },
                  ),
                ),
                const Text("Enter Phone Number"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _phNumberController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    onSubmitted: (_) {
                      FocusScope.of(context)
                          .requestFocus(_sideAddressFocusNode);
                    },
                    focusNode: _phnumberFocusNode,
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration("Phone Number",
                            "Phone number", "Enter Valid phone number"),
                    onChanged: (value) {
                      _phNumber = int.parse(value);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    " Delivery Address",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                const Text("Enter Address"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _sideAddressController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_cityFocusNode);
                    },
                    focusNode: _sideAddressFocusNode,
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration(
                            "Address",
                            "Road,apartment,building,floor,etc.",
                            "Enter Valid Address"),
                    onChanged: (value) {
                      _sideAddress = value;
                    },
                  ),
                ),
                const Text("Enter city"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _cityController,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) {
                      FocusScope.of(context).requestFocus(_countryFocusNode);
                    },
                    focusNode: _cityFocusNode,
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration(
                            "City", "City", "Enter Valid City"),
                    onChanged: (value) {
                      _city = value;
                    },
                  ),
                ),
                SizedBox(
                  height: 90,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 92,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text("Enter Country"),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 5.0),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _countryController,
                                textInputAction: TextInputAction.next,

                                onSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_stateFocusNode);
                                },
                                focusNode: _countryFocusNode,
                                decoration: const InputDecoration(
                                  hintText: "  Country",
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 2, vertical: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        Constants.textFieldBorderRadius,
                                  ),
                                ),

                                //st parameter label,2nd hint Text ,3rd Error message

                                onChanged: (value) {
                                  _country = value;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 92,
                        width: 170,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Enter State"),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 5.0),
                              child: TextField(
                                textAlignVertical: TextAlignVertical.center,
                                controller: _stateController,
                                textInputAction: TextInputAction.next,

                                onSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_pinNumberFocusNode);
                                },
                                focusNode: _stateFocusNode,
                                decoration: const InputDecoration(
                                  hintText: "  Phone number",
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 18),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        Constants.textFieldBorderRadius,
                                  ),
                                ),

                                //     //st parameter label,2nd hint Text ,3rd Error message

                                onChanged: (value) {
                                  _state = value;
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Text("Enter Pin Number"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: _pinNumberController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    focusNode: _pinNumberFocusNode,
                    decoration: TextfieldInputDecoration()
                        //st parameter label,2nd hint Text ,3rd Error message
                        .textfieldInputDecoration("Pin Number", "Pin Number",
                            "Enter Valid Pin Number"),
                    onChanged: (value) {
                      _pinNumber = int.parse(value);
                    },
                  ),
                ),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 8),
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                final a = "nope";
                                print(widget.userdata["userId"]);
                                print(widget.userdata["emailId"]);

                                if (widget.userdata["userID"] == null ||
                                    widget.userdata["userID"].toString() ==
                                        "null" ||
                                    widget.userdata["userID"].toString() ==
                                        "Null") {
                                  final a = "bro yaa";
                                }
                                final address = {
                                  "sideAddress": _sideAddress,
                                  "city": _city,
                                  "country": _country,
                                  "state": _state,
                                  "pinNumber": _pinNumber,
                                };
                                final sendJson = {
                                  "userId":
                                      widget.userdata["userId"].toString(),
                                  "emailId":
                                      widget.userdata["emailId"].toString(),
                                  "name": _userName,
                                  "phNumber": _phNumber,
                                  "address": address,
                                };
                                await CreateDbNewUserService()
                                    .createUser(sendJson);
                                print(_userName +
                                    widget.userdata["userID"].toString() +
                                    widget.userdata["emailId"].toString() +
                                    _phNumber.toString() +
                                    _sideAddress +
                                    _city +
                                    _country +
                                    _state +
                                    _pinNumber.toString());
                                Navigator.pushReplacementNamed(
                                    context, "/mainPageNavigator",
                                    arguments: widget.userdata["userId"]);

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                              child: const Text("Submit")),
                        ),
                      ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}
