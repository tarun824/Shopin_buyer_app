import 'package:buyer/features/favarate/data/models/favarate_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavarateScreen extends StatefulWidget {
  const FavarateScreen({super.key});

  @override
  State<FavarateScreen> createState() => _FavarateScreenState();
}

class _FavarateScreenState extends State<FavarateScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  final sidePadding = Constants.sidePadding;
  bool _isLoading = false;
  List<FavarateModel> favarateProducts = [];
  dynamic _userId = "";
  bool guestMode = true;
  bool loadProducts = true;
  String selectedLanguage = "english";

  Future fetchFavarateProducts() async {
    favarateProducts = [];
    // final userDataProvider =
    //     Provider.of<UserDataProvider>(context, listen: false);
    // final q = await userDataProvider.FetchUserData(widget.argument.toString());
    // final _userId = "Cl60lRJu70XSjBdQb01DkZGWoYI2";
    // final _userId = "E6NV6AfF8xUbJNPZMUP52ZUNzFA3";
    _userId = await TryAutoLogin().tryAutoLogin();

    // await TryAutoLogin().tryAutoLogin();
    if (_userId != null) {
      guestMode = false;
      _isLoading = true;
      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
//  if (argumentNavigate == "/listProductsScreen") {

//     final forId = FirebaseFirestore.instance.collection(argumentCollection);
//     }

      // QuerySnapshot querySnapshot = await forId.get();
      final broref = forId.snapshots(); //geting all the docs snapshorts
      broref.listen((event) async {
        //just listening so that will update on change in database
        // event.docs.for
        // event.data().fo
        // event.docs.forEach((element) {
        //   print(element.data());

        print("came to fetch butttttttt");
        print(event.data());
        // await event.data();
        if (event.data() != null) {
          event.data()!.forEach((key, value) {
            print("$key is $value");
            // print("${value["englishOffer"]}");

            if (key == 'isFavorite') {
              print("This Favarate is");
              print(value);
              // imageOffer.add(value);
              // categoryList = value;
              // for (int i = 0; i < value.length; i++) {
              //every single document
              // i=singleDoc
              // final singleDoc = value[i];
              final docFromkart = value;

              if (value.length > 0) {
                print("came length > first");
                print(value.length.toString());
                int count = 0;
                //change to .length later
                for (int x = 0; x < value.length; x++) {
                  final itemId = value[x]["productId"];
                  final cata = value[x]["cata"];
                  print("printingggggggggggggggggggggggggg");
                  print(itemId + cata);
                  final dataFromDb =
                      FirebaseFirestore.instance.collection(cata).doc(itemId);
                  final broref =
                      dataFromDb.snapshots(); //geting all the docs snapshorts
                  broref.listen((event1) async {
                    //just listening so that will update on change in database
                    // event.docs.for
                    // event.data().fo
                    // event.docs.forEach((element) {
                    //   print(element.data());

                    print("came to fetch butttttttt");
                    print(event1.data());
                    event1.data()!.forEach((key, value1) async {
                      print("$key is $value1");
                      // print("${value["englishOffer"]}");

                      if (key == 'productEntities') {
                        // imageOffer.add(value);
                        // categoryList = value;
                        // for (int i = 0; i < value.length; i++) {
                        //every single document
                        // i=singleDoc
                        // final singleDoc = value[i];
                        final docFromproducts = value1;
                        //  List<ParaInside> allParaInside = [];
                        print("value1");

                        print(value1);
                        final singleProduct = await FavarateModel(
                          title: docFromproducts["title"][selectedLanguage],
                          price: docFromproducts["price"],
                          discount: {
                            "admin": docFromproducts["discount"]["admin"],
                            "seller": docFromproducts["discount"]["seller"],
                          },
                          // review: {
                          //   "5": singleDoc["review"]["5"],
                          //   "4": singleDoc["review"]["4"],
                          //   "3": singleDoc["review"]["3"],
                          //   "2": singleDoc["review"]["2"],
                          //   "1": singleDoc["review"]["1"],
                          // },
                          cata: docFromproducts["cata"],
                          imgUrl: docFromproducts["imgUrl"],

                          productId: docFromproducts["productId"],
                          review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
                          isFavarate: false,
                        );
                        // favarateProducts.add(singleProduct);
                        // print("this is fav and singlrrrrrrrrrrrrrrrrrrrr");
                        // print(favarateProducts);
                        // print(singleProduct);

                        if (favarateProducts.contains(singleProduct)) {
                          print("came to contains");
                          print("this is fav and singlrrrrrrrrrrrrrrrrrrrr");
                          print(favarateProducts);
                          print(singleProduct);
                          // cartProducts.up
                        } else {
                          print("came to contains else so adding");
                          print("this is fav and singlrrrrrrrrrrrrrrrrrrrr");
                          print(favarateProducts);
                          print(singleProduct);
                          favarateProducts.add(singleProduct);
                        }
                        count++;
                        print("x isssssssssss $count");

                        if (count == value.length) {
                          print("came this only > first good bro");

                          _isLoading = false;
                          if (mounted) setState(() {});
                        }

                        // products = singleProduct;
                        // }

                        // final data = value.map((event) => event.docs.map((doc) {
                        //       print("this is doc" + doc);
                        //       //  final json=doc[""]
                        //       CategoryClass(
                        //           title: doc["title"],
                        //           imgUrl: doc['imgUrl'],
                        //           argument: doc['argument'],
                        //           navigate: doc['navigate']);
                        //     }));
                        // categoryList = data;

                        // _isLoading = false;
                        // print("categoryList is");
                        // if(mounted)setState(() {});
                        //to get user Id even to push that item

                        // final bro = forId.where('para.color');

                        // if (!arrId.contains(element.id)) {
                        //   arrId.add(element.id);
                        // }
                      }
                      // else {
                      //   print("$key is $value");
                      // }
                    });
                    // });
                  });
                }
                // _isLoading = false;
                // print("cate products is  is");
                // print(favarateProducts);
                // if(mounted)setState(() {});
              } else {
                _isLoading = false;
                print("cate products is  is");
                print(favarateProducts);
                if (mounted) setState(() {});
              }
              // final singleProduct = CartModel(
              //   title: singleDoc["title"],
              //   imgUrl: imgUrl,
              //   price: price,
              //   discount: discount,
              //   review: review,
              //   cata: cata,
              // );

              //  List<ParaInside> allParaInside = [];

              // products = singleProduct;
              // }

              // final data = value.map((event) => event.docs.map((doc) {
              //       print("this is doc" + doc);
              //       //  final json=doc[""]
              //       CategoryClass(
              //           title: doc["title"],
              //           imgUrl: doc['imgUrl'],
              //           argument: doc['argument'],
              //           navigate: doc['navigate']);
              //     }));
              // categoryList = data;

              //to get user Id even to push that item

              // final bro = forId.where('para.color');

              // if (!arrId.contains(element.id)) {
              //   arrId.add(element.id);
              // }
            } else {
              print("$key is $value");
            }
          });
        } else {
          _isLoading = false;
          print("cate products is  is");
          print("got null do herreeeeeeeeeeeeeee");
          if (mounted) setState(() {});
        }
        // });
      });
      // event.docs.forEach((element)  {
      //   //getting all the docs in single
      //   print(
      //       'element is ${element.data()}'); //we get all the field printed here
      //   final z =  element.data();
      //   // final List ar = [];
      //   _mainOfferImageUrls.add(z);
      //   // decodedData.add(ar);
      //   print(_mainOfferImageUrls);

      //      }
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  // final singleProduct = CartModel(
  //   title: singleDoc["title"],
  //   imgUrl: imgUrl,
  //   price: price,
  //   discount: discount,
  //   review: review,
  //   cata: cata,
  // );

  Future AddToFavarate(itemId, argumentproductCate) async {
    //for testing purpose we are directly providing user Id
    // final _userId = "E6NV6AfF8xUbJNPZMUP52ZUNzFA3";

    // await TryAutoLogin().tryAutoLogin();
    final forId = FirebaseFirestore.instance.collection("/buyers").doc(_userId);

    final uploadJson = {
      "productId": itemId,
      "cata": argumentproductCate,
    };
    await forId.update({
      "isFavorite": FieldValue.arrayUnion([uploadJson])
    });
    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future RemoveFavarate(itemId, argumentproductCate, i) async {
    //for testing purpose we are directly providing user Id
    // final _userId = "E6NV6AfF8xUbJNPZMUP52ZUNzFA3";

    // await TryAutoLogin().tryAutoLogin();
    final forId = FirebaseFirestore.instance.collection("/buyers").doc(_userId);

    final uploadJson = {
      "productId": itemId,
      "cata": argumentproductCate,
    };
    await forId.update({
      "isFavorite": FieldValue.arrayRemove([uploadJson])
    });
    favarateProducts.remove(favarateProducts[i]);
    _isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();

    fetchFavarateProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.1;
    final _widthOfBox = _mediaQueryWidth * 0.35;
    final _itemCountNumber = favarateProducts.length;
    final _crossAxisCount = 2;
    final _sizeForSizedBox =
        ((((_itemCountNumber / _crossAxisCount) * 2) + 2.3) * _heightOfBox);

    return SafeArea(
      child: Scaffold(
        // drawer: Drawer(
        //   child: Scaffold(
        //     body: Text("data"),
        //   ),
        // ),
        appBar: NormalAppbar().appbar(context, "Favarates"),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : guestMode
                ? Center(
                    child: Text("Login to see Favarate Items"),
                  )
                : favarateProducts.isEmpty
                    ? Center(
                        child: Text("Make some Products Favarate to see here"),
                      )
                    : SingleChildScrollView(
                        physics: BouncingScrollPhysics(),
                        child: Padding(
                          padding: sideTopPadding,
                          child: Column(
                            children: [
                              // Divider(thickness: 2),
                              SizedBox(
                                height: _sizeForSizedBox,
                                child: GridView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    // padding: sideTopPadding,
                                    itemCount: _itemCountNumber,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: _crossAxisCount,
                                      // childAspectRatio:
                                      //     ((mediaQueryWidth) / 3) / ((mediaQueryWidth * 0.5) / 3),
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/productDetailsScreen",
                                              arguments: {
                                                "productId":
                                                    favarateProducts[index]
                                                        .productId,
                                                "productCate":
                                                    favarateProducts[index]
                                                        .cata,
                                              });
                                        },
                                        child: SizedBox(
                                            height: _heightOfBox,
                                            width: _widthOfBox,
                                            child: Card(
                                                // shape: ShapeBorder(Curves.elasticInOut),
                                                elevation: 4,
                                                child: LayoutBuilder(builder:
                                                    (context, constraints) {
                                                  //**Bhai Add border for this
                                                  return Stack(
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            // decoration: BoxDecoration(
                                                            //     borderRadius:
                                                            //         BorderRadius.circular(22)),
                                                            // color: Theme.of(
                                                            //         context)
                                                            //     .colorScheme
                                                            //     .primaryContainer,
                                                            height: constraints
                                                                    .maxHeight *
                                                                0.6,
                                                            width: constraints
                                                                .maxWidth,
                                                            child:
                                                                //  Text(
                                                                //     favarateProducts[
                                                                //             index]
                                                                //         .imgUrl[0]),

                                                                Image.network(
                                                              favarateProducts[
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
                                                                    null)
                                                                  return child;
                                                                return Center(
                                                                  child:
                                                                      CircularProgressIndicator(
                                                                    value: loadingProgress.expectedTotalBytes !=
                                                                            null
                                                                        ? loadingProgress.cumulativeBytesLoaded /
                                                                            loadingProgress.expectedTotalBytes!
                                                                        : null,
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                          Expanded(
                                                            child: Text(
                                                              favarateProducts[
                                                                      index]
                                                                  .title,
                                                              // "Product Name with...",
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Padding(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        8),
                                                                child:
                                                                    ColoredBox(
                                                                  color: Colors
                                                                      .green
                                                                      .shade400,
                                                                  child: Text(
                                                                    "  3.7 ★ ",
                                                                    //logic of this should be written
                                                                    style: const TextStyle(
                                                                        color: Colors
                                                                            .white),
                                                                  ),
                                                                ),
                                                              ),
                                                              // Text(
                                                              //   products[index]
                                                              //       .review["5"]
                                                              //       .toString(),
                                                              //   style: Theme.of(context)
                                                              //       .textTheme
                                                              //       .bodyMedium,
                                                              // ),
                                                              // SizedBox(
                                                              //   width: 5,
                                                              // ),
                                                              Text(
                                                                "(${(favarateProducts[index].review["1"] + favarateProducts[index].review["2"] + favarateProducts[index].review["3"] + favarateProducts[index].review["4"] + favarateProducts[index].review["5"])})",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption,
                                                              ),
                                                              // Text(
                                                              //   favarateProducts[
                                                              //           index]
                                                              //       .review["5"]
                                                              //       .toString(),
                                                              //   style: Theme.of(
                                                              //           context)
                                                              //       .textTheme
                                                              //       .bodyMedium,
                                                              // ),
                                                              // SizedBox(
                                                              //   width: 5,
                                                              // ),
                                                              // Text(
                                                              //   favarateProducts[
                                                              //           index]
                                                              //       .review["3"]
                                                              //       .toString(),
                                                              //   style: Theme.of(
                                                              //           context)
                                                              //       .textTheme
                                                              //       .caption,
                                                              // ),
                                                            ],
                                                          ),
                                                          Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                  "${((favarateProducts[index].discount["admin"] as int) + (favarateProducts[index].discount["seller"] as int))} %off",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyLarge!
                                                                      .copyWith(
                                                                          color: Colors
                                                                              .green
                                                                              .shade600)),
                                                              // Text(
                                                              //   ((favarateProducts[index].discount["admin"]
                                                              //               as int) +
                                                              //           (favarateProducts[index].discount["seller"]
                                                              //               as int))
                                                              //       .toString(),
                                                              //   style: Theme.of(
                                                              //           context)
                                                              //       .textTheme
                                                              //       .bodyLarge,
                                                              // ),
                                                              SizedBox(
                                                                width: 5,
                                                              ),
                                                              Text(
                                                                "\₹ ${favarateProducts[index].price.toStringAsFixed(0)}",
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .titleLarge,
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                      Positioned(
                                                          right: 2,
                                                          top: 2,
                                                          child: IconButton(
                                                              alignment:
                                                                  Alignment
                                                                      .topRight,
                                                              onPressed: () {
                                                                favarateProducts[
                                                                            index]
                                                                        .isFavarate =
                                                                    !favarateProducts[
                                                                            index]
                                                                        .isFavarate;
                                                                _isLoading =
                                                                    true;
                                                                if (mounted)
                                                                  setState(
                                                                      () {});

                                                                // favarateProducts[index]
                                                                //         .isFavarate
                                                                //     ? RemoveFavarate(
                                                                //         favarateProducts[
                                                                //                 index]
                                                                //             .productId,
                                                                //         favarateProducts[
                                                                //                 index]
                                                                //             .cata)
                                                                //     : AddToFavarate(
                                                                //         favarateProducts[
                                                                //                 index]
                                                                //             .productId,
                                                                //         favarateProducts[
                                                                //                 index]
                                                                //             .cata);
                                                                //              favarateProducts[index]
                                                                //         .isFavarate =
                                                                //     !favarateProducts[
                                                                //             index]
                                                                //         .isFavarate;

                                                                favarateProducts[
                                                                            index]
                                                                        .isFavarate
                                                                    ? {
                                                                        RemoveFavarate(
                                                                            favarateProducts[index].productId,
                                                                            favarateProducts[index].cata,
                                                                            index),
                                                                      }
                                                                    : AddToFavarate(
                                                                        favarateProducts[index]
                                                                            .productId,
                                                                        favarateProducts[index]
                                                                            .cata);

                                                                // if(mounted)setState(() {});
                                                              },
                                                              icon: favarateProducts[
                                                                          index]
                                                                      .isFavarate // **Must Change this
                                                                  ? Icon(
                                                                      Icons
                                                                          .favorite_border,
                                                                      // color: Colors.amber,
                                                                    )
                                                                  : Icon(
                                                                      // ** This true must change
                                                                      Icons
                                                                          .favorite_rounded,
                                                                      color: Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                    ))),
                                                    ],
                                                  );
                                                }))),
                                      );
                                    }),
                              ),
                              // Padding(
                              //   padding: sidePadding,
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         "data",
                              //         style: Theme.of(context).textTheme.bodyMedium,
                              //       ),
                              //       TextButton.icon(
                              //         // style:ButtonStyle(
                              //         // textStyle: Theme.of(context).textTheme.bodyMedium) ,
                              //         onPressed: () {},
                              //         icon: Icon(Icons.arrow_forward_ios_rounded,
                              //             textDirection: TextDirection.ltr),
                              //         label: const Text("View All"),
                              //       ),
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ),
      ),
    );
  }
}
