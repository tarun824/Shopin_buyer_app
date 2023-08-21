import 'package:buyer/features/Home/presentation/state_management/user_data_provider.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/drawer/widget/drawer_button.dart';
import 'package:buyer/features/logout/data/services/logout_service.dart';
import 'package:buyer/utilities/color_theme.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/theme_mode_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SideDrawer extends StatefulWidget {
  const SideDrawer({super.key});

  @override
  State<SideDrawer> createState() => _SideDrawerState();
}

class _SideDrawerState extends State<SideDrawer> {
  final _allPadding = Constants.allPadding;
  int coins = 0;
  dynamic _userId = "";
  String userName = "userName";
  String status = "";
  String profileurl = "";
  String emailId = "";
  int phNumber = 0;
  Map<String, dynamic> address = {};

  bool _isLoading = false;

  Future fetchUserData() async {
    if (mounted) {
      setState(() {});
    }
    _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null) {
      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);

      final broref = forId.snapshots(); //geting all the docs snapshorts
      await broref.listen((element) {
        //just listening so that will update on change in database

        print(
            'element is ${element.data()}'); //we get all the field printed here
        profileurl = element["profileurl"];
        emailId = element["emailId"];
        phNumber = element["phNumber"];
        address = element["address"];

        element.data()!.forEach((key, value) {
          //here we are intarating through all the map inside field
          if (key == 'name') {
            userName = value;
          }

          if (key == 'coins') {
            coins = value;
          }
          if (key == 'status') {
            status = value;
          }
          if (userName != "" && coins != 0 && status != "") {
            _isLoading = false;
            if (mounted) setState(() {});
          }
        });
      });
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    final tongelTheme = Provider.of<ThemeProvider>(context, listen: true);
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);
    final userDataInfo = userDataProvider.userData;
    return Drawer(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(builder: (contex, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: _allPadding,
                      color: Theme.of(context).primaryColor,
                      height: constraints.minHeight * 0.30,
                      width: constraints
                          .maxWidth, //i have changed  to maxWidth here
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                  splashColor:
                                      const Color.fromRGBO(148, 156, 176, 1),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  icon:
                                      Icon(Icons.adaptive.arrow_back_rounded)),
                            ],
                          ),
                          (MediaQuery.of(context).orientation ==
                                  Orientation.portrait)
                              ? Center(
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    radius: 50,
                                    child: ClipOval(
                                      child: Image.asset(
                                          "assets/images/profile.jpg"),
                                    ),
                                  ),
                                )
                              : Container(),
                          Text(
                            _userId != null ? userName : "Your Name",
                            style: Theme.of(context).textTheme.headline6,
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: Constants.allPadding,
                      height: 60,
                      width: double.infinity,
                      child: TextButton.icon(
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            Navigator.popAndPushNamed(
                                context, "/orderHistoryListScreen",
                                arguments: {
                                  "isGroupHistoryOrder": false,
                                  "groupId": "",
                                });
                          },
                          icon: const Icon(
                            Icons.border_all_rounded,
                            color: Color.fromRGBO(104, 126, 255, 1),
                          ),
                          label: Text(
                              AppLocalizations.of(context)!.orderHistory,
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                    Container(
                      padding: Constants.allPadding,
                      height: 60,
                      width: double.infinity,
                      child: TextButton.icon(
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            // onPressed
                            Navigator.popAndPushNamed(context, "/coinScreen",
                                arguments: {
                                  "coin": coins,
                                  "userName": userName,
                                  "status": status,
                                });
                          },
                          icon: const Icon(
                            Icons.currency_rupee_rounded,
                            color: Color.fromRGBO(104, 126, 255, 1),
                          ),
                          label: Text(AppLocalizations.of(context)!.coins,
                              // "Coins",
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                    Container(
                      padding: Constants.allPadding,
                      height: 60,
                      width: double.infinity,
                      child: TextButton.icon(
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () {
                            // onPressed
                            Navigator.popAndPushNamed(context, "/profileScreen",
                                arguments: {
                                  "userName": userName,
                                  "coins": coins,
                                  "status": status,
                                  "profileurl": profileurl,
                                  "emailId": emailId,
                                  "phNumber": phNumber,
                                  "address": address,
                                });
                          },
                          icon: const Icon(
                            Icons.account_circle_outlined,
                            color: Color.fromRGBO(104, 126, 255, 1),
                          ),
                          label: Text(AppLocalizations.of(context)!.profile,
                              // "Profile",
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.theme,
                          ),
                          Switch.adaptive(
                              value: tongelTheme.isDarkMode,
                              onChanged: (bool) {
                                tongelTheme.toggleTheme(bool);
                                if (mounted) setState(() {});
                              }),
                        ],
                      ),
                    ),
                    DrawerButton(
                      contex,
                      Icons.language_rounded,
                      "/selectLanguageScreen",
                      AppLocalizations.of(context)!.changeLanguage
                      //  "Change Language"
                      ,
                    ),
                    DrawerButton(contex, Icons.question_mark_rounded,
                        "/aboutScreen", AppLocalizations.of(context)!.about
                        // "About"
                        ),
                    Container(
                      padding: Constants.allPadding,
                      height: 60,
                      width: double.infinity,
                      child: TextButton.icon(
                          style: const ButtonStyle(
                            alignment: Alignment.centerLeft,
                          ),
                          onPressed: () async {
                            //delete all user data in local storage
                            if (_userId != null) {
                              Logoutservice().logout();
                              ThemeMode themeMode = ThemeMode.system;
                              await ThemeModeService()
                                  .themeModeServiceWrite(themeMode);

                              Navigator.popAndPushNamed(
                                context,
                                "/introductionScreen",
                              );
                            } else {
                              Navigator.pushReplacementNamed(context, "/login");
                            }
                            ;
                          },
                          icon: Icon(
                            _userId != null
                                ? Icons.logout_outlined
                                : Icons.login_rounded,
                            color: const Color.fromRGBO(104, 126, 255, 1),
                          ),
                          label: Text(
                              _userId != null
                                  ? AppLocalizations.of(context)!.logout
                                  //  "Logout"
                                  : AppLocalizations.of(context)!.logIn
                              // "Login",
                              ,
                              style: Theme.of(context).textTheme.bodyMedium)),
                    ),
                    _userId == null
                        ? Container(
                            padding: Constants.allPadding,
                            height: 60,
                            width: double.infinity,
                            child: TextButton.icon(
                                style: const ButtonStyle(
                                  alignment: Alignment.centerLeft,
                                ),
                                onPressed: () async {
                                  Navigator.pushReplacementNamed(
                                      context, "/signup");
                                },
                                icon: const Icon(
                                  Icons.login_sharp,
                                  color: Color.fromRGBO(104, 126, 255, 1),
                                ),
                                label: Text(
                                    AppLocalizations.of(context)!.signup
                                    // "Signup",
                                    ,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
                          )
                        : const SizedBox(
                            height: 0,
                            width: 0,
                          )
                  ],
                ),
              );
            }),
    );
  }
}
