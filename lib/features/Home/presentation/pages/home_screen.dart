import 'package:buyer/features/Home/presentation/state_management/user_data_provider.dart';
import 'package:buyer/features/Home/presentation/widgets/category_widget.dart';
import 'package:buyer/features/Home/presentation/widgets/offer_widget.dart';
import 'package:buyer/features/Home/presentation/widgets/recommend_products_widget.dart';
import 'package:buyer/features/Home/presentation/widgets/offer_image_widget.dart';
import 'package:buyer/utilities/app_bar/main_appbar.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:buyer/utilities/drawer/side_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:buyer/features/Home/presentation/state_management/offer_image_url_provider.dart';
import 'package:buyer/responsive_helper/responsive_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.argument});
  //here we will get userId
  String argument;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _sidePadding = Constants.sidePadding;
  final _sideTopPadding = Constants.sideTopPadding;

  TextEditingController searchTextController = TextEditingController();
  String searchText = "";
  int currentIndex = 0;
  dynamic _userId = "";

  bool _isloading = false;
  Map<String, dynamic> decodedData = {};
  Future fetch() async {
    if (mounted) setState(() {});
    _userId = widget.argument;
    if (_userId != null || _userId != "null") {
      final forId = FirebaseFirestore.instance
          .collection('/buyers/')
          .where("userId", isEqualTo: _userId);
      QuerySnapshot querySnapshot = await forId.get();
      final broref = forId.snapshots(); //geting all the docs snapshorts
      broref.listen((event) async {
        // just listening so that will update on change in database
        event.docs.forEach((element) {});
        event.docs.forEach((element) {
          // getting all the docs in single
          //we get all the field printed here

          final Map<String, dynamic> data = element.data();

          decodedData = data;
          _isloading = false;
          if (mounted) setState(() {});
        });
      });
    } else {
      _isloading = false;
      if (mounted) setState(() {});
    }
  }

  @override
  void initState() {
    fetch();
  }

  @override
  Widget build(BuildContext context) {
    final userDataProvider =
        Provider.of<UserDataProvider>(context, listen: true);

    final userDataInfo = userDataProvider.userData;
    final offerImageUrlProvider =
        Provider.of<OfferImageUrlProvider>(context, listen: true);

    if (widget.argument == null) {}

    final _mainOfferImages = Provider.of<OfferImageUrlProvider>(context);
    final _mainOfferImage = _mainOfferImages.mainOfferImageUrl;
    @override
    void dispose() {
      super.dispose();
      searchTextController.dispose();
    }

    final mediaQueryWidth = MediaQuery.of(context).size.width;
    final bool isMobile = mediaQueryWidth < 1200;
    return SafeArea(
        child: Scaffold(
      drawer: isMobile ? const Drawer(child: SideDrawer()) : null,
      appBar: MainAppbar().appbar(context),
      body: _isloading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SafeArea(
              child: SingleChildScrollView(
                child: ResponsiveWidget(
                  mobile: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchBar(context),
                      CategoryWidget(),
                      const OfferWidget(),
                      OfferImageWidget(),
                      const RecommendProductsWidget(),
                    ],
                  ),
                  tab: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SearchBar(context),
                      CategoryWidget(),
                      const OfferWidget(),
                      OfferImageWidget(),
                      const RecommendProductsWidget(),
                    ],
                  ),
                  destop: Row(
                    children: [
                      SizedBox(
                          width: mediaQueryWidth * 0.2,
                          child: const SideDrawer()),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SearchBar(context),
                          // Text(widget.argument.toString()),

                          CategoryWidget(),
                          // DataText(context, "data"),
                          const OfferWidget(),

                          OfferImageWidget(),
                          const RecommendProductsWidget(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
    ));
  }

  Padding SearchBar(BuildContext context) {
    return Padding(
      padding: _sideTopPadding,
      child: TextField(
        controller: searchTextController,
        onChanged: (value) {
          searchText = value;
          if (mounted) setState(() {});
        },
        decoration: InputDecoration(
            focusColor: Theme.of(context).colorScheme.primary,
            hintText: AppLocalizations.of(context)!.mobileKitchenItemSareeBook,
            label: Text(
              AppLocalizations.of(context)!.search,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 3, vertical: 3),
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
    );
  }

  Padding DataText(BuildContext context, String data) {
    return Padding(
      padding: _sidePadding,
      child: Text(
        data,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
