import 'package:buyer/features/order_history/data/models/order_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class OrderStatusScreen extends StatefulWidget {
  const OrderStatusScreen({super.key, required this.argument});
  final argument;
  //here we get OrderModel

/**here we want orderId with that we fetch the order status 
   ,Address (if we have name then that too) ,list of products will have
   productId
numberOfitems
parameterSelected
cata ,so you have to fetch products*/

//and another thoing that should me made is when clicked on select products then
//navigate to another page and make select and OR add all and just swip to delete
//and add that variable to DB thats all
  @override
  State<OrderStatusScreen> createState() => _OrderStatusScreenState();
}

enum isActive { orderPlaced, shipped, delivered }

class _OrderStatusScreenState extends State<OrderStatusScreen> {
  final allPadding = Constants.allPadding;
  final sideTopPadding = Constants.sideTopPadding;
  int _currentStep = 0;
  bool _isLoading = false;
  String _userId = "";

  OrderModel products = OrderModel(
      orderId: "orderId",
      cartProducts: [],
      totalPrice: 0,
      userId: "userId",
      name: "name",
      address: Address(
          sideAddress: "sideAddress",
          city: "city",
          country: "country",
          state: "state",
          pinNumber: 0),
      phNumber: 0,
      paymentMode: "paymentMode",
      status: []);
  @override
  Future fetchproducts() async {
    products = widget.argument;
    ((products.status[2]["dateTime"] == "DeliveredTime") &&
            products.status[1]["dateTime"] == "ShippedTime")
        ? _currentStep = 0
        : (products.status[2]["dateTime"] == "DeliveredTime")
            ? _currentStep = 1
            : _currentStep = 2;
  }

