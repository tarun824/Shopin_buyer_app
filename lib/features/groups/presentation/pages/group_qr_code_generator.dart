import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupQrCodeGenarator extends StatefulWidget {
  const GroupQrCodeGenarator({super.key, required this.argument});
  static const routeName = "/GroupQrCodeGenarator";
  // here we get groupId ,group name
  final argument;

  @override
  State<GroupQrCodeGenarator> createState() => _GroupQrCodeGenaratorState();
}

class _GroupQrCodeGenaratorState extends State<GroupQrCodeGenarator> {
  TextEditingController _textEditingController = TextEditingController();
  String _groupId = "";
  String _groupname = "";

  @override
  void initState() {
    _groupId = widget.argument["groupId"];
    _groupname = widget.argument["groupName"];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NormalAppbar().appbar(context, "Generate Qr code"),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Card(
                  elevation: 14,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          AppLocalizations.of(context)!.scanMe,
                          // 'Scan Me',
                          style: TextStyle(fontSize: 34),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(21.0),
                        child: Center(
                            child: QrImageView(
                          foregroundColor: Color.fromRGBO(104, 126, 255, 1),
                          data: _groupId,
                          version: QrVersions.auto,
                          size: 300,
                        )),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    _groupname,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    onLongPress: () async {
                      await Clipboard.setData(ClipboardData(text: _groupId));
                      var snackBar = SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.groupIdCopied
                                  // 'Group Id Copied to Clipboard'
                                  ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    onTap: () async {
                      await Clipboard.setData(ClipboardData(text: _groupId));
                      var snackBar = SnackBar(
                          content:
                              Text(AppLocalizations.of(context)!.groupIdCopied
                                  // 'Group Id Copied to Clipboard'
                                  ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    },
                    child: const Card(
                      elevation: 4,
                      child: ListTile(
                        leading: Text("Copy"),
                        trailing: Icon(Icons.content_copy_outlined),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, right: 25, left: 25),
                  child: Text(
                    AppLocalizations.of(context)!.qrCodeNote,
                    // "Note: This group QR code is for a private group, Sharing it with someone will grant them access to the group and the ability to place orders. ",
                    style: Theme.of(context).textTheme.caption,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
