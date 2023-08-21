import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class NormalAppbar {
  PreferredSizeWidget appbar(ctx, textForBackButton) {
    return (Platform.isIOS
        ? CupertinoNavigationBar(
            leading: Tooltip(
                message: "Back",
                child: CupertinoButton(
                  child: Icon(Icons.adaptive.arrow_back_rounded),
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                )),
            trailing: Row(
              children: [
                Tooltip(
                  message: "All Favorites",
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.heart_fill),
                    onPressed: () {
                      Navigator.pushNamed(ctx, "/favarateScreen");
                    },
                  ),
                ),
                Tooltip(
                  message: "Cart Items",
                  child: CupertinoButton(
                    padding: EdgeInsets.zero,
                    child: const Icon(CupertinoIcons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(ctx, "/cartScreen");
                    },
                  ),
                )
              ],
            ),
          )
        : AppBar(
            elevation: 0,
            leading: const Tooltip(message: "Back", child: BackButton()),
            title: Text(
              textForBackButton,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
                Tooltip(
                  message: "All Favorites",
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(ctx, "/favarateScreen");
                      },
                      icon: const Icon(Icons.favorite_rounded)),
                ),
                Tooltip(
                  message: "Cart Items",
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(ctx, "/cartScreen");
                      },
                      icon: const Icon(Icons.shopping_cart_rounded)),
                ),
              ]) as PreferredSizeWidget);
  }
}