  Future addToCart() async {
    _userId = await TryAutoLogin().tryAutoLogin();

    final List<Map<String, String>> allPara = [];
    int countItems = 0;
    for (int n = 0; n < products.cartProducts.length; n++) {
      int count = 0;

      for (int m = 0;
          m < products.cartProducts[n].parameterSelected.length;
          m++) {
        final cateTitle = products.cartProducts[n].parameterSelected[m]
            ["parameter"] as String;
        final selectedCate =
            products.cartProducts[n].parameterSelected[m]["selected"] as String;
        final singlePara = {"selected": selectedCate, "parameter": cateTitle};
        allPara.add(singlePara);
        count++;
      }
      if (count >= products.cartProducts[n].parameterSelected.length) {
        final uploadJson = {
          "productId": products.cartProducts[n].productId,
          "numberOfitems": products.cartProducts[n].numberOfItems,
          "parameterSelected": allPara,
          "cata": products.cartProducts[n].cata,
        };
        final forId =
            FirebaseFirestore.instance.collection("/buyers").doc(_userId);
        await forId.update({
          "cart": FieldValue.arrayUnion([uploadJson])
        });
        countItems++;
      }
      if (countItems >= products.cartProducts.length) {
        _isLoading = false;
        if (mounted) if (mounted) setState(() {});
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
    final _itemCountNumber = products.cartProducts.length;
    final _sizeForSizedBox = _heightOfBox * _itemCountNumber + 12.5;
    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "Order Status"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: sideTopPadding,
                child: Column(
                  children: [
                    SizedBox(
                      height: _mediaQueryHeight * 0.76,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Order Id: ${products.orderId} ",
                              style: Theme.of(context).textTheme.caption,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                /**status has list of status like 0th index has ordered followed by 1st index with Shipped and last has  delivered
                                                         here we are checking if( 2nd and 1st) index's ["dateTime"] has value  "DeliveredTime" and "ShippedTime" then print 0th
                                                         index's "title" or else check if 2nd of status contains ["dateTime"] as "DeliveredTime" then that means it is not delivered so
                                                         show 1st ["title"] that is Shipped and if 2nd ["dateTime"] doesnot equal "DeliveredTime" then show 2nd ["dateTime"]
                                                         */
                                ((products.status[2]["dateTime"] ==
                                            "DeliveredTime") &&
                                        products.status[1]["dateTime"] ==
                                            "ShippedTime")
                                    ? "Order Satus: ${products.status[0]["title"]}"
                                    : (products.status[2]["dateTime"] ==
                                            "DeliveredTime")
                                        ? "Order Satus: ${products.status[1]["title"]}"
                                        : "Order Satus: ${products.status[2]["title"]}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              child: Stepper(
                                // here we want to manualy change currentStep and isActive
                                currentStep: _currentStep,
                                controlsBuilder: (context, details) =>
                                    const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                                steps: [
                                  Step(
                                      isActive: (_currentStep >= 0),
                                      title: SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                products.status[0]["title"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                products.status[0]["dateTime"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          )),
                                      content:
                                          Container()), //why not SizedBox beacuse some ui error comes soo
                                  Step(
                                      isActive: (_currentStep >= 1),
                                      title: SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                products.status[1]["title"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                products.status[1]["dateTime"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          )),
                                      content: Container()),
                                  Step(
                                      isActive: (_currentStep >= 2),
                                      title: SizedBox(
                                          height: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                products.status[2]["title"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                              Text(
                                                products.status[2]["dateTime"]!,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall,
                                              ),
                                            ],
                                          )),
                                      content: Container()),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Address:${products.address.sideAddress},${products.address.city},${products.address.state},${products.address.country}",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            Text(
                              "Phone Number: ${products.phNumber}",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: Text(
                                "List of Products",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const Divider(
                              thickness: 2,
                            ),
                            SizedBox(
                              height: _sizeForSizedBox,
                              child: LayoutBuilder(
                                  builder: (context, constraints) {
                                return ListView.builder(
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: products.cartProducts.length,
                                    itemBuilder: (context, index) {
                                      String selectedPara = "";
                                      for (int c = 0;
                                          c <
                                              products.cartProducts[index]
                                                  .parameterSelected.length;
                                          c++) {
                                        selectedPara = selectedPara +
                                            "${products.cartProducts[index].parameterSelected[c]["selected"]},";
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, "/orderReviewScreen",
                                              arguments:
                                                  products.cartProducts[index]);
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
                                                        products
                                                            .cartProducts[index]
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
                                                            products
                                                                .cartProducts[
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
                                                            "(${products.cartProducts[index].review["5"]! + products.cartProducts[index].review["4"]! + products.cartProducts[index].review["3"]! + products.cartProducts[index].review["2"]! + products.cartProducts[index].review["1"]!})",
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
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          5.0),
                                                                  child: Text(
                                                                    products
                                                                        .cartProducts[
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
                                                                  "${(products.cartProducts[index].discount["admin"]! + products.cartProducts[index].discount["seller"]! as int)}% off",
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
                                                                      "\₹${(products.cartProducts[index].price - (((products.cartProducts[index].discount["admin"]! + products.cartProducts[index].discount["seller"]! as int) / 100) * products.cartProducts[index].price)).toStringAsFixed(0)}",
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
                                                              "selected: $selectedPara",
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
                                                  const Center(
                                                      child: Padding(
                                                    padding: EdgeInsets.only(
                                                        right: 5.0),
                                                    child: Icon(Icons
                                                        .arrow_forward_ios_rounded),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Tooltip(
                          message: "Select the products to add for cart ",
                          child: InkWell(
                            splashColor: Theme.of(context).primaryColor,
                            child: SizedBox(
                                height: _mediaQueryHeight * 0.07,
                                width: _mediaQueryWidth / 2.2,
                                child: const Center(
                                    child: Text("Select products for cart"))),
                            onTap: () {
                              Navigator.pushNamed(
                                  context, "/selectOrderProductsScreen",
                                  arguments: products.cartProducts);
                            },
                          ),
                        ),
                        Tooltip(
                          message: "Add All products to Cart",
                          child: InkWell(
                            focusColor: Theme.of(context).primaryColor,
                            child: SizedBox(
                                height: _mediaQueryHeight * 0.07,
                                width: _mediaQueryWidth / 2.2,
                                child: const Center(child: Text("Add All"))),
                            onTap: () {
                              _isLoading = true;
                              if (mounted) if (mounted) setState(() {});
                              addToCart();
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
