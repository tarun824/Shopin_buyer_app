import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/order_history/data/models/order_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class OrderHistoryListScreen extends StatefulWidget {
  const OrderHistoryListScreen({super.key, required this.argument});

  // here we get groupId and isGroupHistoryOrder
  final argument;
// from userId fetch order history ->initialImg
//from initialImg["productId"] and initialImg["cata"] fetch image and initialze that card with orderId

//will show img,totalPrice,
  @override
  State<OrderHistoryListScreen> createState() => _OrderHistoryListScreenState();
}

class _OrderHistoryListScreenState extends State<OrderHistoryListScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = false;
  bool _guestMode = true;
  bool _isGroupHistoryOrder = false;
  String _groupId = "";

  dynamic _userId = "";
  String _userName = "";

  //this img is
  String img = "";
  List<CartModel> productsList = [];
  List<OrderModel> orderHistoryList = [];
/**orderHistoryList will have img,orderId,totalPrice, */
  bool dumyBool = false;

  Future fetchorderHistoryList() async {
    _isGroupHistoryOrder = widget.argument["isGroupHistoryOrder"];
    _groupId = widget.argument["groupId"];

    _isLoading = true;
    orderHistoryList = [];
    _userId = await TryAutoLogin().tryAutoLogin();

    if (_isGroupHistoryOrder) {
      dumyBool = true;
      final forId =
          FirebaseFirestore.instance.collection("/groups").doc(_groupId);
      if (_userId != null && dumyBool) {
        dumyBool = false;
        _guestMode = false;

        final broref = forId.snapshots(); //geting all the docs snapshorts
        broref.listen((event) async {
          //just listening so that will update on change in database

          event.data()!.forEach((key, value) {
            if (key == "groupDetails") {
              _userName = value["groupName"];

              final docFromOrderHistory = value["orderHistory"];
              if (docFromOrderHistory.length > 0) {
                int count = 0;
                //below i changed from x to p
                for (int p = 0; p < docFromOrderHistory.length; p++) {
//p is number of order history

                  final docFromproducts =
                      docFromOrderHistory[p]["cartProducts"];

                  List<CartModel> allProducts = [];
                  int countAllProducts = 0;
                  //added int in below code
                  for (int x = 0; x < docFromproducts.length; x++) {
                    //x is for cart products
                    final singleProduct = CartModel(
                      title: docFromproducts[x]["title"],
                      price: docFromproducts[x]["price"],
                      discount: {
                        "admin": docFromproducts[x]["discount"]["admin"],
                        "seller": docFromproducts[x]["discount"]["seller"],
                      },
                      cata: docFromproducts[x]["cata"],
                      imgUrl: docFromproducts[x]["imgUrl"],
                      numberOfItems: docFromproducts[x]["numberOfItems"],
                      parameterSelected: docFromproducts[x]
                          ["parameterSelected"],
                      productId: docFromproducts[x]["productId"],
                      review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
                      sellerId: docFromproducts[x]["sellerId"],
                    );
                    allProducts.add(singleProduct);
                    countAllProducts++;

                    if (countAllProducts == docFromproducts.length - 1) {
                      final singleOrderHistory = OrderModel(
                        cartProducts: allProducts,
                        orderId: docFromOrderHistory[p as int]["orderId"],
                        name: _userName,
                        totalPrice: docFromOrderHistory[p as int]["totalPrice"],
                        userId: _userId,
                        phNumber: docFromOrderHistory[p as int]["phNumber"],
                        paymentMode: docFromOrderHistory[p as int]
                            ["paymentMode"],
                        address: Address(
                          sideAddress: docFromOrderHistory[p as int]["address"]
                              ["sideAddress"],
                          city: docFromOrderHistory[p as int]["address"]
                              ["city"],
                          country: docFromOrderHistory[p as int]["address"]
                              ["country"],
                          state: docFromOrderHistory[p as int]["address"]
                              ["state"],
                          pinNumber: docFromOrderHistory[p as int]["address"]
                              ["pinNumber"],
                        ),
                        status: docFromOrderHistory[p as int]["status"],
                      );
                      orderHistoryList.add(singleOrderHistory);
                      count++;
                    }

                    if (count == docFromOrderHistory.length) {
                      _isLoading = false;
                      if (mounted) setState(() {});
                    }
                  }
                }

                //just for _isLoading coming outside of loop sooo
              } else {
                // if length of items <0

                _isLoading = false;
                if (mounted) setState(() {});
              }

              //to get user Id even to push that item
            }
          });
        });
      } else {
        _isLoading = false;
        if (mounted) setState(() {});
      }
    } else {
      dumyBool = true;

      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      if (_userId != null && dumyBool) {
        dumyBool = false;
        _guestMode = false;

        final broref = forId.snapshots(); //geting all the docs snapshorts
        broref.listen((event1) async {
          //just listening so that will update on change in database

          event1.data()!.forEach((key, value) {
            _userName = event1["name"];
            if (key == "name") {
              _userName = value;
            }

            if (key == 'orderHistory') {
              final docFromOrderHistory = value;
              if (docFromOrderHistory.length > 0) {
                int count = 0;
                //below i changed from x to p
                for (int p = 0; p < docFromOrderHistory.length; p++) {
                  final docFromproducts =
                      docFromOrderHistory[p]["cartProducts"];

                  final List<CartModel> allProducts = [];
                  int countAllProducts = 0;
                  for (int x = 0; x < docFromproducts.length; x++) {
                    final singleProduct = CartModel(
                      title: docFromproducts[x]["title"],
                      price: docFromproducts[x]["price"],
                      discount: {
                        "admin": docFromproducts[x]["discount"]["admin"],
                        "seller": docFromproducts[x]["discount"]["seller"],
                      },
                      cata: docFromproducts[x]["cata"],
                      imgUrl: docFromproducts[x]["imgUrl"],
                      numberOfItems: docFromproducts[x]["numberOfItems"],
                      parameterSelected: docFromproducts[x]
                          ["parameterSelected"],
                      productId: docFromproducts[x]["productId"],
                      review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
                      sellerId: docFromproducts[x]["sellerId"],
                    );
                    allProducts.add(singleProduct);
                    countAllProducts++;
                    if (countAllProducts == docFromproducts.length - 1 &&
                        _userName != "") {
                      final singleOrderHistory = OrderModel(
                        cartProducts: allProducts,
                        orderId: docFromOrderHistory[p as int]["orderId"],
                        name: _userName,
                        totalPrice: docFromOrderHistory[p as int]["totalPrice"],
                        userId: _userId,
                        phNumber: docFromOrderHistory[p as int]["phNumber"],
                        paymentMode: docFromOrderHistory[p as int]
                            ["paymentMode"],
                        address: Address(
                          sideAddress: docFromOrderHistory[p as int]["address"]
                              ["sideAddress"],
                          city: docFromOrderHistory[p as int]["address"]
                              ["city"],
                          country: docFromOrderHistory[p as int]["address"]
                              ["country"],
                          state: "docFromOrderHistory[p as int]["
                              "address"
                              "]["
                              "state"
                              "]",
                          pinNumber: docFromOrderHistory[p as int]["address"]
                              ["pinNumber"],
                        ),
                        status: docFromOrderHistory[p as int]["status"],
                      );
                      orderHistoryList.add(singleOrderHistory);

                      count++;
                    }

                    if (count == docFromOrderHistory.length) {
                      _isLoading = false;
                      if (mounted) setState(() {});
                    }
                  }
                }

                //just for _isLoading coming outside of loop sooo
              } else {
                // if length of items <0

                _isLoading = false;
                if (mounted) setState(() {});
              }
            } else {}
          });
        });
      } else {
        _isLoading = false;
        if (mounted) setState(() {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchorderHistoryList();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.24;
    final _widthOfBox = _mediaQueryWidth;

    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, "Order History"),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _guestMode
                ? const Center(
                    child: Text("Login to see cart Items"),
                  )
                : orderHistoryList.isEmpty
                    ? const Center(
                        child: Text("Order some Products to see here"),
                      )
                    : Padding(
                        padding: sideTopPadding,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: orderHistoryList.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/orderStatusScreen",
                                      arguments: orderHistoryList[index]);
                                },
                                child: SizedBox(
                                  height: _heightOfBox * 0.92,
                                  child: Card(
                                      elevation: 4,
                                      child: LayoutBuilder(
                                          builder: (context, constraints) {
                                        return Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: Container(
                                                height: constraints.maxHeight,
                                                width:
                                                    constraints.maxWidth * 0.33,
                                                child: Image.network(
                                                  orderHistoryList[index]
                                                      .cartProducts[0]
                                                      .imgUrl[0],
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
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Column(
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
                                                              "Address:${orderHistoryList[index].address.sideAddress},${orderHistoryList[index].address.city},${orderHistoryList[index].address.state},${orderHistoryList[index].address.country}",
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
                                                        Text(
                                                          "Phone Number: ${orderHistoryList[index].phNumber}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .caption,
                                                        ),
                                                        SizedBox(
                                                          width: _widthOfBox *
                                                              0.42,
                                                          child: Text(
                                                            "Payment Mode: ${orderHistoryList[index].paymentMode}",
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption!,
                                                          ),
                                                        ),
                                                        Text(
                                                          /**status has list of status like 0th index has ordered followed by 1st index with Shipped and last has  delivered
                                                           here we are checking if( 2nd and 1st) index's ["dateTime"] has value  "DeliveredTime" and "ShippedTime" then print 0th
                                                           index's "title" or else check if 2nd of status contains ["dateTime"] as "DeliveredTime" then that means it is not delivered so
                                                           show 1st ["title"] that is Shipped and if 2nd ["dateTime"] doesnot equal "DeliveredTime" then show 2nd ["dateTime"]
                                                           */
                                                          ((orderHistoryList[index]
                                                                              .status[2]
                                                                          [
                                                                          "dateTime"] ==
                                                                      "DeliveredTime") &&
                                                                  orderHistoryList[index]
                                                                              .status[1]
                                                                          [
                                                                          "dateTime"] ==
                                                                      "ShippedTime")
                                                              ? "Order Status: ${orderHistoryList[index].status[0]["title"]}"
                                                              : (orderHistoryList[index]
                                                                              .status[2]
                                                                          [
                                                                          "dateTime"] ==
                                                                      "DeliveredTime")
                                                                  ? "Order Status: ${orderHistoryList[index].status[1]["title"]}"
                                                                  : "Order Status: ${orderHistoryList[index].status[2]["title"]}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .bodyMedium!,
                                                        ),
                                                      ],
                                                    ),
                                                    const Center(
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 18.0),
                                                        child: Icon(Icons
                                                            .arrow_forward_ios_rounded),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 90.0),
                                                      child: Text(
                                                        "Total:",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium!,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8),
                                                      child: Text(
                                                          "${orderHistoryList[index].totalPrice.toStringAsFixed(0)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          20)),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        );
                                      })),
                                ),
                              );
                            }),
                      ),
      ),
    );
  }
}
