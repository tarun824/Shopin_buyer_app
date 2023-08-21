import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MainAppbar {
  PreferredSizeWidget appbar(ctx) {
    return (Platform.isIOS
        ? CupertinoNavigationBar(
            middle: const Text(
              'Logo',
            ),
            trailing: Row(
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.heart_fill),
                  onPressed: () {
                    Navigator.pushNamed(ctx, "/favarateScreen");
                  },
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  child: const Icon(CupertinoIcons.shopping_cart),
                  onPressed: () {
                    Navigator.pushNamed(ctx, "/cartScreen");
                  },
                )
              ],
            ),
          )
        : AppBar(
            elevation: 0,
            centerTitle: true,
            title: const Text(
              "Logo",
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
