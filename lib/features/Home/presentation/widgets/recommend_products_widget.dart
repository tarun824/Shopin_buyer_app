import 'package:buyer/features/favarate/data/models/favarate_model.dart';
import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RecommendProductsWidget extends StatefulWidget {
  const RecommendProductsWidget({super.key});

  @override
  State<RecommendProductsWidget> createState() =>
      RRecommendProductsWidgetState();
}

class RRecommendProductsWidgetState extends State<RecommendProductsWidget> {
  final sideTopPadding = Constants.sideTopPadding;
  String selectedLanguage = "english";

  List<FavarateModel> favarateProducts = [];
  List<FavarateModel> favarateProductsEnglish = [
    FavarateModel(
        productId: "3AWTKNV1FPuZyPWFYek0",
        title: "SAPI'S Aluminium Grocery Container",
        imgUrl: [
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Faluminium%2Fjars%20aluminium.webp?alt=media&token=3234fc1a-1a46-4b70-9deb-18ba85c2053c",
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Faluminium%2Fjars%20aluminium.webp?alt=media&token=3234fc1a-1a46-4b70-9deb-18ba85c2053c"
        ],
        price: 150,
        discount: {"admin": 5, "seller": 12},
        review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
        cata: "/products/homeAndKitchen/kitchenAndApplication/jars/aluminium",
        isFavarate: false),
    FavarateModel(
        productId: "XlTSceMdmZBQatjuIgLu",
        title:
            "Hammered Copper Plated Jar/Copper Container for dry fruits/Decorative",
        imgUrl: [
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Fcopper%2Fjars%20copper.webp?alt=media&token=9fcd5c81-b0f5-4d77-809c-78e1daba2f09",
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Fcopper%2Fjars%20copper.webp?alt=media&token=9fcd5c81-b0f5-4d77-809c-78e1daba2f09"
        ],
        price: 199,
        discount: {"admin": 15, "seller": 2},
        review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
        cata: "/products/homeAndKitchen/kitchenAndApplication/jars/copper",
        isFavarate: false),
  ];
  List<FavarateModel> favarateProductsKannada = [
    FavarateModel(
        productId: "3AWTKNV1FPuZyPWFYek0",
        title: "SAPI's ಅಲ್ಯೂಮಿನಿ  ಯಂ  ದಿನಸಿ ಕಂಟೈನರ್",
        imgUrl: [
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Faluminium%2Fjars%20aluminium.webp?alt=media&token=3234fc1a-1a46-4b70-9deb-18ba85c2053c",
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Faluminium%2Fjars%20aluminium.webp?alt=media&token=3234fc1a-1a46-4b70-9deb-18ba85c2053c"
        ],
        price: 150,
        discount: {"admin": 5, "seller": 12},
        review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
        cata: "/products/homeAndKitchen/kitchenAndApplication/jars/aluminium",
        isFavarate: false),
    FavarateModel(
        productId: "XlTSceMdmZBQatjuIgLu",
        title:
            "ಒಣ ಹಣ್ಣುಗಳಿಗಾಗಿ ಸುತ್ತಿಗೆಯಿಂದ ತಾಮ್ರದ ಲೇಪಿತ ಜಾರ್/ತಾಮ್ರದ ಕಂಟೇನರ್ / ಅಲಂಕಾರಿಕ ಬಡಿಸುವ ಬೌಲ್",
        imgUrl: [
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Fcopper%2Fjars%20copper.webp?alt=media&token=9fcd5c81-b0f5-4d77-809c-78e1daba2f09",
          "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/admin%2Fproducts%2Fhome_and_kitchen%2Fkitchen_and_application%2Fjars%2Fcopper%2Fjars%20copper.webp?alt=media&token=9fcd5c81-b0f5-4d77-809c-78e1daba2f09"
        ],
        price: 199,
        discount: {"admin": 15, "seller": 2},
        review: {"5": 5, "4": 2, "3": 6, "2": 2, "1": 2},
        cata: "/products/homeAndKitchen/kitchenAndApplication/jars/copper",
        isFavarate: false),
  ];
  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();
    if (selectedLanguage == "kannada") {
      favarateProducts = favarateProductsKannada;
    } else {
      favarateProducts = favarateProductsEnglish;
    }
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
        ((((_itemCountNumber / _crossAxisCount) * 2) + 0.5) * _heightOfBox);
    return Padding(
      padding: sideTopPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recommend Products",
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const Divider(thickness: 2),
          SizedBox(
            height: _sizeForSizedBox,
            child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _itemCountNumber,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/productDetailsScreen",
                          arguments: {
                            "productId": favarateProducts[index].productId,
                            "productCate": favarateProducts[index].cata,
                          });
                    },
                    child: SizedBox(
                        height: _heightOfBox,
                        width: _widthOfBox,
                        child: Card(
                            elevation: 4,
                            child:
                                LayoutBuilder(builder: (context, constraints) {
                              return Stack(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: constraints.maxWidth,
                                        child: Image.network(
                                          favarateProducts[index].imgUrl[0],
                                          fit: BoxFit.fill,
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
                                      Expanded(
                                        child: Text(
                                          favarateProducts[index].title,
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8),
                                            child: ColoredBox(
                                              color: Colors.green.shade400,
                                              child: const Text(
                                                "  3.7 ★ ",
                                                //logic of this should be written
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                            ),
                                          ),
                                          Text(
                                            "(${(favarateProducts[index].review["1"] + favarateProducts[index].review["2"] + favarateProducts[index].review["3"] + favarateProducts[index].review["4"] + favarateProducts[index].review["5"])})",
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              "${((favarateProducts[index].discount["admin"] as int) + (favarateProducts[index].discount["seller"] as int))} %off",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors
                                                          .green.shade600)),
                                          const SizedBox(
                                            width: 5,
                                          ),
                                          Text(
                                            "\₹ ${favarateProducts[index].price.toStringAsFixed(0)}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            }))),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
