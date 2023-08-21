import 'package:buyer/features/category/presentation/pages/state_management/category_provider.dart';
import 'package:buyer/utilities/app_bar/main_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/drawer/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  //here we get categore endPoint
  final argument;
  CategoryScreen({required this.argument});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final sideTopPadding = Constants.sideTopPadding;

  final sidePadding = Constants.sidePadding;

  // final itemCountNumber = 10;
  bool _isLoading = true;
  List<CategoryClass> categoryList = [];

  Future fetchCategory() async {
    String argumentNavigate = widget.argument["navigate"].toString();
    String argumentCollection = widget.argument["argument"].toString();

    final forId = FirebaseFirestore.instance
        .collection("/category")
        .doc(argumentCollection);

    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) async {
      //just listening so that will update on change in database

      event.data()!.forEach((key, value) {
        if (key == 'categoryDivision') {
          for (int i = 0; i < value.length; i++) {
            final zzz = value[i];
            final vvv = CategoryClass(
                title: zzz["title"],
                imgUrl: zzz['imgUrl'],
                argument: zzz['argument'],
                navigate: zzz['navigate']);
            categoryList.add(vvv);
          }

          _isLoading = false;
          if (mounted) setState(() {});
        } else {}
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchCategory();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _heightOfBox = _mediaQueryHeight * 0.1;
    final _widthOfBox = _mediaQueryWidth * 0.35;
    final _itemCountNumber = categoryList.length;
    final _crossAxisCount = 2;
    final _sizeForSizedBox =
        ((((_itemCountNumber / _crossAxisCount) * 2) + 0.8) * _heightOfBox);

    //logic is (itemCountNumber / crossAxisCount ).greater Number in that if we get some number *2 -2 means
    //minus that number by2 and add 25 just by me ,and 25 may be comoletly base on padding i think

    return SafeArea(
      child: Scaffold(
        drawer: const Drawer(child: SideDrawer()),
        appBar: MainAppbar().appbar(context),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: sideTopPadding,
                  child: Column(
                    children: [
                      SizedBox(
                        height: _sizeForSizedBox,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _itemCountNumber,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                    context, categoryList[index].navigate,
                                    arguments: {
                                      "navigate": categoryList[index].navigate,
                                      "argument": categoryList[index].argument,
                                    }, //go for Home screen with userId
                                  );
                                },
                                child: SizedBox(
                                    height: _heightOfBox,
                                    width: _widthOfBox,
                                    child: Card(
                                        elevation: 4,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Column(
                                            children: [
                                              Container(
                                                height:
                                                    constraints.maxHeight * 0.7,
                                                child: Image.network(
                                                  categoryList[index].imgUrl,
                                                  fit: BoxFit.fill,
                                                  loadingBuilder:
                                                      (BuildContext context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              Expanded(
                                                  child: Center(
                                                child: Text(
                                                  categoryList[index].title,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                              ))
                                            ],
                                          );
                                        }))),
                              );
                            }),
                      ),
                      Padding(
                        padding: sidePadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Advertisement",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("View All"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          height: 200,
                          width: _mediaQueryWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 200,
                                width: 200,
                                padding: const EdgeInsets.only(right: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22)),
                                child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fcategory%2Fadvertising.jpg?alt=media&token=72a273f0-945f-4db0-b285-87e5b6fde62e",
                                  fit: BoxFit.fill,
                                  loadingBuilder: (BuildContext context,
                                      Widget child,
                                      ImageChunkEvent? loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                loadingProgress
                                                    .expectedTotalBytes!
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
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
