import 'package:buyer/l10n/local_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:buyer/domain/entities/product_entities.dart';
import 'package:buyer/features/groups/data/models/groups_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProductDetailsScreen extends StatefulWidget {
  ProductDetailsScreen({super.key, required this.argument});
  //here we get productId and productCate

  final argument;
  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  final betweenEveryWidget = const EdgeInsets.only(top: 5.0);

  final List paraSelected = [];

  bool _isLoading = true;
  bool _didLike = false;
  bool _didDislike = false;
  String selectedLanguage = "english";

  //initialy products has dumy data
  ProductEntities products = ProductEntities(
      title: "title",
      description: "description",
      price: 16,
      qty: 11,
      discount: {},
      sellerName: "sellerName",
      para: [
        forPara(paraTitle: "size", paraInside: [
          ParaInside(cate: "xl", price: 52, qty: 120),
        ]),
        forPara(
          paraTitle: "color",
          paraInside: [
            ParaInside(cate: "red", price: 5, qty: 10),
          ],
        ),
      ],
      review: {},
      reviewText: [],
      queAndAns: [QueAndAns(question: "question", answer: "answer")],
      cata: "cata",
      imgUrl: ["imgUrl"],
      coin: 0,
      expirable: {},
      dimenstion: {});
  String productId = "";
  String argumentproductCate = "";
  int numberOfItems = 0;
  dynamic _userId = "_userId";

  String _userName = " ";
  bool goInsideUpdateMessage = false;
  List<GroupsModel> groups = [];

  Future fetchProducts() async {
    _isLoading = true;
    if (mounted) setState(() {});
    _userId = await TryAutoLogin().tryAutoLogin();

    String argumentproductId = widget.argument["productId"].toString();
    argumentproductCate = widget.argument["productCate"].toString();

    final forId = FirebaseFirestore.instance
        .collection(argumentproductCate)
        .doc(argumentproductId);
    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) async {
      //just listening so that will update on change in database

      event.data()!.forEach((key, value) {
        if (key == "productId") {
          productId = value;
        }
        if (key == 'productEntities') {
          final singleDoc = value;
          final List<forPara> allPara = [];
          final List<QueAndAns> allQueAndAns = [];

          for (int j = 0; j < singleDoc["para"].length; j++) {
//every single parameter
// j=singlePara
            List<ParaInside> allParaInside = [];
            for (int z = 0; z < singleDoc["para"][j].length; z++) {
//every single Para Inside
//z=singleParaInside

              final ParaInside singleParaInside = ParaInside(
                  cate: singleDoc["para"][j]["paraInside"][z]["cate"],
                  price: singleDoc["para"][j]["paraInside"][z]["price"],
                  qty: singleDoc["para"][j]["paraInside"][z]["qty"]);
              allParaInside.add(singleParaInside);
            }
            final forPara singlePara = forPara(
                paraInside: allParaInside,
                paraTitle: singleDoc["para"][j]["paraTitle"]);
            allPara.add(singlePara);
          }

          for (int r = 0; r < singleDoc["queAndAns"].length; r++) {
            // r is QueAndAns
            final QueAndAns singleQueAndAns = QueAndAns(
                question: singleDoc["queAndAns"][r]["question"],
                answer: singleDoc["queAndAns"][r]["answer"]);
            allQueAndAns.add(singleQueAndAns);
          }
          List<Map<String, dynamic>> reviewTextDumy = [];
          if (!(singleDoc["reviewText"] == null ||
              singleDoc["reviewText"] == [])) {
            for (int o = 0; o < singleDoc["reviewText"].length; o++) {
              final singleReviewText = {
                "author": singleDoc["reviewText"][o]["author"],
                "isVerified": singleDoc["reviewText"][o]["isVerified"],
                "messageId": singleDoc["reviewText"][o]["messageId"],
                "rating": singleDoc["reviewText"][o]["rating"],
                "message": singleDoc["reviewText"][o]["message"],
                "like": singleDoc["reviewText"][o]["like"],
                "disLike": singleDoc["reviewText"][o]["disLike"],
                "sentOn": singleDoc["reviewText"][o]["sentOn"],
              };
              reviewTextDumy.add(singleReviewText);
            }
          }
          final singleProduct = ProductEntities(
            title: singleDoc["title"][selectedLanguage],
            description: singleDoc["description"][selectedLanguage],
            price: singleDoc["price"],
            qty: singleDoc["qty"],
            discount: {
              "admin": singleDoc["discount"]["admin"],
              "seller": singleDoc["discount"]["seller"],
            },
            sellerName: singleDoc["sellerName"],
            para: allPara, // **
            review: {
              "5": singleDoc["review"]["5"],
              "4": singleDoc["review"]["4"],
              "3": singleDoc["review"]["3"],
              "2": singleDoc["review"]["2"],
              "1": singleDoc["review"]["1"],
            },
            reviewText: reviewTextDumy,
            queAndAns: allQueAndAns,
            cata: singleDoc["cata"],
            imgUrl: singleDoc["imgUrl"],
            coin: singleDoc["coin"],
            expirable: {
              "isExpirable": singleDoc["expirable"]["isExpirable"],
              "yes": singleDoc["expirable"]["yes"],
            },
            dimenstion: {
              "height": singleDoc["dimenstion"]["height"],
              "width": singleDoc["dimenstion"]["width"],
            },
          );
          products = singleProduct;
          _isLoading = false;
          if (mounted) setState(() {});
          for (int x = 0; x < products.para.length; x++) {
            paraSelected.add(0);
          }

          //to get user Id even to push that item
        } else {}
      });
    });
    // event.docs.forEach((element)  {
  }

  Future addToCart(itemId, parameterSelected, argumentproductCate, isAddToGroup,
      groupId) async {
    final List<Map<String, String>> allPara = [];
    int count = 0;
    for (int y = 0; y < paraSelected.length; y++) {
      final cateTitle = products.para[y].paraTitle;
      final selectedCate = products.para[y].paraInside[paraSelected[y]].cate;
      final singlePara = {"selected": selectedCate, "parameter": cateTitle};
      allPara.add(singlePara);
      count++;
    }
    if (count >= paraSelected.length) {
      final uploadJson = {
        "productId": itemId,
        "numberOfitems": numberOfItems,
        "parameterSelected": allPara,
        "cata": argumentproductCate,
      };
      if (!isAddToGroup) {
        final forId =
            FirebaseFirestore.instance.collection("/buyers").doc(_userId);
        await forId.update({
          "cart": FieldValue.arrayUnion([uploadJson])
        });
        _isLoading = false;
        if (mounted) setState(() {});
      } else {
        final forGroupId = FirebaseFirestore.instance
            .collection('/groups/$groupId/cart/')
            .doc(_userId);

        await forGroupId.update({
          "cart": FieldValue.arrayUnion([uploadJson])
        });
        goInsideUpdateMessage = true;
      }
    }
  }

  Future fetchGroupsIn() async {
    _isLoading = true;
    setState(() {});
    Future.delayed(const Duration(milliseconds: 500), () {
// Here you can write your code
      _isLoading = false;

      setState(() {
        // Here you can write your code for open new view
      });
    });
    _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null || _userId != "null" || _userId != "_userId") {
      final forUserId2 =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      final broref2 = forUserId2.snapshots(); //geting all the docs snapshorts
      await broref2.listen((element2) {
        //just listening so that will update on change in database

        //getting all the docs in single
        //we get all the field printed here
        _userName = element2.data()!["name"];
        element2.data()!.forEach((key, value) {
          //here we are intarating through all the map inside field
          int count = 0;
          if (key == 'groupsIn') {
            for (int t = 0; t < value.length; t++) {
              final GroupsModel singleGroup = GroupsModel(
                groupName: value[t]["groupName"],
                imgUrl: value[t]["imgUrl"],
                groupId: value[t]["groupId"],
              );
              groups.add(singleGroup);

              count++;
              if (count == value.length - 1 &&
                  _userName != " " &&
                  groups.isNotEmpty) {
                if (mounted) setState(() {});
              }
            }
          }
        });
      });
    }
  }

  Future updateMessage(
      itemId, title, price, qty, imgUrl, argumentproductCate, groupId) async {
    goInsideUpdateMessage = false;

    final dateTimeNoe = DateTime.now();
    String formattedDateToUpload =
        DateFormat('yyyy-MM-dd – kk:mm').format(dateTimeNoe);
    final forUserId2 =
        FirebaseFirestore.instance.collection("/groups").doc(groupId);
    final uploadmessageToDb = {
      "message": "Added to cart by:",
      "senderId": _userId,
      "senderName": _userName,
      "date": formattedDateToUpload,
      "productDetails": {
        "productId": itemId,
        "cata": argumentproductCate,
        "isProduct": true,
        "title": title,
        "imgUrl": imgUrl,
        "price": price,
        "qty": qty,
      }
    };
    await forUserId2.update({
      "messages": FieldValue.arrayUnion([uploadmessageToDb])
    });

    _isLoading = false;
    if (mounted) setState(() {});
  }

  Future addLikeAndDislikeToDb(bool bool, String condition, int index) async {
    //**bool:weather we should add 1 or minus 1
    //condition:weather it is like or disLike based on this we will make condition and reusethis method
    //index:this is for local updation  */
    //here we are using same method for both adding like and dislike to Db
    final forUserId = FirebaseFirestore.instance
        .collection(argumentproductCate)
        .doc(productId);

    final broref = forUserId.snapshots(); //geting all the docs snapshorts
    await broref.listen((element) {
      if (condition == "like") {
        final Like = element["productEntities"]["reviewText"][index]["like"];
        if (bool) {
          forUserId.update(
              {"productEntities.reviewText.like": FieldValue.increment(1)});
          ++products.reviewText[index]["like"];
        } else {
          forUserId.update({"productEntities.reviewText.like": Like - 1});
          --products.reviewText[index]["like"];
        }
      } else {
        final disLike =
            element["productEntities"]["reviewText"][index]["disLike"];
        if (bool) {
          forUserId.update({"productEntities.reviewText.like": disLike + 1});
          ++products.reviewText[index]["disLike"];
        } else {
          forUserId.update({"productEntities.reviewText.like": disLike - 1});
          --products.reviewText[index]["disLike"];
        }
      }
    });
    _isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();
    fetchGroupsIn();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.15;
    final _widthOfBox = _mediaQueryWidth * 0.3;
    final _sizeForSizedBox =
        _heightOfBox * products.para.length + (45 * products.para.length);

    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "Product Details"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: sideTopPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
//just for test zoom text

                        height: 200,
                      ),
                      SizedBox(
                        height: _mediaQueryHeight * 0.4,
                        width: _mediaQueryWidth * 0.9,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 3,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: InteractiveViewer(
                                child: Container(
                                  height: _mediaQueryHeight * 0.4,
                                  width: _mediaQueryWidth * 0.8,
                                  child: Image.network(
                                    products.imgUrl[0],
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: betweenEveryWidget,
                        child: Text(
                          products.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 5.0),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          sideTopPadding.copyWith(bottom: 5),
                                      child: Text(
                                          "\₹${(products.price - (((products.discount["admin"]! + products.discount["seller"]! as int) / 100) * products.price)).toStringAsFixed(0)}",
                                          //the above logic is we are minusing the give price with the discounted amount
                                          //the discounted amount is calculated by adding the two discount given by admin
                                          //and seller and then divideing it by 100 so that we get result in 0.  then we multiply
                                          //that number(0.  ) with given price so that we get discounted amount
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(fontSize: 22)),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "₹${products.price.toStringAsFixed(0)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                  "${(products.discount["admin"]! + products.discount["seller"]! as int)}% off",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(color: Colors.green.shade600)),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    ColoredBox(
                                      color: Colors.green.shade400,
                                      child: const Text(
                                        " 3.7 ★ ",
                                        //logic of this should be written
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "(${products.review["5"]! + products.review["4"]! + products.review["3"]! + products.review["2"]! + products.review["1"]!})",
                                      style:
                                          Theme.of(context).textTheme.caption,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Container(
                                width: _mediaQueryHeight * 0.16,
                                height: _mediaQueryWidth * 0.12,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: BorderRadius.circular(22)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        //adding one each time user clicks on Icons.add_circle_outline_rounded
                                        if (numberOfItems > 0) {
                                          --numberOfItems;
                                          if (mounted) setState(() {});
                                        }
                                      },
                                      child: SizedBox(
                                          child: Icon(
                                        color: Theme.of(context).primaryColor,
                                        Icons.remove_circle_outline_rounded,
                                        size: _mediaQueryHeight * 0.05,
                                      )),
                                    ),
                                    Center(
                                      child: Text(
                                        numberOfItems.toString(),
                                        style: const TextStyle(
                                            color: Color.fromRGBO(
                                                104, 126, 255, 1),
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        //adding one each time user clicks on Icons.add_circle_outline_rounded
                                        numberOfItems++;
                                        if (mounted) setState(() {});
                                      },
                                      child: SizedBox(
                                          child: Icon(
                                        color: Theme.of(context).primaryColor,
                                        Icons.add_circle_outline_rounded,
                                        size: _mediaQueryHeight * 0.05,
                                      )),
                                    ),
                                  ],
                                )),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () async {
                              //add items to user database "cart" with numberOfItems

                              _isLoading = true;
                              if (mounted) setState(() {});

                              if (_userId != null) {
                                await addToCart(productId, paraSelected,
                                    products.cata, false, "null");
                              } else {
                                _isLoading = false;
                                if (mounted) setState(() {});
                                _showErrorDialog(
                                    "Login to add products to Cart");
                              }
                            },
                            child: Text(AppLocalizations.of(context)!.addToCart
                                // "Add to Cart"
                                )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_userId != null) {
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Dialog(
                                        child: Column(
                                          children: [
                                            const Text(
                                              "Groups List",
                                            ),
                                            const Divider(
                                              thickness: 2,
                                            ),
                                            SizedBox(
                                              height: _mediaQueryHeight * 0.8,
                                              child: ListView.builder(
                                                itemCount: groups.length,
                                                itemBuilder: (context, index) {
                                                  return Card(
                                                    elevation: 4,
                                                    child: GestureDetector(
                                                      onTap: () async {
                                                        _isLoading = true;
                                                        if (mounted)
                                                          setState(() {});
                                                        await addToCart(
                                                            productId,
                                                            paraSelected,
                                                            products.cata,
                                                            true,
                                                            groups[index]
                                                                .groupId);
                                                        if (goInsideUpdateMessage) {
                                                          updateMessage(
                                                              productId,
                                                              products.title,
                                                              products.price,
                                                              products.qty,
                                                              products.imgUrl,
                                                              products.cata,
                                                              groups[index]
                                                                  .groupId);
                                                        }
                                                      },
                                                      child: ListTile(
                                                        title: Text(
                                                            groups[index]
                                                                .groupName),
                                                        leading: CircleAvatar(
                                                          child: ColoredBox(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        ),
                                                        trailing: const Icon(Icons
                                                            .arrow_forward_ios_rounded),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  _isLoading = false;
                                  if (mounted) setState(() {});
                                  _showErrorDialog(
                                      "Login to add products to Group Cart");
                                }
                              },
                              child: Text(
                                  AppLocalizations.of(context)!.addToGroupCart
                                  // "Add to Group Cart"
                                  )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(
                          AppLocalizations.of(context)!.description,
                          // "Description",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          products.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                      products.para.isNotEmpty
                          ? SizedBox(
                              height: _sizeForSizedBox,
                              child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: products.para.length,
                                  //This is for List of parameter like Color , size...
                                  itemBuilder: ((context, listOfPara) {
                                    return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: betweenEveryWidget,
                                            child: Text(
                                              products
                                                  .para[listOfPara].paraTitle,
                                              // yesBro[listOfPara].paraTitle,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge,
                                            ),
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),

                                          //This is for List of Categaories like Xl,l,red,green ...
                                          SizedBox(
                                            height: _heightOfBox,
                                            child: ListView.builder(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                physics:
                                                    const BouncingScrollPhysics(),
                                                itemCount: products
                                                    .para[listOfPara]
                                                    .paraInside
                                                    .length,
                                                itemBuilder:
                                                    (context, listOfcate) {
                                                  return Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 10.0,
                                                            left: 10,
                                                            top: 10,
                                                            bottom: 10),
                                                    height: _heightOfBox,
                                                    width: _widthOfBox,
                                                    decoration: paraSelected[
                                                                listOfPara] ==
                                                            listOfcate
                                                        ? BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        22),
                                                            boxShadow: [
                                                                BoxShadow(
                                                                  color: paraSelected[
                                                                              listOfPara] ==
                                                                          listOfcate
                                                                      ? Theme.of(
                                                                              context)
                                                                          .primaryColor
                                                                      : Theme.of(
                                                                              context)
                                                                          .primaryColor,
                                                                  blurRadius:
                                                                      22.0, // soften the shadow
                                                                  spreadRadius:
                                                                      0, //extend the shadow
                                                                  offset:
                                                                      const Offset(
                                                                    //it was going right side so made it for left side
                                                                    -2, // Move to right 5  horizontally
                                                                    0, // Move to bottom 5 Vertically
                                                                  ),
                                                                ),
                                                              ])
                                                        : const BoxDecoration(),
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        paraSelected[
                                                                listOfPara] =
                                                            listOfcate;
                                                        if (mounted)
                                                          setState(() {});
                                                      },
                                                      child: Card(
                                                        elevation: 4,
                                                        child: Column(
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  betweenEveryWidget,
                                                              child: Text(
                                                                products
                                                                    .para[
                                                                        listOfPara]
                                                                    .paraInside[
                                                                        listOfcate]
                                                                    .cate,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyMedium,
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  betweenEveryWidget,
                                                              child: Text(
                                                                AppLocalizations.of(
                                                                        context)!
                                                                    .price(products
                                                                        .para[
                                                                            listOfPara]
                                                                        .paraInside[
                                                                            listOfcate]
                                                                        .price
                                                                        .toString()),
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .bodyLarge,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                          ),
                                        ]);
                                  })),
                            )
                          : const SizedBox(),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Text(AppLocalizations.of(context)!.rating
                            // "Rating"
                            ),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      Text("${products.review["5"]}   ★★★★★"),
                      Text("${products.review["4"]}   ★★★★"),
                      Text("${products.review["3"]}   ★★★"),
                      Text("${products.review["2"]}   ★★"),
                      Text("${products.review["1"]}   ★"),
                      const Padding(
                        padding: EdgeInsets.only(top: 12.0),
                        child: Text("Review"),
                      ),
                      const Divider(
                        thickness: 2,
                      ),
                      SizedBox(
                        height: _mediaQueryHeight *
                            0.2 *
                            products.reviewText.length,
                        width: _mediaQueryWidth,
                        child: Padding(
                          padding: sideTopPadding,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: products.reviewText.length,
                              itemBuilder: (context, indexOfReview) {
                                return Card(
                                    elevation: 4,
                                    child: LayoutBuilder(
                                        builder: (context, constraints) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: Text(
                                                  "${AppLocalizations.of(context)!.rating} ${products.reviewText[indexOfReview]["rating"]} ",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium!,
                                                ),
                                              ),
                                              const Spacer(),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 8),
                                                child: Text(
                                                    "Posted on: ${products.reviewText[indexOfReview]["sentOn"]} ",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge!),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            thickness: 2,
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: SizedBox(
                                              child: Text(
                                                "${products.reviewText[indexOfReview]["message"]}",
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  products
                                                      .reviewText[indexOfReview]
                                                          ["like"]
                                                      .toString(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption),
                                              IconButton(
                                                  onPressed: () {
                                                    _isLoading = true;
                                                    if (mounted)
                                                      setState(() {});
                                                    _didLike = !_didLike;
                                                    _didLike
                                                        ? addLikeAndDislikeToDb(
                                                            true,
                                                            "like",
                                                            indexOfReview)
                                                        : addLikeAndDislikeToDb(
                                                            false,
                                                            "like",
                                                            indexOfReview);
                                                    if (mounted)
                                                      setState(() {});
                                                  },
                                                  icon: (_didLike)
                                                      ? const Icon(Icons
                                                          .thumb_up_off_alt_sharp)
                                                      : const Icon(Icons
                                                          .thumb_up_outlined)),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 10.0,
                                                ),
                                                child: Text(
                                                    products.reviewText[
                                                            indexOfReview]
                                                            ["disLike"]
                                                        .toString(),
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ),
                                              IconButton(
                                                  onPressed: () {
                                                    _isLoading = true;
                                                    if (mounted)
                                                      setState(() {});
                                                    _didDislike = !_didDislike;
                                                    _didLike
                                                        ? addLikeAndDislikeToDb(
                                                            true,
                                                            "disLike",
                                                            indexOfReview)
                                                        : addLikeAndDislikeToDb(
                                                            false,
                                                            "disLike",
                                                            indexOfReview);
                                                    if (mounted)
                                                      setState(() {});
                                                  },
                                                  icon: (_didDislike)
                                                      ? const Icon(Icons
                                                          .thumb_down_alt_sharp)
                                                      : const Icon(Icons
                                                          .thumb_down_outlined)),
                                            ],
                                          ),
                                        ],
                                      );
                                    }));
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            child: const Text("ok"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }
}
