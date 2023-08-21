import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupInfoScreen extends StatefulWidget {
  GroupInfoScreen({super.key, required this.argument});
  // here we get groupName,groupId
  final argument;

  @override
  State<GroupInfoScreen> createState() => _GroupInfoScreenState();
}

class _GroupInfoScreenState extends State<GroupInfoScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  String _groupId = "";
  String _groupName = "";

  void initState() {
    super.initState();
    _groupId = widget.argument["groupId"];
    _groupName = widget.argument["groupName"];
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "Group Info"),
        body: SingleChildScrollView(
          child: Padding(
            padding: sideTopPadding,
            child: Column(children: [
              Container(
                color: Theme.of(context).primaryColor,
                height: _mediaQueryHeight * 0.4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (MediaQuery.of(context).orientation == Orientation.portrait)
                        ? Padding(
                            padding: const EdgeInsets.only(top: 18.0),
                            child: Center(
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                maxRadius: 75,
                                child: ClipOval(
                                  child:
                                      Image.asset("assets/images/profile.jpg"),
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        _groupName,
                        style: Theme.of(context).textTheme.headline2,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      "/groupMembersScreen",
                      arguments: _groupId,
                    );
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Text(AppLocalizations.of(context)!.allMembers),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/orderHistoryListScreen",
                        arguments: {
                          "isGroupHistoryOrder": true,
                          "groupId": _groupId,
                        });
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Text(
                        AppLocalizations.of(context)!.groupOrders,
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/groupCartScreen",
                        arguments: {
                          "groupId": _groupId,
                          "groupName": _groupName
                        });
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Text(AppLocalizations.of(context)!.cart),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, "/groupQrCodeGenarator",
                        arguments: {
                          "groupId": _groupId,
                          "groupName": _groupName,
                        });
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading:
                          Text(AppLocalizations.of(context)!.generateQrCode),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: GestureDetector(
                  onLongPress: () async {
                    await Clipboard.setData(ClipboardData(text: _groupId));
                    var snackBar = const SnackBar(
                        content: Text('Group Id Copied to Clipboard'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  onTap: () async {
                    await Clipboard.setData(ClipboardData(text: _groupId));
                    var snackBar = SnackBar(
                        content:
                            Text(AppLocalizations.of(context)!.groupIdCopied));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  },
                  child: Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Text(AppLocalizations.of(context)!.copyGroupId),
                      trailing: const Icon(Icons.content_copy_outlined),
                    ),
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
