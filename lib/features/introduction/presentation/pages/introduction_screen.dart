import 'package:buyer/l10n/select_language_screen.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen> {
  static const sideTopPadding = Constants.sideTopPadding;
  final controller = PageController(initialPage: 0);
  int index = 0;
  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;

    return SafeArea(
        child: Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: PageView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller,
          children: [
            const SelectLanguageScreen(),
            Container(
              height: _mediaQueryHeight * 0.8,
              width: _mediaQueryWidth * 0.7,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(22)),
              child: Image.asset(
                "assets/images/introduction image2.jpg",
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: sideTopPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      height: _mediaQueryHeight * 0.4,
                      width: _mediaQueryWidth * 0.8,
                      child: Image.asset(
                          fit: BoxFit.fill,
                          "assets/images/introduction image3.jpg"),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.alreadyHaveAccount,

                      // "Already have an Account,",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                      height: _mediaQueryHeight * 0.07,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/login");
                          },
                          child: Text(
                            AppLocalizations.of(context)!.logIn,

                            // "Login"
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 25.0, bottom: 5),
                    child: Text(
                      AppLocalizations.of(context)!.createAccount
                      // "Create an account,"
                      ,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                      height: _mediaQueryHeight * 0.07,
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, "/signup");
                          },
                          child: Text(
                            AppLocalizations.of(context)!.signup,

                            // "SignIn"
                          ))),
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: Center(
                      child: TextButton(
                        child: const Text("Guest"),
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, "/mainPageNavigator",
                              arguments: null);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        height: _mediaQueryHeight * 0.15,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
                onPressed: () {
                  // ** if we use duration then then that dot will not expand as there will be dealy so this is best
                  controller.jumpToPage(
                    2,
                  );
                  index = controller.page!.toInt();
                  setState(() {});
                },
                child: Text(
                  AppLocalizations.of(context)!.skip,

                  // "Skip"
                )),
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    controller.jumpToPage(
                      0,
                    );
                    index = controller.page!.toInt();
                    setState(() {});
                  },
                  child: Container(
                    height: 12,
                    width: index == 0 ? 30 : 13, //if selected then 30 or 13
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: GestureDetector(
                    onTap: () {
                      controller.jumpToPage(
                        1,
                      );
                      index = controller.page!.toInt();
                      setState(() {});
                    },
                    child: Container(
                      height: 12,
                      width: index == 1 ? 30 : 13,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(22)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    controller.jumpToPage(
                      2,
                    );
                    index = controller.page!.toInt();
                    setState(() {});
                  },
                  child: Container(
                    height: 12,
                    width: index == 2 ? 30 : 13,
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(22)),
                  ),
                ),
              ],
            ),
            index < 2
                ? ElevatedButton(
                    onPressed: () {
                      if (index < 2) {
                        index = controller.page!.toInt() + 1;
                      }
                      print(index);
                      setState(() {});
                      controller.nextPage(
                          duration: const Duration(milliseconds: 1),
                          curve: Curves.easeInOut);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.next,

                      // "Next"
                    ))
                : ElevatedButton(
                    onPressed: () {
                      if (index >= 0) {
                        index = controller.page!.toInt() - 1;
                      }
                      print(index);
                      setState(() {});
                      controller.previousPage(
                          duration: const Duration(milliseconds: 1),
                          curve: Curves.easeInOut);
                    },
                    child: const Text("back")),
          ],
        ),
      ),
    ));
  }
}
