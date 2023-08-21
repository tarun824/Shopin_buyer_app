import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = true;
  final sidePadding = Constants.sidePadding;

  List<CartModel> cartProducts = [];
  bool guestMode = true;
  String selectedLanguage = "english";

  Future fetchCartProducts() async {
    cartProducts = [];

    final _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null) {
      guestMode = false;

      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      final broref = forId.snapshots(); //geting all the docs snapshorts
      broref.listen((event) async {
        //just listening so that will update on change in database
        ;

        await event.data();
        event.data()!.forEach((key, value) {
          if (key == 'cart') {
            //every single document

            final docFromcart = value;

            if (value.length > 0) {
              int count = 0;

              for (int x = 0; x < value.length; x++) {
                final itemId = value[x]["productId"];
                final cata = value[x]["cata"];
                final dataFromDb =
                    FirebaseFirestore.instance.collection(cata).doc(itemId);
                final broref =
                    dataFromDb.snapshots(); //geting all the docs snapshorts
                broref.listen((event1) async {
                  //just listening so that will update on change in database

                  event1.data()!.forEach((key, value1) {
                    if (key == 'productEntities') {
                      //every single document

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
                      if (cartProducts.contains(singleProduct)) {
                      } else {
                        cartProducts.add(singleProduct);
                      }
                      count++;

                      if (count == value.length) {
                        _isLoading = false;
                        if (mounted) setState(() {});
                      }

                      //to get user Id even to push that item
                    }
                  });
                });
              }

              //just for _isLoading coming outside of loop sooo
            } else {
              // if length of items <0

              _isLoading = false;
              if (mounted) setState(() {});
            }

            //to get user Id even to push that item
          } else {}
        });
      });
      //getting all the docs in single
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();

    fetchCartProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.24;
    final _widthOfBox = _mediaQueryWidth;
    final _itemCountNumber = cartProducts.length;
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "cart Items"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : guestMode
                ? const Center(
                    child: Text("Login to see cart Items"),
                  )
                : cartProducts.isEmpty
                    ? const Center(
                        child: Text("Add some Products to cart to see here"),
                      )
                    : Padding(
                        padding: sideTopPadding,
                        child: Column(
                          children: [
                            Expanded(
                                child: ListView.builder(
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: _itemCountNumber,
                                    itemBuilder: (context, index) {
                                      return SizedBox(
                                        height: _heightOfBox,
                                        width: _widthOfBox,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.pushNamed(context,
                                                "/productDetailsScreen",
                                                arguments: {
                                                  "productId":
                                                      cartProducts[index]
                                                          .productId,
                                                  "productCate":
                                                      cartProducts[index].cata,
                                                });
                                          },
                                          child: Card(
                                              elevation: 4,
                                              child: LayoutBuilder(builder:
                                                  (context, constraints) {
                                                return Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Container(
                                                        height: constraints
                                                            .maxHeight,
                                                        width: constraints
                                                                .maxWidth *
                                                            0.33,
                                                        child: Image.network(
                                                          cartProducts[index]
                                                              .imgUrl[0],
                                                          fit: BoxFit.fill,
                                                          loadingBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  Widget child,
                                                                  ImageChunkEvent?
                                                                      loadingProgress) {
                                                            if (loadingProgress ==
                                                                null)
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
                                                            width: _widthOfBox *
                                                                0.42,
                                                            child: Text(
                                                              cartProducts[
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
                                                              color:
                                                                  Colors.green,
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
                                                          "₹${cartProducts[index].price.toStringAsFixed(0)}",
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
                                                          width:
                                                              _widthOfBox * 0.4,
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "${(cartProducts[index].discount["admin"]! + cartProducts[index].discount["seller"]! as int)}% off",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium!,
                                                              ),
                                                              const Spacer(),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        bottom:
                                                                            .0,
                                                                        right:
                                                                            8),
                                                                child: Text(
                                                                    "\₹${(cartProducts[index].price - (((cartProducts[index].discount["admin"]! + cartProducts[index].discount["seller"]! as int) / 100) * cartProducts[index].price)).toStringAsFixed(0)}",
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .titleLarge!
                                                                        .copyWith(
                                                                            fontSize:
                                                                                20)),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    const Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Container(
                                                          height:
                                                              _mediaQueryHeight *
                                                                  0.16,
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.12,
                                                          decoration: BoxDecoration(
                                                              color: Colors.grey
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
                                                                  cartProducts[
                                                                          index]
                                                                      .numberOfItems++;
                                                                  if (mounted) {
                                                                    setState(
                                                                        () {});
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                    child: Icon(
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
                                                                  cartProducts[
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
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                              GestureDetector(
                                                                onTap: () {
                                                                  if (cartProducts[
                                                                              index]
                                                                          .numberOfItems >
                                                                      0) {
                                                                    --cartProducts[
                                                                            index]
                                                                        .numberOfItems;
                                                                    if (mounted) {
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                },
                                                                child: SizedBox(
                                                                    child: Icon(
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
                                        ),
                                      );
                                    })),
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
                                        child: const Center(
                                            child: Text("Buy Now"))),
                                    onTap: () {
                                      Navigator.pushNamed(
                                          context, "/orderProcessScreen",
                                          arguments: {
                                            "products": cartProducts,
                                            "isGroup": false,
                                            "groupId": ""
                                          });
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
