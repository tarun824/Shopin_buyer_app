import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/groups/data/models/group_cart_model.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupCartScreen extends StatefulWidget {
  GroupCartScreen({super.key, required this.argument});
  //here we get _groupName and _groupId
  final argument;
  @override
  State<GroupCartScreen> createState() => _GroupCartScreenState();
}

class _GroupCartScreenState extends State<GroupCartScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = true;
  List<GroupCartModel> groupCarts = [];
  String _groupId = "";
  String _groupName = "";
  List<CartModel> allCartProducts = [];
  int leangthOfDocument = 0;
  bool goInsideNavigator = false;
  String selectedLanguage = "english";

  int countNumberOfProducts = 0;

  Future fetchGroupCarts() async {
    groupCarts = [];
    _groupId = widget.argument["groupId"];
    _groupName = widget.argument["groupName"];
    final forGroupId =
        FirebaseFirestore.instance.collection('/groups/$_groupId/cart');

    final broref = forGroupId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) {
      //just listening so that will update on change in database

      leangthOfDocument = event.docs.length;
      int lengthOfCartInFetch = 0;
      event.docs.forEach((element) {
        final userIdInsideFetch = element["userId"];
        final userNameInsideFetch = element["userName"];
        element.data().forEach((key, value) {
          List<CartModel> singleUserAllProducts = [];
          if (key == 'cart') {
            final docFromcart = value;
            lengthOfCartInFetch = value.length;
            if (value.length > 0) {
              int count = 0;
              for (int x = 0; x < value.length; x++) {
                //fetch productIds from cart and search in products and add details of products to singleUserAllProducts
                final itemId = value[x]["productId"];
                final cata = value[x]["cata"];
                final dataFromDb =
                    FirebaseFirestore.instance.collection(cata).doc(itemId);
                final broref =
                    dataFromDb.snapshots(); //geting all the docs snapshorts
                broref.listen((event1) {
                  event1.data()!.forEach((key, value1) {
                    if (key == 'productEntities') {
                      final docFromproducts = value1;
                      final singleProduct = CartModel(
                        title: docFromproducts["title"][selectedLanguage],
                        price: docFromproducts["price"],
                        discount: {
                          "admin": docFromproducts["discount"]["admin"],
                          "seller": docFromproducts["discount"]["seller"],
                        },
                        cata: docFromproducts["cata"],
                        imgUrl: docFromproducts["imgUrl"],
                        numberOfItems: docFromcart[x]["numberOfitems"],
                        parameterSelected: docFromcart[x]["parameterSelected"],
                        productId: docFromcart[x]["productId"],
                        review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
                        sellerId: docFromproducts["sellerName"],
                      );

                      if (singleUserAllProducts.contains(singleProduct)) {
                        count++;
                      } else {
                        singleUserAllProducts.add(singleProduct);
                        countNumberOfProducts++;
                        count++;
                      }

                      if (singleUserAllProducts.length == lengthOfCartInFetch) {
                        groupCarts.add(GroupCartModel(
                            cartItems: singleUserAllProducts,
                            userId: userIdInsideFetch,
                            userName: userNameInsideFetch));
                        _isLoading = false;
                        if (mounted) setState(() {});
                      }
                    }
                  });
                });
              }
            } else {
              // if length of items <0

              _isLoading = false;
              if (mounted) setState(() {});
            }

            if (singleUserAllProducts.length == lengthOfCartInFetch) {}
          }

          if (groupCarts.length == leangthOfDocument) {
            // findAllCartProducts();
            _isLoading = false;
            if (mounted) setState(() {});
          }
        });
      });
    });
  }

  Future findAllCartProducts() async {
    allCartProducts = [];
    for (int p = 0; p < leangthOfDocument; p++) {
      for (int i = 0; i < groupCarts[p].cartItems.length; i++) {
        allCartProducts.add(groupCarts[p].cartItems[i]);
      }

      goInsideNavigator = true;
    }
  }

  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();

    fetchGroupCarts();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.24;
    final _widthOfBox = _mediaQueryWidth;
    final _itemCountNumber = countNumberOfProducts;
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "Group cart Items"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : groupCarts.length == 0
                ? const Center(
                    child: Text("Add some products to group cart to see here"),
                  )
                : Padding(
                    padding: sideTopPadding,
                    child: Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: groupCarts.length,
                          itemBuilder: (context, groupCartModelIndex) {
                            return SizedBox(
                              //=99 is for Displaying group Name
                              height: _heightOfBox * _itemCountNumber - 110,
                              width: _widthOfBox,
                              child: Column(
                                children: [
                                  Text(
                                      groupCarts[groupCartModelIndex].userName),
                                  const Divider(
                                    thickness: 2,
                                  ),
                                  Expanded(
                                    child: ListView.builder(
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount:
                                            groupCarts[groupCartModelIndex]
                                                .cartItems
                                                .length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: _heightOfBox,
                                            width: _widthOfBox,
                                            child: Card(
                                                elevation: 4,
                                                child: LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  return Row(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 8.0),
                                                        child: Container(
                                                          height: constraints
                                                              .maxHeight,
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.33,
                                                          child: Image.network(
                                                            groupCarts[
                                                                    groupCartModelIndex]
                                                                .cartItems[
                                                                    index]
                                                                .imgUrl[0],
                                                            fit: BoxFit.fill,
                                                            loadingBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    ImageChunkEvent?
                                                                        loadingProgress) {
                                                              if (loadingProgress ==
                                                                  null) {
                                                                return child;
                                                              }
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
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: SizedBox(
                                                              width:
                                                                  _widthOfBox *
                                                                      0.42,
                                                              child: Text(
                                                                groupCarts[
                                                                        groupCartModelIndex]
                                                                    .cartItems[
                                                                        index]
                                                                    .title,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                maxLines: 2,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              const ColoredBox(
                                                                color: Colors
                                                                    .green,
                                                                child: Text(
                                                                  " 3.7 ★ ",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 8,
                                                              ),
                                                              Text(
                                                                "(150)",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption,
                                                              ),
                                                            ],
                                                          ),
                                                          Text(
                                                            "₹${groupCarts[groupCartModelIndex].cartItems[index].price.toStringAsFixed(0)}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .bodyMedium!
                                                                .copyWith(
                                                                    decoration:
                                                                        TextDecoration
                                                                            .lineThrough),
                                                          ),
                                                          SizedBox(
                                                            width: _widthOfBox *
                                                                0.4,
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "${(groupCarts[groupCartModelIndex].cartItems[index].discount["admin"]! + groupCarts[groupCartModelIndex].cartItems[index].discount["seller"]! as int)}% off",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium!,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          .0,
                                                                      right: 8),
                                                                  child: Text(
                                                                      "\₹${(groupCarts[groupCartModelIndex].cartItems[index].price - (((groupCarts[groupCartModelIndex].cartItems[index].discount["admin"]! + groupCarts[groupCartModelIndex].cartItems[index].discount["seller"]! as int) / 100) * groupCarts[groupCartModelIndex].cartItems[index].price)).toStringAsFixed(0)}",
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleLarge!
                                                                          .copyWith(
                                                                              fontSize: 20)),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(left: 12),
                                                        child: Container(
                                                            height:
                                                                _mediaQueryHeight *
                                                                    0.16,
                                                            width: constraints
                                                                    .maxWidth *
                                                                0.12,
                                                            decoration: BoxDecoration(
                                                                color: Colors
                                                                    .grey
                                                                    .shade300,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            22)),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceEvenly,
                                                              children: [
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    groupCarts[
                                                                            groupCartModelIndex]
                                                                        .cartItems[
                                                                            index]
                                                                        .numberOfItems++;
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Icon(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    Icons
                                                                        .add_circle_outline_rounded,
                                                                    size: constraints
                                                                            .maxHeight *
                                                                        0.15,
                                                                  )),
                                                                ),
                                                                Center(
                                                                  child: Text(
                                                                    groupCarts[
                                                                            groupCartModelIndex]
                                                                        .cartItems[
                                                                            index]
                                                                        .numberOfItems
                                                                        .toString(),
                                                                    style: const TextStyle(
                                                                        color: Color.fromRGBO(
                                                                            104,
                                                                            126,
                                                                            255,
                                                                            1),
                                                                        fontSize:
                                                                            15,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (groupCarts[groupCartModelIndex]
                                                                            .cartItems[index]
                                                                            .numberOfItems >
                                                                        0) {
                                                                      groupCarts[
                                                                              groupCartModelIndex]
                                                                          .cartItems[
                                                                              index]
                                                                          .numberOfItems--;
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {});
                                                                      }
                                                                    }
                                                                  },
                                                                  child:
                                                                      SizedBox(
                                                                          child:
                                                                              Icon(
                                                                    color: Theme.of(
                                                                            context)
                                                                        .primaryColor,
                                                                    Icons
                                                                        .remove_circle_outline_rounded,
                                                                    size: constraints
                                                                            .maxHeight *
                                                                        0.15,
                                                                  )),
                                                                ),
                                                              ],
                                                            )),
                                                      ),
                                                    ],
                                                  );
                                                })),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            );
                          },
                        )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: _mediaQueryHeight * 0.07,
                              width: _mediaQueryWidth / 2.2,
                            ),
                            Tooltip(
                              message: "Buy Products Now",
                              child: InkWell(
                                focusColor: Theme.of(context).primaryColor,
                                child: SizedBox(
                                    height: _mediaQueryHeight * 0.07,
                                    width: _mediaQueryWidth / 2.2,
                                    child:
                                        const Center(child: Text("Buy Now"))),
                                onTap: () {
                                  findAllCartProducts();
                                  if (goInsideNavigator) {
                                    Navigator.pushNamed(
                                        context, "/orderProcessScreen",
                                        arguments: {
                                          "products": allCartProducts,
                                          "isGroup": true,
                                          "groupId": _groupId,
                                        });
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}
