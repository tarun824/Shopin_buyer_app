import 'package:flutter/material.dart';

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile; //for mobile
  final Widget tab; //for tab
  final Widget destop; //this will soon uncommit this add required this.destop

  ResponsiveWidget(
      {super.key,
      required this.mobile,
      required this.tab,
      required this.destop});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, Constraints) {
      if (Constraints.maxWidth < 700) {
        return mobile;
      }
      if (Constraints.maxWidth >= 700 && Constraints.maxWidth < 1200) {
        return tab;
      } else {
        return destop;
      }
    });
  }
}
