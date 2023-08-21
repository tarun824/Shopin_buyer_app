import 'package:buyer/features/Home/presentation/pages/home_screen.dart';
import 'package:buyer/features/category/presentation/pages/category_screen.dart';
import 'package:buyer/features/groups/presentation/pages/groups_screen.dart';
import 'package:buyer/utilities/drawer/side_drawer.dart';
import 'package:flutter/material.dart';

class MainPageNavigator extends StatefulWidget {
  final argument;
  //here we will get user Id
  MainPageNavigator({super.key, required this.argument});

  @override
  State<MainPageNavigator> createState() => _MainPageNavigatorState();
}

class _MainPageNavigatorState extends State<MainPageNavigator> {
  dynamic _userId = "";
  int currentIndex = 0;
  List pages = [];

  void initState() {
    super.initState();
    _userId = widget.argument;
    pages = [
      HomeScreen(argument: _userId.toString()),
      CategoryScreen(argument: {
        "navigate": "/categoryScreen",
        "argument": "mainCategory"
      }),
      const GroupScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        drawer: const SideDrawer(),
        // appBar: MainAppbar().appbar(context),
        body: pages[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            fixedColor: Theme.of(context).primaryColor,
            // backgroundColor: Colors.amber,
            type: BottomNavigationBarType.shifting,
            currentIndex: currentIndex,
            onTap: (value) {
              setState(() {
                currentIndex = value;
              });
            },
            showUnselectedLabels: false,
            unselectedItemColor: const Color.fromRGBO(104, 126, 255, 1),
            items: const [
              BottomNavigationBarItem(
                  label: "Home",
                  icon: Icon(
                    Icons.home_rounded,
                  ),
                  tooltip: "Home Page"),
              BottomNavigationBarItem(
                  label: "Search",
                  icon: Icon(Icons.search_rounded),
                  tooltip: "Search For Item"),
              BottomNavigationBarItem(
                  label: "Groups",
                  icon: Icon(Icons.chat_rounded),
                  tooltip: "Groups Page"),
            ]),
      ),
    );
  }
}
