import 'package:buyer/features/Home/data/models/category_widget_model.dart';
import 'package:buyer/utilities/constants.dart';
import 'package:flutter/material.dart';

final verticalleftPadding = Constants.verticalleftPadding;

class CategoryWidget extends StatelessWidget {
  List<CategoryWidgetModel> category = [
    CategoryWidgetModel(
        imgUrl: "assets/images/Home and Kitchen.jpg",
        title: "Home and Kitchen"),
    CategoryWidgetModel(
        imgUrl: "assets/images/Mobiles and Laptops.jpg",
        title: "Mobiles and Laptops"),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.14,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: category.length,
          itemBuilder: (context, index) {
            return LayoutBuilder(builder: (context, constraints) {
              return Padding(
                padding: verticalleftPadding.copyWith(top: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                        child: Container(
                            height: 220,
                            width: 250,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22)),
                            child: ClipOval(
                              child: Image.asset(
                                category[index].imgUrl,
                                fit: BoxFit.fill,
                              ),
                            ))),
                    SizedBox(
                      width: 99,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 3.0),
                        child: Text(
                          category[index].title,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    )
                  ],
                ),
              );
            });
          }),
    );
  }
}
