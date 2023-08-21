import 'dart:io';

import 'package:buyer/features/groups/data/models/group_messages_model.dart';
import 'package:buyer/features/groups/presentation/pages/widgets/product_message_widget.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/main_appbar.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/drawer/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupChatScreen extends StatefulWidget {
  GroupChatScreen({this.argument});
  //here we get groupId and groupname
  final argument;

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  final _sideTopPadding = Constants.sideTopPadding;
  TextEditingController messageTextController = TextEditingController();
  String messageText = "";
  String _groupId = "";
  String _groupName = "";

  dynamic _userId = "";
  String _userName = "";
  final ScrollController _scrollController = ScrollController();

  List<GroupMessageModel> messages = [];
  bool _isLoading = false;
  bool onesUpdate = true;

  Future fetchChat() async {
    _isLoading = true;
    if (mounted) {
      setState(() {});
    }

    messages = [];
    _groupId = widget.argument["groupId"];
    _groupName = widget.argument["groupName"];

    GroupMessageModel singleMessage = GroupMessageModel(
      message: "message",
      senderId: "senderId",
      senderName: "senderName",
      date: "date",
      productDetails: {},
    );
    _userId = await TryAutoLogin().tryAutoLogin();

    final forId =
        FirebaseFirestore.instance.collection('/groups/').doc(_groupId);
    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((element) {
      //just listening so that will update on change in database

      //getting all the docs in single
      //we get all the field printed here
      element.data()!.forEach((key, value) {
        //here we are intarating through all the map inside field
        if (key == 'messages' && onesUpdate) {
          onesUpdate = false;

          final messagesLength = value.length;
          for (int t = 0; t < messagesLength; t++) {
            if (value[t]["productDetails"]["isProduct"] == true) {
              //we have extra arguments when we have message as product but not in normal
              singleMessage = GroupMessageModel(
                message: value[t]["message"],
                senderId: value[t]["senderId"],
                senderName: value[t]["senderName"],
                date: value[t]["date"],
                productDetails: {
                  "productId": value[t]["productDetails"]["itemId"],
                  "cata": value[t]["productDetails"]["cate"],
                  "isProduct": value[t]["productDetails"]["isProduct"],
                  "title": value[t]["productDetails"]["title"],
                  "imgUrl": value[t]["productDetails"]["imgUrl"],
                  "price": value[t]["productDetails"]["price"],
                  "qty": value[t]["productDetails"]["qty"],
                },
              );
            } else {
              singleMessage = GroupMessageModel(
                message: value[t]["message"],
                senderId: value[t]["senderId"],
                senderName: value[t]["senderName"],
                date: value[t]["date"],
                productDetails: {
                  "isProduct": value[t]["productDetails"]["isProduct"],
                },
              );
            }

            messages.add(singleMessage);
            // }
            if (t == messagesLength - 1) {
              _isLoading = false;

              if (mounted) setState(() {});
              messages = messages.reversed.toList() as List<GroupMessageModel>;
            }
          }
        } else {}
      });
    });
  }

  Future addMessageToDb(textFieldMesage) async {
    Map<String, dynamic> upLoadJson = {};
    final dateTimeNoe = await DateTime.now();
    String formattedDateToUpload =
        await DateFormat('yyyy-MM-dd – kk:mm').format(dateTimeNoe);
    if (textFieldMesage.productDetails["isProduct"] == true) {
      upLoadJson = {
        "message": textFieldMesage.message,
        "senderId": _userId,
        "senderName": _userName,
        "date": formattedDateToUpload,
        "productDetails": {
          "isProduct": true,
          "title": "Product Title",
          "qty": 10,
          "price": 150,
        },
      };
    } else {
      upLoadJson = {
        "message": textFieldMesage.message,
        "senderId": _userId,
        "senderName": _userName,
        "date": formattedDateToUpload,
        "productDetails": {
          "isProduct": false,
        }
      };
    }

    final forId =
        FirebaseFirestore.instance.collection('/groups/').doc(_groupId);
    forId.update({
      "messages": FieldValue.arrayUnion([upLoadJson])
    });
    messageTextController.clear();
  }

  Future fetchName() async {
    _userId = await TryAutoLogin().tryAutoLogin();

    final forId =
        FirebaseFirestore.instance.collection('/buyers/').doc(_userId);
    final broref = forId.snapshots(); //geting all the docs snapshorts
    await broref.listen((element2) {
      //just listening so that will update on change in database

      //getting all the docs in single
      //we get all the field printed here
      element2.data()!.forEach((key, value) {
        //here we are intarating through all the map inside field
        if (key == 'name') {
          _userName = value;
        }
      });
    });
  }

  @override
  void initState() {
    if (mounted) {
      fetchChat();
      fetchName();
    }
    super.initState();
  }

  @override
  void dispose() {
    messageTextController.dispose();
    super.dispose();
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
                  if (value == "info") {
                    Navigator.pushNamed(context, "/groupInfoScreen",
                        arguments: {
                          "groupId": _groupId,
                          "groupName": _groupName,
                        });
                  }
                },
                itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: Text(AppLocalizations.of(context)!.info),
                        value: "info",
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
                      if (value == "info") {
                        Navigator.pushNamed(context, "/groupInfoScreen",
                            arguments: {
                              "groupId": _groupId,
                              "groupName": _groupName,
                            });
                      }
                    },
                    itemBuilder: (ctx) => [
                          PopupMenuItem(
                            child: Text(AppLocalizations.of(context)!.info
                                // "Info"
                                ),
                            value: "info",
                          ),
                        ]),
              ]) as PreferredSizeWidget);
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.36;
    final _widthOfBox = _mediaQueryWidth;
    final _itemCountNumber = 10;
    final _crossAxisCount = 2;
    final _sizeForSizedBox = _mediaQueryHeight * 0.76;
    return SafeArea(
      child: Scaffold(
        drawer: const SideDrawer(),
        appBar: appBar(context, _groupName),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: _sideTopPadding,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          reverse: true,
                          controller: _scrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            return !messages[index].productDetails["isProduct"]
                                ? messages[index].senderId == _userId
                                    ? MessageByMe(messages[index].message)
                                    : MessageByOthers(messages[index].message)
                                : ProductMessageWidget(
                                    message: messages[index].message,
                                    addedBy: messages[index].senderName,
                                    heightOfBox: _heightOfBox,
                                    imageUrl: messages[index]
                                        .productDetails["imgUrl"][0],
                                    productTitle:
                                        messages[index].productDetails["title"],
                                    newPrice:
                                        messages[index].productDetails["price"],
                                    totalAmount: messages[index]
                                        .productDetails["price"]);
                          }),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 52,
                            width: _mediaQueryWidth * 0.8,
                            child: TextField(
                              controller: messageTextController,
                              onChanged: (value) {
                                messageText = value;
                              },
                              decoration: InputDecoration(
                                  focusColor:
                                      Theme.of(context).colorScheme.primary,
                                  label: const Text('Message'),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 3, vertical: 3),
                                  enabledBorder: const OutlineInputBorder(
                                    borderRadius:
                                        Constants.textFieldBorderRadius,
                                  ),
                                  suffixIcon: IconButton(
                                      splashRadius: 18,
                                      onPressed: () {
                                        if (messageText != null) {
                                          GroupMessageModel textFieldMesage =
                                              GroupMessageModel(
                                                  message: messageText,
                                                  senderId: _userId,
                                                  senderName: _userName,
                                                  date:
                                                      DateTime.now().toString(),
                                                  productDetails: {
                                                "isProduct": false
                                              });
                                          messages = messages.reversed.toList()
                                              as List<GroupMessageModel>;

                                          messages.add(textFieldMesage);
                                          messages = messages.reversed.toList()
                                              as List<GroupMessageModel>;

                                          setState(() {});
                                          _scrollController
                                              .position.maxScrollExtent;

                                          addMessageToDb(textFieldMesage);
                                        }
                                      },
                                      icon: const Icon(Icons.send_rounded))),
                            ),
                          ),
                          IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.attach_file_rounded)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Padding MessageByOthers(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                      color: Color.fromRGBO(104, 126, 255, 1),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                        bottomRight: Radius.circular(22),
                      )),
                  child: Text(text))),
          const SizedBox(
            width: 50,
          ),
        ],
      ),
    );
  }

  Padding MessageByMe(String text) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(
            width: 50,
          ),
          Flexible(
              child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: const BoxDecoration(
                      color: Colors.lightGreen,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(22),
                        topRight: Radius.circular(22),
                        bottomLeft: Radius.circular(22),
                      )),
                  child: Text(
                    text,
                  )))
        ],
      ),
    );
  }
}
