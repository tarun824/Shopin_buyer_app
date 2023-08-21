import 'dart:io';

import 'package:buyer/features/groups/data/models/groups_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/main_appbar.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/drawer/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({super.key});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = false;
  dynamic _userId = "";

  List<GroupsModel> groups = [];
  bool guestMode = true;
  bool dumyBool = true;

  Future FetchGroups() async {
    groups = [];
    _isLoading = true;
    if (mounted) setState(() {});
    _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null) {
      guestMode = false;
      final forId = FirebaseFirestore.instance
          .collection("/groups/")
          .where("members", arrayContains: _userId);
      QuerySnapshot querySnapshot = await forId.get();
      final broref = forId.snapshots(); //geting all the docs snapshorts
      await broref.listen((event) {
        //just listening so that will update on change in database
        event.docs.forEach((element) {
          //getting all the docs in single
          //we get all the field printed here
          element.data().forEach((key, value) {
            //here we are intarating through all the map inside field
            if (key == 'groupDetails') {
              GroupsModel singleGroup = GroupsModel(
                  groupName: value["groupName"],
                  imgUrl: value["imgUrl"],
                  groupId: value["groupId"]);
              if (!groups.contains(singleGroup) && dumyBool) {
                dumyBool = false;
                groups.add(singleGroup);
              }
            }
          });
        });
        _isLoading = false;
        if (mounted) setState(() {});
      });
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    FetchGroups();
  }

  PreferredSizeWidget appBar(ctx, textForBackButton) {
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
            trailing: PopupMenuButton(
                onSelected: (value) {
                  if (value == "joinGroup") {
                    Navigator.pushNamed(context, "/groupJoinScreen",
                        arguments: _userId);
                  }
                },
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context)!.joinGroup
                            // "Join Group"
                            ),
                        value: "joinGroup",
                      ),
                    ]),
          )
        : AppBar(
            elevation: 0,
            leading: const Tooltip(message: "Group Name", child: BackButton()),
            title: Text(
              textForBackButton,
              style: const TextStyle(color: Colors.white),
            ),
            actions: [
                PopupMenuButton(
                    onSelected: (value) {
                      if (value == "joinGroop") {
                        Navigator.pushNamed(context, "/groupJoinScreen",
                            arguments: _userId);
                      }
                    },
                    itemBuilder: (ctx) => [
                          PopupMenuItem(
                            child: Text(AppLocalizations.of(context)!.joinGroup
                                // "Join Group"
                                ),
                            value: "joinGroop",
                          ),
                        ]),
              ]) as PreferredSizeWidget);
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(child: SideDrawer()),
        appBar: appBar(context, "Groups"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : guestMode
                ? const Center(
                    child: Text("Login to see chat"),
                  )
                : groups.isEmpty
                    ? const Center(
                        child: Text("Join some groups to see here"),
                      )
                    : Padding(
                        padding: sideTopPadding,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: groups.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 4,
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      "/groupChatScreen",
                                      arguments: {
                                        "groupId": groups[index].groupId,
                                        "groupName": groups[index].groupName
                                      },
                                    );
                                  },
                                  child: ListTile(
                                    title: Text(groups[index].groupName),
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      radius: 23,
                                      child: ClipOval(
                                        child: Image.asset(
                                            "assets/images/profile.jpg"),
                                      ),
                                    ),
                                    trailing: const Icon(
                                        Icons.arrow_forward_ios_rounded),
                                  ),
                                ),
                              );
                            }),
                      ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          child: const Icon(Icons.add),
          backgroundColor: const Color.fromRGBO(104, 126, 255, 1),
        ),
      ),
    );
  }
}
