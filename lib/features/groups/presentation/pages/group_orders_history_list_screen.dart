import 'package:buyer/features/cart/data/models/cart_model.dart';
import 'package:buyer/features/order_history/data/models/order_model.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GroupOrderHistoryListScreen extends StatefulWidget {
  const GroupOrderHistoryListScreen({super.key});

  @override
  State<GroupOrderHistoryListScreen> createState() =>
      _GroupOrderHistoryListScreenState();
}

class _GroupOrderHistoryListScreenState
    extends State<GroupOrderHistoryListScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  bool _isLoading = false;
  bool _guestMode = true;

  String _userId = "";
  //this img is
  String img = "";
  List<CartModel> productsList = [];
  List<OrderModel> orderHistoryList = [];
/**orderHistoryList will have img,orderId,totalPrice, */
  int boxSize = 200;
  Future fetchorderHistoryList() async {
    _isLoading = true;
    orderHistoryList = [];

    if (_userId != null) {
      _guestMode = false;
      final forId = FirebaseFirestore.instance.collection("/groups/");
      final broref = forId.snapshots(); //geting all the docs snapshorts
      broref.listen((event) async {
        //just listening so that will update on change in database

        event.docs.forEach((element) {
          element.data().forEach((key, value) {
            if (key == 'orderHistory') {
              //every single document

              final docFromOrderHistory = value;

              if (value.length > 0) {
                int count = 0;
//below i changed from x to p
                for (int p = 0; p < value.length; p++) {
                  final docFromproducts =
                      docFromOrderHistory[p]["cartProducts"];

                  final
                      //  List<ParaInside> allParaInside = [];
                      List<CartModel> allProducts = [];
                  int countAllProducts = 0;
//added int in below code
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

                    if (countAllProducts == docFromproducts.length - 1) {
                      final singleOrderHistory = OrderModel(
                        cartProducts: allProducts,
                        orderId: docFromOrderHistory[p as int]["orderId"],
                        name: docFromOrderHistory[p as int]["name"],
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

                    if (count == docFromproducts.length) {
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
      });
    } else {
      _isLoading = false;
      if (mounted) setState(() {});
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
                                              child: SizedBox(
                                                height: constraints.maxHeight,
                                                width:
                                                    constraints.maxWidth * 0.33,
                                                child: Image.network(
                                                  "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/airtel%20flutter.webp?alt=media&token=461b7702-33c3-4d92-8f66-3f1b10d69c58",
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
                                                      child: Icon(Icons
                                                          .arrow_forward_ios_rounded),
                                                    ),
                                                  ],
                                                ),
                                                const Divider(
                                                  thickness: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 8.0),
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
                                                          "${orderHistoryList[index].totalPrice}",
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
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [],
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
