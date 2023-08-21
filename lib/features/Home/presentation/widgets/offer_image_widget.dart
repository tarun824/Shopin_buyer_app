import 'dart:async';

import 'package:buyer/l10n/local_provider.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OfferImageWidget extends StatefulWidget {
  @override
  State<OfferImageWidget> createState() => _OfferImageWidgetState();
}

class _OfferImageWidgetState extends State<OfferImageWidget> {
  final _verticalleftPadding = Constants.verticalleftPadding;

  List imageOffer = [];
  bool _isLoading = true;
  String selectedLanguage = "english";

  Future fetch() async {
    print("came to fetch englishenglishenglishenglishenglish");

    final forId = FirebaseFirestore.instance.collection('/offers/');
    QuerySnapshot querySnapshot = await forId.get();
    final broref = forId.snapshots(); //geting all the docs snapshorts
    broref.listen((event) async {
      //just listening so that will update on change in database
      event.docs.forEach((element) {
        print(element.data());

        element.data().forEach((key, value) {
          print("$key is $value");
          if (selectedLanguage == "kannada") {
            if (key == 'kannadaOffer') {
              imageOffer = value;
              _isLoading = false;
              if (mounted) setState(() {});
            }
          } else {
            if (key == 'englishOffer') {
              imageOffer = value;
              _isLoading = false;
              if (mounted) setState(() {});
            }
          }
        });
      });
    });
  }

  @override
  void initState() {
    super.initState();
    final language = Provider.of<LocalProvider>(context, listen: false);
    selectedLanguage = language.findLanguage();

    fetch();
  }

  @override
  Widget build(BuildContext context) {
    print("came to build");
    return SizedBox(
      height: 180,
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: imageOffer.length,
              itemBuilder: (context, index) {
                return Card(
                    margin: _verticalleftPadding,
                    elevation: 4,
                    child: Container(
                      height: 180,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(22)),
                      child: Image.network(
                        imageOffer[index],
                        fit: BoxFit.fill,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    ));
              }),
    );
    ;
  }
}
