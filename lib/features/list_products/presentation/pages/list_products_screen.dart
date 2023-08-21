import 'package:buyer/features/list_products/data/models/list_products_model.dart';
import 'package:buyer/features/splash/data/services/try_auto_login_service.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/app_bar/normal_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ListProductsScreen extends StatefulWidget {
  final argument;
  ListProductsScreen({super.key, required this.argument});
  //here we get navigate and argument

  @override
  State<ListProductsScreen> createState() => _ListProductsScreenState();
}

class _ListProductsScreenState extends State<ListProductsScreen> {
  final sideTopPadding = Constants.sideTopPadding;
  final sidePadding = Constants.sidePadding;

  TextEditingController searchTextController = TextEditingController();
  String searchText = "";
  dynamic _userId = "";
  bool _isLoading = true;
  bool goToSetFavarate = false;
  bool loadProducts = true;
  String selectedLanguage = "english";

  List<ListProductsModel> products = [];
  bool dumyBool = false;
  Future fetchCategory() async {
    products = [];
    String argumentNavigate = widget.argument["navigate"].toString();
    String argumentCollection = widget.argument["argument"].toString();

    final forId = FirebaseFirestore.instance.collection(argumentCollection);
    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) async {
      //just listening so that will update on change in database
      event.docs.forEach((element) {
        element.data().forEach((key, value) async {
          _userId = await TryAutoLogin().tryAutoLogin();

          final usersFavarateCollection = [];
          if (_userId != null) {
            final usersfavarateDbInstance =
                FirebaseFirestore.instance.collection("/buyers").doc(_userId);
            final broref = usersfavarateDbInstance
                .snapshots(); //geting all the docs snapshorts
            broref.listen((event) async {
              //just listening so that will update on change in database

              event.data()!.forEach((key1, userFavarateValue) {
                if (key1 == 'isFavorite') {
                  for (int i = 0; i < userFavarateValue.length; i++) {
                    final zzz = userFavarateValue[i];
                    final vvv = zzz["productId"];
                    usersFavarateCollection.add(vvv);
                  }
                  goToSetFavarate = true;
                  if (goToSetFavarate && loadProducts) {
                    if (key == 'productEntities') {
                      final zzz = value;
                      bool forUpdatingFavarateModel = false;
                      if (usersFavarateCollection.contains(zzz["productId"])) {
                        forUpdatingFavarateModel = true;
                      }
                      final vvv = ListProductsModel(
                        productId: zzz["productId"],
                        title: zzz["title"][selectedLanguage],
                        price: zzz["price"],
                        discount: zzz["discount"],
                        review: zzz["review"],
                        cata: zzz["cata"],
                        imgUrl: zzz["imgUrl"],
                        isFavarate: forUpdatingFavarateModel,
                      );

                      products.add(vvv);
                      _isLoading = false;
                      if (mounted) setState(() {});
                    } else {}
                  }
                } else {}
              });
            });
          } else {
            if (key == 'productEntities') {
              final zzz = value;
              bool forUpdatingFavarateModel = false;
              if (usersFavarateCollection.contains(zzz["productId"])) {
                forUpdatingFavarateModel = true;
              }
              final vvv = ListProductsModel(
                productId: zzz["productId"],
                title: zzz["title"]["english"],
                price: zzz["price"],
                discount: zzz["discount"],
                review: zzz["review"],
                cata: zzz["cata"],
                imgUrl: zzz["imgUrl"],
                isFavarate: forUpdatingFavarateModel,
              );

              products.add(vvv);

              _isLoading = false;
              if (mounted) setState(() {});
            } else {}
          }
        });
      });
    });
  }

  Future AddToFavarate(itemId, argumentproductCate) async {
    loadProducts = false;
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

  Future RemoveFavarate(itemId, argumentproductCate) async {
    loadProducts = false;
    final forId = FirebaseFirestore.instance.collection("/buyers").doc(_userId);

    final uploadJson = {
      "productId": itemId,
      "cata": argumentproductCate,
    };
    await forId.update({
      "isFavorite": FieldValue.arrayRemove([uploadJson])
    });
    _isLoading = false;
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();

    fetchCategory();
  }

  @override
  void dispose() {
    super.dispose();
    searchTextController.dispose();
  }

  Widget build(BuildContext context) {
    final _mediaQueryHeight = MediaQuery.of(context).size.height;
    final _mediaQueryWidth = MediaQuery.of(context).size.width;
    final _heightOfBox = _mediaQueryHeight * 0.1;
    final _widthOfBox = _mediaQueryWidth * 0.35;
    final _itemCountNumber = products.length;
    final _crossAxisCount = 2;
    final _sizeForSizedBox =
        ((((_itemCountNumber / _crossAxisCount) * 2) + 0.8) * _heightOfBox);

    return SafeArea(
      child: Scaffold(
        appBar: NormalAppbar().appbar(context, ""),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: sideTopPadding,
                  child: Column(
                    children: [
                      Padding(
                        padding: sideTopPadding,
                        child: TextField(
                          controller: searchTextController,
                          onChanged: (value) {
                            searchText = value;
                            if (mounted) setState(() {});
                          },
                          decoration: InputDecoration(
                              focusColor: Theme.of(context).colorScheme.primary,
                              label: const Text('Search'),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 3, vertical: 3),
                              enabledBorder: const OutlineInputBorder(
                                borderRadius: Constants.textFieldBorderRadius,
                              ),
                              prefixIcon: const Icon(Icons.search_rounded),
                              suffixIcon: !(searchText == "")
                                  ? IconButton(
                                      splashRadius: 18,
                                      onPressed: () {
                                        searchTextController.clear();
                                      },
                                      icon: const Icon(Icons.cancel_rounded))
                                  : const SizedBox()),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Tooltip(
                            message: "Filter by Condition",
                            child: InkWell(
                              splashColor: Theme.of(context).primaryColor,
                              child: SizedBox(
                                  height: _mediaQueryHeight * 0.07,
                                  width: _mediaQueryWidth / 2.2,
                                  child: Center(
                                      child: Text(
                                          AppLocalizations.of(context)!.filter
                                          // "Filter"
                                          ))),
                              onTap: () {},
                            ),
                          ),
                          Tooltip(
                            message: "Sort Products",
                            child: InkWell(
                              splashColor: Theme.of(context).primaryColor,
                              child: SizedBox(
                                  height: _mediaQueryHeight * 0.07,
                                  width: _mediaQueryWidth / 2.2,
                                  child: Center(
                                      child: Text(
                                    AppLocalizations.of(context)!.sort,
                                    // "Sort"
                                  ))),
                              onTap: () {},
                            ),
                          ),
                        ],
                      ),
                      const Divider(thickness: 2),
                      SizedBox(
                        height: _sizeForSizedBox,
                        child: GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _itemCountNumber,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, "/productDetailsScreen",
                                      arguments: {
                                        "productId": products[index].productId,
                                        "productCate": products[index].cata,
                                      });
                                },
                                child: SizedBox(
                                    height: _heightOfBox,
                                    width: _widthOfBox,
                                    child: Card(
                                        elevation: 4,
                                        child: LayoutBuilder(
                                            builder: (context, constraints) {
                                          return Stack(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    height:
                                                        constraints.maxHeight *
                                                            0.6,
                                                    width: constraints.maxWidth,
                                                    child: Image.network(
                                                      products[index].imgUrl[0],
                                                      fit: BoxFit.fill,
                                                      loadingBuilder: (BuildContext
                                                              context,
                                                          Widget child,
                                                          ImageChunkEvent?
                                                              loadingProgress) {
                                                        if (loadingProgress ==
                                                            null) return child;
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
                                                  Expanded(
                                                    child: Text(
                                                      products[index].title,
                                                      // "Product Name with...",
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 8),
                                                        child: ColoredBox(
                                                          color: Colors
                                                              .green.shade400,
                                                          child: const Text(
                                                            "  3.7 ★ ",
                                                            //logic of this should be written
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                      Text(
                                                        "(${(products[index].review["1"] + products[index].review["2"] + products[index].review["3"] + products[index].review["4"] + products[index].review["5"])})",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption,
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text(
                                                          "${((products[index].discount["admin"] as int) + (products[index].discount["seller"] as int))} %off",
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .bodyLarge!
                                                              .copyWith(
                                                                  color: Colors
                                                                      .green
                                                                      .shade600)),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        "\₹ ${products[index].price.toStringAsFixed(0)}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleLarge,
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              _userId != null
                                                  ? Positioned(
                                                      right: 2,
                                                      top: 2,
                                                      child: IconButton(
                                                        alignment:
                                                            Alignment.topRight,
                                                        onPressed: () {
                                                          _isLoading = true;
                                                          if (mounted)
                                                            setState(() {});
                                                          products[index]
                                                                  .isFavarate =
                                                              !products[index]
                                                                  .isFavarate;
                                                          products[index]
                                                                  .isFavarate
                                                              ? AddToFavarate(
                                                                  products[
                                                                          index]
                                                                      .productId,
                                                                  products[
                                                                          index]
                                                                      .cata)
                                                              : RemoveFavarate(
                                                                  products[
                                                                          index]
                                                                      .productId,
                                                                  products[
                                                                          index]
                                                                      .cata);
                                                        },
                                                        icon: products[index]
                                                                .isFavarate
                                                            ? Icon(
                                                                Icons
                                                                    .favorite_rounded,
                                                                color: Theme.of(
                                                                        context)
                                                                    .primaryColor,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .favorite_border,
                                                              ),
                                                      ))
                                                  : const SizedBox(
                                                      height: 0,
                                                      width: 0,
                                                    )
                                            ],
                                          );
                                        }))),
                              );
                            }),
                      ),
                      Padding(
                        padding: sidePadding,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Related products",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text("View All"),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: SizedBox(
                          height: 200,
                          width: _mediaQueryWidth,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: 3,
                            // products["imgUrl"].length ,
                            itemBuilder: (context, index) {
                              return Container(
                                height: 200,
                                width: 200,
                                padding: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(22)),
                                child: Image.network(
                                  "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fcategory%2F50%25%20off.jpg?alt=media&token=c5d9e31a-6e48-4191-9460-ceadf2efd9eb",
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
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
