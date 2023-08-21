import 'package:buyer/features/cart/data/models/cart_model.dart';

import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:buyer/utilities/textfield_input_decoration.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderProcessScreen extends StatefulWidget {
  OrderProcessScreen({super.key, required this.argument});
  //here we get List<CartModel> and isGroup

  final argument;

  @override
  State<OrderProcessScreen> createState() => _OrderProcessScreenState();
}

class _OrderProcessScreenState extends State<OrderProcessScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  final sidePadding = Constants.sidePadding;
  bool _isLoading = false;
  bool _forStepUpError = true;

  String _userId = "";
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _phNumberController = TextEditingController();
  final TextEditingController _sideAddressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _pinNumberController = TextEditingController();

  final _phnumberFocusNode = FocusNode();
  final _sideAddressFocusNode = FocusNode();
  final _cityFocusNode = FocusNode();
  final _countryFocusNode = FocusNode();
  final _stateFocusNode = FocusNode();
  final _pinNumberFocusNode = FocusNode();

  String _userName = '';
  Map<String, dynamic> address = {
    "sideAddress": "sideAddress",
    "city": "city",
    "country": "country",
    "state": "state",
    "pinNumber": 0,
  };
  List<Map<String, dynamic>> coupan = [];
  //coupan has coupanName and price
  bool coupanSelected = false;
  bool coinsSelected = false;
  int minusAmount = 0;

  int phNumber = 0;
  int coins = 0;
  int forDbCoinsMinus = 0;

  List<CartModel> buyProducts = [];

  int _currentStep = 0;
  //there are only three thing to assign based on which it works three things are
  //Address,Payment,Order Successfull
  String isActive = "Order Successfull";
  List<String> paraString = ["", "", "", ""];
  bool addressSelected = true;
  bool isGroup = false;
  String groupId = "";

  double totalPrice = 0;
  Future findTotal() async {
    buyProducts = [];
    buyProducts = widget.argument["products"];
    isGroup = widget.argument["isGroup"];
    groupId = widget.argument["groupId"];

    totalPrice = 0;
    for (int x = 0; x < buyProducts.length; x++) {
      final double singleAmount = await (buyProducts[x].price -
          (((buyProducts[x].discount["admin"]! +
                      buyProducts[x].discount["seller"]! as int) /
                  100) *
              buyProducts[x].price)) as double;
      totalPrice = totalPrice + singleAmount * buyProducts[x].numberOfItems;
      for (int y = 0; y < buyProducts[x].parameterSelected.length; y++) {
        paraString[y] = buyProducts[x].parameterSelected[y]["selected"] +
            buyProducts[x].parameterSelected[y]["selected"];
      }
    }
    _userId = await TryAutoLogin().tryAutoLogin();

    if (_userId != null) {
      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      final broref = forId.snapshots(); //geting all the docs snapshorts
      await broref.listen((element) {
        //just listening so that will update on change in database
        //getting all the docs in single

        coins = element["coins"];
        element.data()!.forEach((key, value) {
          //here we are intarating through all the map inside field
          if (key == "coins") {
            coins = value;
          }
          if (key == 'coupan') {
            if (value.length > 0) {
              //need to change this code

              // print(coupan[0]);

              coupan.add({
                "coupanName": value[0]["coupanName"],
                "price": value[0]["price"]
              });
            }
          }
        });
      });
    }
  }

  Future AddToOrderHistory() async {
    if (_userId != null) {
      final forId =
          FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      final broref = forId.snapshots(); //geting all the docs snapshorts
      await broref.listen((element) {
        //just listening so that will update on change in database
        //getting all the docs in single

        //we get all the field printed here
        element.data()!.forEach((key, value) {
          //here we are intarating through all the map inside field

          if (key == 'address') {
            address = {
              "sideAddress": value["sideAddress"],
              "city": value["city"],
              "country": value["country"],
              " state": value["state"],
              "pinNumber": value["pinNumber"],
            };
          }
          if (key == "phNumber") {
            phNumber = value;
          }

          if (key == "name") {
            _userName = value;
          }

          //just ckecking if the key is para

          if (_forStepUpError) {
            if (address["pinNumber"] != 0 && phNumber != 0 && _userName != "") {
              _forStepUpError = false;

              DocumentReference<Map<String, dynamic>> userInstance = forId;

              final List<Map<String, dynamic>> uploadBuyProducts = [];
              final lengthOfBuyProducts = buyProducts.length;
              int countProducts = 0;
              int count = 0;
              for (int p = 0; p < lengthOfBuyProducts; p++) {
                final List<Map<String, dynamic>> allPara = [];
                count = 0;

                for (int y = 0;
                    y < buyProducts[p].parameterSelected.length;
                    y++) {
                  final x = {
                    "parameter": buyProducts[p].parameterSelected[y]
                        ["parameter"],
                    "selected": buyProducts[p].parameterSelected[y]["selected"],
                  };
                  allPara.add(x);
                  count++;
                }
                if (count == buyProducts[p].parameterSelected.length) {
                  final cartModel = {
                    "productId": buyProducts[p].productId,
                    "title": buyProducts[p].title,
                    "imgUrl": buyProducts[p].imgUrl,
                    "price": buyProducts[p].price,
                    "discount": buyProducts[p].discount,
                    "review": buyProducts[p].review,
                    "cata": buyProducts[p].cata,
                    "numberOfItems": buyProducts[p].numberOfItems,
                    "parameterSelected": allPara,
                    "sellerId": buyProducts[p].sellerId,
                  };
                  uploadBuyProducts.add(cartModel);
                  countProducts++;
                }

                if (countProducts == lengthOfBuyProducts && mounted) {
                  final orderModel = {
                    "orderId": DateTime.now().microsecondsSinceEpoch.toString(),
                    "name": _userName,
                    "cartProducts": uploadBuyProducts,
                    "userId": _userId,
                    "totalPrice": totalPrice,
                    "address": address,
                    "phNumber": phNumber,
                    "paymentMode": "Cash on Delivery",
                    "status": [
                      {
                        "title": "Ordered",
                        "dateTime": DateFormat('dd/MM/yyyy')
                            .format(DateTime.now())
                            .toString()
                      },
                      {"title": "Shipped", "dateTime": "ShippedTime"},
                      {"title": "Delivered", "dateTime": "DeliveredTime"}
                    ]
                  };
                  isGroup
                      ? {
                          print("updated this group"),
                          userInstance = FirebaseFirestore.instance
                              .collection("/groups")
                              .doc(groupId),
                          userInstance.update({
                            "groupDetails.orderHistory":
                                FieldValue.arrayUnion([orderModel])
                          }),
                          deleteInCart()
                        }
                      : {
                          print("updated this not Group"),
                          userInstance.update({
                            "orderHistory": FieldValue.arrayUnion([orderModel])
                          }),
                          deleteInCart()
                        };
                }
              }
            }
          }
        });
      });
    }
  }

  Future deleteInCart() async {
    final forCoinsAndCoupan =
        await FirebaseFirestore.instance.collection("/buyers").doc(_userId);
    if (isGroup) {
      final forGroup =
          await FirebaseFirestore.instance.collection("/groups/$groupId/cart");
      await forGroup.get().then((eachDoc) {
        for (DocumentSnapshot document in eachDoc.docs) {
          document.reference.delete();
          _isLoading = false;
          if (mounted) setState(() {});
        }
      });
    } else {
      final userInstance =
          await FirebaseFirestore.instance.collection("/buyers").doc(_userId);
      if (_userId != null) {
        final broref =
            userInstance.snapshots(); //geting all the docs snapshorts
        await broref.listen((element) {
          //just listening so that will update on change in database
          //getting all the docs in single
          //we get all the field printed here
          element.data()!.forEach((key, value) {
            //here we are intarating through all the map inside field
            userInstance.update({"coins": coins});
            if (key == 'cart') {
              userInstance.update({"cart": []});
              _isLoading = false;
              if (mounted) setState(() {});
              ////just ckecking if the key is para
            }
          });
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      findTotal();
    }
  }

  @override
  void dispose() {
    _phnumberFocusNode.dispose();
    _sideAddressFocusNode.dispose();
    _cityFocusNode.dispose();
    _countryFocusNode.dispose();
    _stateFocusNode.dispose();
    _pinNumberFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.16;
    final _widthOfBox = _mediaQueryWidth;
    final _itemCountNumber = buyProducts.length;
    final _sizeForSizedBox = _heightOfBox * _itemCountNumber + 12.5;
    return SafeArea(
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(semanticsLabel: "Loading"),
              )
            : Stepper(
                physics: const BouncingScrollPhysics(),
                // here we want to manualy change currentStep and isActive
                currentStep: _currentStep,
                type: StepperType.horizontal,
                controlsBuilder:
                    (BuildContext context, ControlsDetails details) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: _currentStep == 1
                                //if it is in second then in the place of Continue have Pay now
                                ? const Text("Pay now")
                                : _currentStep == 2
                                    //if it is in third then in the place of Continue have Click for Home page

                                    ? Text(AppLocalizations.of(context)!
                                            .clickForHomePage
                                        // "Click for Home page"
                                        )
                                    : _currentStep == 0 && (!addressSelected)
                                        ? Text(AppLocalizations.of(context)!
                                                .saveChangesAndContinue
                                            // 'Save changes & Continue'
                                            )
                                        : Text(AppLocalizations.of(context)!
                                                .continueName
                                            // 'Continue'
                                            ),
                          ),
                        ),
                      ),
                      _currentStep == 2 || _currentStep == 0
                          ? const SizedBox(
                              height: 0,
                              width: 0,
                            )
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 8.0),
                              child: SizedBox(
                                height: 52,
                                width: double.infinity,
                                child: TextButton(
                                  onPressed: details.onStepCancel,
                                  child: _currentStep == 2
                                      ? const Text("Home Page")
                                      : const Text('Back '),
                                ),
                              ),
                            )
                    ],
                  );
                },
                onStepCancel: () {
                  if (_currentStep > 0 && _currentStep != 2 && mounted) {
                    if (mounted) setState(() => _currentStep -= 1);
                  }
                },
                onStepTapped: (value) {
                  if (mounted && mounted)
                    setState(() {
                      _currentStep = value;
                    });
                },
                onStepContinue: () {
                  if (_currentStep == 1 && mounted) {
                    //operation on second step that is Buy Now
                    _isLoading = true;
                    if (mounted) setState(() {});
                    AddToOrderHistory();
                  } else if (_currentStep == 2) {
                    Navigator.popAndPushNamed(context, "/mainPageNavigator",
                        arguments: _userId);
                  }
                  if (_currentStep < 2 && mounted) {
                    if (mounted) setState(() => _currentStep += 1);
                  }
                },
                steps: [
                    Step(
                      //products show and pay now done
                      isActive: _currentStep >= 0,
                      title: Text(
                        AppLocalizations.of(context)!.address,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      content: Column(children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Checkbox(
                                  value: addressSelected,
                                  onChanged: (value) {
                                    addressSelected = value!;
                                    setState(() {});
                                  }),
                            ),
                            Text(
                              AppLocalizations.of(context)!.sameAddress,
                              // "Same Address"
                            )
                          ],
                        ),
                        addressSelected
                            ? const SizedBox(
                                height: 0,
                                width: 0,
                              )
                            : Padding(
                                padding: sideTopPadding,
                                child: SizedBox(
                                  height: _mediaQueryHeight * 0.77,
                                  width: _mediaQueryWidth * 0.8,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        AppLocalizations.of(context)!
                                            .fillDetails,
                                        // "Fill your Details",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      const Text("Enter Email Id"),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5),
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: _userNameController,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _phnumberFocusNode);
                                          },
                                          decoration: TextfieldInputDecoration()
                                              //st parameter label,2nd hint Text ,3rd Error message
                                              .textfieldInputDecoration(
                                                  "Email ID",
                                                  "example@gmail.com",
                                                  "Enter Valid Email ID"),
                                          onChanged: (value) {
                                            _userName = value;
                                          },
                                        ),
                                      ),
                                      const Text("Enter Phone Number"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: _phNumberController,
                                          textInputAction: TextInputAction.next,
                                          focusNode: _phnumberFocusNode,
                                          keyboardType: TextInputType.number,
                                          onSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _sideAddressFocusNode);
                                          },
                                          decoration: TextfieldInputDecoration()
                                              //st parameter label,2nd hint Text ,3rd Error message
                                              .textfieldInputDecoration(
                                                  "Phone Number",
                                                  "Phone number",
                                                  "Enter Valid phone number"),
                                          onChanged: (value) {
                                            phNumber = int.parse(value);
                                          },
                                        ),
                                      ),
                                      Text(
                                        " Delivery Address",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      const Divider(
                                        thickness: 2,
                                      ),
                                      const Text("Enter Address"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: _sideAddressController,
                                          focusNode: _sideAddressFocusNode,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) {
                                            FocusScope.of(context)
                                                .requestFocus(_cityFocusNode);
                                          },
                                          decoration: TextfieldInputDecoration()
                                              //st parameter label,2nd hint Text ,3rd Error message
                                              .textfieldInputDecoration(
                                                  "Address",
                                                  "Road,apartment,building,floor,etc.",
                                                  "Enter Valid Address"),
                                          onChanged: (value) {
                                            address["sideAddress"] = value;
                                          },
                                        ),
                                      ),
                                      const Text("Enter city"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: _cityController,
                                          textInputAction: TextInputAction.next,
                                          onSubmitted: (_) {
                                            FocusScope.of(context).requestFocus(
                                                _countryFocusNode);
                                          },
                                          focusNode: _cityFocusNode,
                                          decoration: TextfieldInputDecoration()
                                              //st parameter label,2nd hint Text ,3rd Error message
                                              .textfieldInputDecoration("City",
                                                  "City", "Enter Valid City"),
                                          onChanged: (value) {
                                            address["city"] = value;

                                            // _city = value;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 90,
                                        width: double.infinity,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              height: 92,
                                              width: 150,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text("Enter Country"),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        vertical: 5.0),
                                                    child: TextField(
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      controller:
                                                          _countryController,
                                                      textInputAction:
                                                          TextInputAction.next,

                                                      onSubmitted: (_) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                _stateFocusNode);
                                                      },
                                                      focusNode:
                                                          _countryFocusNode,
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText: "  Country",
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        2,
                                                                    vertical:
                                                                        18),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius: Constants
                                                              .textFieldBorderRadius,
                                                        ),
                                                      ),

                                                      //                         //st parameter label,2nd hint Text ,3rd Error message

                                                      onChanged: (value) {
                                                        address["country"] =
                                                            value;
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              height: 92,
                                              width: 150,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Text("Enter State"),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 2,
                                                        vertical: 5.0),
                                                    child: TextField(
                                                      textAlignVertical:
                                                          TextAlignVertical
                                                              .center,
                                                      controller:
                                                          _stateController,
                                                      textInputAction:
                                                          TextInputAction.next,
                                                      focusNode:
                                                          _stateFocusNode,

                                                      onSubmitted: (_) {
                                                        FocusScope.of(context)
                                                            .requestFocus(
                                                                _pinNumberFocusNode);
                                                      },
                                                      decoration:
                                                          const InputDecoration(
                                                        hintText:
                                                            "  Phone number",
                                                        contentPadding:
                                                            EdgeInsets
                                                                .symmetric(
                                                                    vertical:
                                                                        18),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderRadius: Constants
                                                              .textFieldBorderRadius,
                                                        ),
                                                      ),

                                                      //     //st parameter label,2nd hint Text ,3rd Error message

                                                      onChanged: (value) {
                                                        address["state"] =
                                                            value;
                                                      },
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const Text("Enter Pin Number"),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 5.0),
                                        child: TextField(
                                          textAlignVertical:
                                              TextAlignVertical.center,
                                          controller: _pinNumberController,
                                          textInputAction: TextInputAction.done,
                                          keyboardType: TextInputType.number,
                                          focusNode: _pinNumberFocusNode,
                                          decoration: TextfieldInputDecoration()
                                              //st parameter label,2nd hint Text ,3rd Error message
                                              .textfieldInputDecoration(
                                                  "Pin Number",
                                                  "Pin Number",
                                                  "Enter Valid Pin Number"),
                                          onChanged: (value) {
                                            address["pinNumber"] = value;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                      ]),
                    ),
                    Step(
                      isActive: _currentStep >= 1,
                      title: Text(
                        'Payment',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      content: Column(
                        children: [
                          SizedBox(
                            height: _sizeForSizedBox,
                            width: _mediaQueryWidth,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _itemCountNumber,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {},
                                      child: SizedBox(
                                          height: _heightOfBox,
                                          child: Card(
                                            elevation: 4,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 0),
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
                                                      child:
                                                          // Text("Image here")
                                                          Image.network(
                                                        buyProducts[index]
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
                                                              0.45,
                                                          child: Text(
                                                            buyProducts[index]
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
                                                      SizedBox(
                                                        width: constraints
                                                                .maxWidth *
                                                            0.35,
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
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
                                                                    "₹${buyProducts[index].price}",
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
                                                                  "${(buyProducts[index].discount["admin"]! + buyProducts[index].discount["seller"]! as int)}% off",
                                                                  style: Theme.of(
                                                                          context)
                                                                      .textTheme
                                                                      .bodyMedium,
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Center(
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                        left: 8,
                                                      ),
                                                      child: Text(
                                                          "\₹${(buyProducts[index].price - (((buyProducts[index].discount["admin"]! + buyProducts[index].discount["seller"]! as int) / 100) * buyProducts[index].price)).toStringAsFixed(0)}",
                                                          style:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .titleLarge!
                                                                  .copyWith(
                                                                      fontSize:
                                                                          20)),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )),
                                    );
                                  });
                            }),
                          ),
                          coupan.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Divider(
                                      thickness: 2,
                                    ),
                                    Text(AppLocalizations.of(context)!.coupon,
                                        // "Coupan",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold)),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Checkbox(
                                              value: coupanSelected,
                                              onChanged: (value) {
                                                coupanSelected = value!;
                                                if (coupan[0]["price"] >
                                                    coins) {
                                                  if (coupanSelected) {
                                                    totalPrice = totalPrice -
                                                        coupan[0]["price"];
                                                    // coins=0;
                                                  } else {
                                                    totalPrice = totalPrice +
                                                        coupan[0]["price"];
                                                  }
                                                } else {
                                                  totalPrice = 0;
                                                }
                                                setState(() {});
                                              }),
                                        ),
                                        Text(coupan[0]["coupanName"]!),
                                        const Spacer(),
                                        Text(coupan[0]["price"]!.toString())
                                      ],
                                    ),
                                  ],
                                )
                              : const SizedBox(
                                  height: 0,
                                  width: 0,
                                ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Divider(
                                thickness: 2,
                              ),
                              Text(AppLocalizations.of(context)!.coins,
                                  // "Coins",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(fontWeight: FontWeight.bold)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Checkbox(
                                        value: coinsSelected,
                                        onChanged: (value) {
                                          coinsSelected = value!;
                                          if (totalPrice > coins) {
                                            if (coinsSelected) {
                                              totalPrice = totalPrice - coins;
                                              coins = 0;
                                            } else {
                                              totalPrice = totalPrice + coins;
                                            }
                                          } else {
                                            coins = coins - totalPrice.toInt();
                                            totalPrice = 0;
                                          }
                                          setState(() {});
                                        }),
                                  ),
                                  Text(
                                      // "Coins"
                                      AppLocalizations.of(context)!.coins),
                                  const Spacer(),
                                  Text(coins.toString())
                                ],
                              ),
                            ],
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10),
                            child: Row(
                              children: [
                                Text(AppLocalizations.of(context)!.total),
                                const Spacer(),
                                Text(
                                    "${AppLocalizations.of(context)!.amount}: ${totalPrice.toInt()}")
                              ],
                            ),
                          ),
                          const Divider(
                            thickness: 2,
                          ),
                        ],
                      ),
                    ),
                    Step(
                      isActive: _currentStep >= 2,
                      title: Text(
                        "Done",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      content: Center(
                        child: Column(
                          children: [
                            Container(
                              height: 280,
                              width: 3100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(22)),
                              child: Image.network(
                                "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Forder%20Placed.png?alt=media&token=0e1bb3c3-1922-4a9f-897b-5e15814d98a3",
                                fit: BoxFit.fill,
                                loadingBuilder: (BuildContext context,
                                    Widget child,
                                    ImageChunkEvent? loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
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
                            Text(
                              AppLocalizations.of(context)!.orderPlaced,
                              // "Order Successfully Placed",
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
      ),
    );
  }
}
