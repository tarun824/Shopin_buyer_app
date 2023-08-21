import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SelectOrderProductsScreen extends StatefulWidget {
  const SelectOrderProductsScreen({super.key, required this.argument});
  final argument;
  // here we will get List<CartModel>
  @override
  State<SelectOrderProductsScreen> createState() =>
      _SelectOrderProductsScreenState();
}

class _SelectOrderProductsScreenState extends State<SelectOrderProductsScreen> {
  final allPadding = Constants.allPadding;
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = false;
  String _userId = "";
  List<CartModel> products = [];
  List<CartModel> selectedProducts = [];

  @override
  Future fetchproducts() async {
    products = widget.argument;
  }

  Future addToCart() async {
    //for testing purpose we are directly providing user Id
    _userId = await TryAutoLogin().tryAutoLogin();

    final List<Map<String, String>> allPara = [];
    int countItems = 0;
    for (int n = 0; n < selectedProducts.length; n++) {
      int count = 0;

      for (int m = 0; m < selectedProducts[n].parameterSelected.length; m++) {
        final cateTitle =
            selectedProducts[n].parameterSelected[m]["parameter"] as String;
        final selectedCate =
            selectedProducts[n].parameterSelected[m]["selected"] as String;
        final singlePara = {"selected": selectedCate, "parameter": cateTitle};
        allPara.add(singlePara);
        count++;
      }
      if (count >= selectedProducts[n].parameterSelected.length) {
        final uploadJson = {
          "productId": selectedProducts[n].productId,
          "numberOfitems": selectedProducts[n].numberOfItems,
          "parameterSelected": allPara,
          "cata": selectedProducts[n].cata,
        };
        final forId =
            FirebaseFirestore.instance.collection("/buyers").doc(_userId);
        await forId.update({
          "cart": FieldValue.arrayUnion([uploadJson])
        });
        countItems++;
      }
      if (countItems >= selectedProducts.length) {
        _isLoading = false;
        selectedProducts = [];
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchproducts();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.25;
    final _itemCountNumber = 100;
    final _sizeForSizedBox = _heightOfBox * _itemCountNumber + 12.5;

    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: sideTopPadding,
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQueryHeight * 0.80,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: _sizeForSizedBox,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      String selectedPara = "";
                                      for (int c = 0;
                                          c <
                                              products[index]
                                                  .parameterSelected
                                                  .length;
                                          c++) {
                                        selectedPara = selectedPara +
                                            "${products[index].parameterSelected[c]["selected"]},";
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          selectedProducts.add(products[index]);
                                          if (mounted) setState(() {});
                                        },
                                        child: SizedBox(
                                            height: _heightOfBox,
                                            child: Card(
                                              elevation: 4,
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8.0),
                                                    child: Container(
                                                      height:
                                                          constraints.maxHeight,
                                                      width:
                                                          constraints.maxWidth *
                                                              0.3,
                                                      child: Image.network(
                                                        products[index]
                                                            .imgUrl[0],
                                                        fit: BoxFit.contain,
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
                                                                .only(top: 8.0),
                                                        child: SizedBox(
                                                          width: constraints
                                                                  .maxWidth *
                                                              0.42,
                                                          child: Text(
                                                            products[index]
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
                                                            color: Colors.green,
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
                                                            "(${products[index].review["5"]! + products[index].review["4"]! + products[index].review["3"]! + products[index].review["2"]! + products[index].review["1"]!})",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption,
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.48,
                                                        child: Column(
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                                  child: Text(
                                                                    products[
                                                                            index]
                                                                        .price
                                                                        .toStringAsFixed(
                                                                            0),
                                                                    style: Theme.of(
                                                                            context)
                                                                        .textTheme
                                                                        .bodyMedium!
                                                                        .copyWith(
                                                                            decoration:
                                                                                TextDecoration.lineThrough),
                                                                  ),
                                                                ),
                                                                Text(
                                                                  "${(products[index].discount["admin"]! + products[index].discount["seller"]! as int)}% off",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                                const Spacer(),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      bottom:
                                                                          8.0,
                                                                      right: 8),
                                                                  child: Text(
                                                                      "\₹${(products[index].price - (((products[index].discount["admin"]! + products[index].discount["seller"]! as int) / 100) * products[index].price)).toStringAsFixed(0)}",
                                                                      //the above logic is we are minusing the give price with the discounted amount
                                                                      //the discounted amount is calculated by adding the two discount given by admin
                                                                      //and seller and then divideing it by 100 so that we get result in 0.  then we multiply
                                                                      //that number(0.  ) with given price so that we get discounted amount

                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .titleLarge!
                                                                          .copyWith(
                                                                              fontSize: 20)),
                                                                ),
                                                              ],
                                                            ),
                                                            Text(
                                                              selectedPara,
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .bodyMedium,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const Spacer(),
                                                  Center(
                                                      child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 12.0),
                                                    child: (selectedProducts
                                                            .contains(products[
                                                                index]))
                                                        ? const Icon(
                                                            Icons.check_box)
                                                        : const Icon(Icons
                                                            .check_box_outline_blank_rounded),
                                                  ))
                                                ],
                                              ),
                                            )),
                                      );
                                    });
                              }),
                            )
                          ],
                        ),
                      ),
                    ),
                    Tooltip(
                      message: "Select the products to add for cart ",
                      child: InkWell(
                        splashColor: Theme.of(context).primaryColor,
                        child: SizedBox(
                            height: _mediaQueryHeight * 0.07,
                            width: _mediaQueryWidth / 0.5,
                            child: const Center(
                                child: Text("Select products for cart"))),
                        onTap: () {
                          if (selectedProducts.length > 0) {
                            _isLoading = true;
                            addToCart();
                          } else {
                            var snackBar = const SnackBar(
                                content: Text('Select products to add'));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
