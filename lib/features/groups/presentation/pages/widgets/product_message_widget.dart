import 'package:flutter/material.dart';

class ProductMessageWidget extends StatelessWidget {
  //  ProductMessageWidget({super.key});
  ProductMessageWidget({
    required this.message,
    required this.addedBy,
    required this.heightOfBox,
    required this.imageUrl,
    required this.productTitle,
    required this.newPrice,
    required this.totalAmount,
  });
  String message;

  String addedBy;
  String imageUrl;
  String productTitle;

  int newPrice;
  int totalAmount;

  double heightOfBox;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: heightOfBox - 60,
      child: LayoutBuilder(builder: (context, constraints) {
        return Card(
          elevation: 4,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2),
                child: SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: Text(
                      "$message $addedBy",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
              ),
              Divider(
                thickness: 2,
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Container(
                      // decoration: BoxDecoration(
                      //     borderRadius:
                      //         BorderRadius.circular(22)),
                      // color: Theme.of(context).colorScheme.primaryContainer,
                      height: constraints.maxHeight * 0.5,
                      width: constraints.maxWidth * 0.3,
                      child:
                          //  Text(imageUrl)
                          Image.network(
                        imageUrl,
                        fit: BoxFit.contain,
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
                      // Image.network(
                      //     "https://firebasestorage.googleapis.com/v0/b/esp32-3413a.appspot.com/o/airtel%20flutter.webp?alt=media&token=461b7702-33c3-4d92-8f66-3f1b10d69c58"),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          width: constraints.maxWidth * 0.42,
                          child: Text(
                            productTitle,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.start,
                      //   children: [
                      //     ColoredBox(
                      //       color: Colors.green,
                      //       child: Text(
                      //         " ${ratingScore.toString()} star ",
                      //         style: const TextStyle(color: Colors.white),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 8,
                      //     ),
                      //     Text(
                      //       "(${ratedNumber.toString()})",
                      //       style: Theme.of(context).textTheme.caption,
                      //     ),
                      //   ],
                      // ),
                      // Spacer(),

                      SizedBox(
                        width: constraints.maxWidth * 0.6,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(right: 5.0),
                                //   child: Text(
                                //     cancelPrice.toString(),
                                //     style: Theme.of(context)
                                //         .textTheme
                                //         .bodyMedium!
                                //         .copyWith(
                                //             decoration:
                                //                 TextDecoration.lineThrough),
                                //   ),
                                // ),
                                // Text(
                                //   "$offerPresentage % off",
                                //   style: Theme.of(context).textTheme.bodyMedium,
                                // ),
                                // Spacer(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8.0, right: 8),
                                  child: Text("\₹$newPrice",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(fontSize: 20)),
                                ),
                              ],
                            ),
                            // Text(
                            //   "selected=data,data,data",
                            //   style: Theme.of(context).textTheme.bodyMedium,
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 2),
                child: SizedBox(
                    width: constraints.maxWidth * 0.9,
                    child: Text(
                      "Total amount: $totalAmount",
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
