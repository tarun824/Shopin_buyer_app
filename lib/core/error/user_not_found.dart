import 'package:flutter/material.dart';

class UserNotFound {
  userNotFound(ctx, message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: (Colors.black12),
      action: SnackBarAction(
        label: 'dismiss',
        onPressed: () {},
      ),
    );
    return ScaffoldMessenger.of(ctx).showSnackBar(snackBar);
  }
}
