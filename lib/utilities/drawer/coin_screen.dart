import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:flutter/material.dart';
import 'package:buyer/utilities/constants.dart';

class CoinScreen extends StatefulWidget {
  CoinScreen({super.key, required this.argument});
  //here we get userName and coin and status
  Map<String, dynamic> argument;

  @override
  State<CoinScreen> createState() => _CoinScreenState();
}

class _CoinScreenState extends State<CoinScreen> {
  final sideTopPadding = Constants.sideTopPadding;

  bool _isloading = false;
  int coins = 0;
  String userName = "";
  String status = "";
  bool guestMode = false;
  @override
  void initState() {
    coins = widget.argument["coin"];
    userName = widget.argument["userName"];
    status = widget.argument["status"];
    if (userName == "userName") {
      guestMode = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NormalAppbar().appbar(context, "Coin"),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : guestMode
              ? const Center(
                  child: Text("Login to see your Status and Coins "),
                )
              : Padding(
                  padding: sideTopPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        userName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Status: $status",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Coins: $coins",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        "Earn more coins to upgrade your status",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
    ));
  }
}
