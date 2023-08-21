import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import 'package:flutter/material.dart';

class OrderReviewScreen extends StatefulWidget {
  OrderReviewScreen({super.key, required this.argument});
  final argument;
  // here we get CartModel
  //here we want productId ,cata , price,discount, or (title,img,3.7,numberof rated,discount and price )

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  final _sideTopPadding = Constants.sideTopPadding;
  final _verticalleftPadding = Constants.verticalleftPadding;

  final _textFieldBorderRadius = Constants.textFieldBorderRadius;

  TextEditingController searchTextController = TextEditingController();
  String rewiewText = "";
  int productRating = 0;
  bool _isLoading = false;

  CartModel product = CartModel(
    productId: "productId",
    title: "title,",
    imgUrl: [],
    price: 0,
    discount: {},
    review: {},
    cata: "cata",
    numberOfItems: 0,
    parameterSelected: [],
    sellerId: "sellerId",
  );
  Future fetchProduct() async {
    product = widget.argument;
  }

  Future addReviewToDb() async {
    _isLoading = true;
    if (mounted) setState(() {});
    final _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null) {
      final forId = FirebaseFirestore.instance
          .collection(product.cata)
          .doc(product.productId);
      final reviewText = {
        "author": _userId,
        //This isVerified is now false and as account is verified it will be true by checking "status" in UserModel
        "isVerified": false,
        "messageId": DateTime.now().millisecondsSinceEpoch,
        "rating": productRating,
        "message": rewiewText,
        "like": 0,
        "disLike ": 0,
        "sentOn": DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
      };
      forId.update({
        "productEntities.reviewText": FieldValue.arrayUnion([reviewText])
      });
      _isLoading = false;
      if (mounted) setState(() {});
      final broref = forId.snapshots(); //geting all the docs snapshorts
      broref.listen((event1) async {
        //just listening so that will update on change in database

        event1.data()!.forEach((key, value1) {});
      });
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    fetchProduct();
    super.initState();
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.25;

    return SafeArea(
      child: Scaffold(
          appBar: NormalAppbar().appbar(context, "Review and Return"),
          body: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Padding(
                    padding: _sideTopPadding,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            height: _heightOfBox,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              String selectedPara = "";
                              for (int c = 0;
                                  c < product.parameterSelected.length;
                                  c++) {
                                selectedPara = selectedPara +
                                    "${product.parameterSelected[c]["selected"]},";
                              }
                              return Card(
                                elevation: 4,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 8.0),
                                      child: Container(
                                        height: constraints.maxHeight,
                                        width: constraints.maxWidth * 0.3,
                                        child: Image.network(
                                          product.imgUrl[0],
                                          fit: BoxFit.contain,
                                          loadingBuilder: (BuildContext context,
                                              Widget child,
                                              ImageChunkEvent?
                                                  loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;
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
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 8.0),
                                          child: SizedBox(
                                            width: constraints.maxWidth * 0.42,
                                            child: Text(
                                              product.title,
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
                                              MainAxisAlignment.start,
                                          children: [
                                            const ColoredBox(
                                              color: Colors.green,
                                              child: Text(
                                                " 3.7 ★ ",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            const SizedBox(
                                              width: 8,
                                            ),
                                            Text(
                                              "(${product.review["5"]! + product.review["4"]! + product.review["3"]! + product.review["2"]! + product.review["1"]!})",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          width: constraints.maxWidth * 0.6,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 5.0),
                                                    child: Text(
                                                      "₹${product.price.toStringAsFixed(0)}",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                    ),
                                                  ),
                                                  Text(
                                                    "${(product.discount["admin"]! + product.discount["seller"]! as int)}% off",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  ),
                                                  const Spacer(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8.0,
                                                            right: 8),
                                                    child: Text(
                                                        "\₹${(product.price - (((product.discount["admin"]! + product.discount["seller"]! as int) / 100) * product.price)).toStringAsFixed(0)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge!
                                                            .copyWith(
                                                                fontSize: 20)),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                "selected: $selectedPara",
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Product Review",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                productRating = 1;
                                if (mounted) setState(() {});
                              },
                              icon: Icon(
                                productRating >= 1
                                    ? Icons.star
                                    : Icons.star_border,
                              ),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                productRating = 2;
                                if (mounted) setState(() {});
                              },
                              icon: Icon(productRating >= 2
                                  ? Icons.star
                                  : Icons.star_border),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                productRating = 3;
                                if (mounted) setState(() {});
                              },
                              icon: Icon(productRating >= 3
                                  ? Icons.star
                                  : Icons.star_border),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                productRating = 4;
                                if (mounted) setState(() {});
                              },
                              icon: Icon(productRating >= 4
                                  ? Icons.star
                                  : Icons.star_border),
                            ),
                            IconButton(
                              iconSize: 40,
                              onPressed: () {
                                productRating = 5;
                                if (mounted) setState(() {});
                              },
                              icon: Icon(productRating >= 5
                                  ? Icons.star
                                  : Icons.star_border),
                            ),
                          ],
                        ),
                        Padding(
                          padding: _sideTopPadding,
                          child: TextField(
                            maxLines: 5,
                            controller: searchTextController,
                            onChanged: (value) {
                              rewiewText = value;
                              if (mounted) setState(() {});
                            },
                            decoration: InputDecoration(
                                focusColor:
                                    Theme.of(context).colorScheme.primary,
                                hintText: "Review the Product",
                                label: const Text(
                                    '  Please Enter Review about Product'),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 3, vertical: 3),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: Constants.textFieldBorderRadius,
                                ),
                                suffixIcon: !(rewiewText == "")
                                    ? IconButton(
                                        splashRadius: 18,
                                        onPressed: () {
                                          searchTextController.clear();
                                        },
                                        icon: const Icon(Icons.cancel_rounded))
                                    : const SizedBox()),
                          ),
                        ),
                        Container(
                          padding: _sideTopPadding,
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {
                                addReviewToDb();
                                searchTextController.clear();
                              },
                              child: const Text("Submit Review")),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Return",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        const Divider(
                          thickness: 2,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Text(
                            "Add option here",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                        Container(
                          padding: _sideTopPadding,
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Return Product ")),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
