import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const sideTopPadding = Constants.sideTopPadding;
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "About"),
        body: Padding(
          padding: sideTopPadding,
          child: Column(
            children: [
              Text(
                "About",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                " This app has wide range of such as cart\n",
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                "Thank you \n Tarun R S",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
