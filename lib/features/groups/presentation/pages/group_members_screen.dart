import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupMembersScreen extends StatefulWidget {
  GroupMembersScreen({super.key, required this.argument});
  //here we get  _groupId
  final argument;
  @override
  State<GroupMembersScreen> createState() => _GroupMembersScreenState();
}

class _GroupMembersScreenState extends State<GroupMembersScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = true;
  String _groupId = "";

  List<Map<String, String>> members = [];
  Future fetchMembers() async {
    _isLoading = true;
    _groupId = widget.argument;

    members = [];
    final forId =
        FirebaseFirestore.instance.collection('/groups/$_groupId/cart');
    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) {
      //just listening so that will update on change in database
      // event.docs.for
      final l = event.docs.length;
      int count = 0;
      event.docs.forEach((element) {
        //getting all the docs in single
        final _userId = element.data()["userId"];
        final _userName = element.data()["userName"];
        members.add({
          "userId": _userId,
          "userName": _userName,
        });
        count++;
      });
      if (count == l) {
        _isLoading = false;
        if (mounted) setState(() {});
      }

      print(members);
    });
  }

  @override
  void initState() {
    super.initState();
    fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: NormalAppbar().appbar(context, "Group Menbers"),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: sideTopPadding,
              child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: members.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      child: ListTile(
                        title: Text(members[index]["userName"].toString()),
                        leading: CircleAvatar(
                          child:
                              ColoredBox(color: Theme.of(context).primaryColor),
                        ),
                      ),
                    );
                  }),
            ),
    ));
  }
}
