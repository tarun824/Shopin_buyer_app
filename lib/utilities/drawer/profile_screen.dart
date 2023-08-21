import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key, required this.argument});
  //here we will get userName,user Status,coins
  Map<String, dynamic> argument;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final sideTopPadding = Constants.sideTopPadding;

  int coins = 0;
  String userName = "userName";
  String status = "";
  String profileurl = "";
  String emailId = "";
  int phNumber = 0;
  Map<String, dynamic> address = {};

  @override
  void initState() {
    userName = widget.argument["userName"];
    coins = widget.argument["coins"];
    status = widget.argument["status"];
    profileurl = widget.argument["profileurl"];
    emailId = widget.argument["emailId"];
    phNumber = widget.argument["phNumber"];
    address = widget.argument["address"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NormalAppbar().appbar(context, "Profile"),
      body: userName == "userName"
          ? const Center(
              child: Text("Login to see your Profile "),
            )
          : Padding(
              padding: sideTopPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      height: 180,
                      width: 200,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(22)),
                      child: const Text("data")),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Name: $userName",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "Status: $status",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Coin: $coins",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Phone number: $phNumber",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    "Email Id:: $emailId",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      "Address: ${address["sideAddress"]},${address["city"]},${address["country"]},${address["state"]},${address["pinNumber"]},",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  Text(
                    "Phone number: $coins",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
    ));
  }
}
