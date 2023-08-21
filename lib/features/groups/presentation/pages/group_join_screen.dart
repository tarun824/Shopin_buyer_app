import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:buyer/utilities/textfield_input_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GroupJoinScreen extends StatefulWidget {
  GroupJoinScreen({super.key, required this.argument});
  //here we get user Id
  final argument;

  @override
  State<GroupJoinScreen> createState() => _GroupJoinScreenState();
}

class _GroupJoinScreenState extends State<GroupJoinScreen> {
  final sideTopPadding = Constants.sideTopPadding;

  TextEditingController _groupIdController = TextEditingController();
  String _groupId = '';
  String _groupName = '';
  String _imgUrl = '';

  String _userId = "";

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
  }

  Future addToGroup(String groupIdArgument) async {
    _userId = widget.argument;
//will add at groups ->members and in buyers->GroupsIn
    final forgroup =
        FirebaseFirestore.instance.collection("/groups/").doc(groupIdArgument);
    forgroup.update({
      "members": FieldValue.arrayUnion([_userId])
    });
    final broref = forgroup.snapshots(); //geting all the docs snapshorts
    await broref.listen((element) {
      //just listening so that will update on change in database

      //getting all the docs in single
      //we get all the field printed here
      element.data()!.forEach((key, value) {
        //here we are intarating through all the map inside field
        if (key == 'groupDetails') {
          _groupName = value["groupName"];
          _imgUrl = value["imgUrl"];
          final foruserUpdate =
              FirebaseFirestore.instance.collection("/buyers/").doc(_userId);
          final groupUpload = {
            "groupName": _groupName,
            "imgUrl": _imgUrl,
            "groupId": groupIdArgument
          };
          foruserUpdate.update({
            "groupsIn": FieldValue.arrayUnion([groupUpload])
          });
        }
      });
      final documentToCreateUserIngroup = FirebaseFirestore.instance
          .collection('/groups/$groupIdArgument/cart')
          .doc(_userId);
      final uploadJsonToGroup = {
        "cart": [],
        "userId": _userId,
        "userName": "userName"
      };

      documentToCreateUserIngroup.set(uploadJsonToGroup);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NormalAppbar().appbar(context, "Join Group"),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: sideTopPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0, bottom: 8),
                    child: Text(
                      AppLocalizations.of(context)!.enterGroupId,
                      // "Enter Group Id"
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: _groupIdController,
                      textInputAction: TextInputAction.next,
                      decoration: TextfieldInputDecoration()
                          //st parameter label,2nd hint Text ,3rd Error message
                          .textfieldInputDecoration(
                              "Group Id", "Group Id", "Enter Group Id")
                          .copyWith(
                              suffixIcon: !(_groupId == '')
                                  ? IconButton(
                                      splashRadius: 18,
                                      onPressed: () {
                                        _groupIdController.clear();
                                      },
                                      icon: const Icon(
                                        Icons.cancel_rounded,
                                      ))
                                  : const SizedBox()),
                      onChanged: (value) {
                        _groupId = value;
                      },
                    ),
                  ),
                  SizedBox(
                      height: 52,
                      width: double.infinity,
                      child: ElevatedButton(
                          child: Text(AppLocalizations.of(context)!.joinGroup),
                          onPressed: () {
                            addToGroup(_groupId);
                          }))
                ],
              ),
            ),
    ));
  }
}
