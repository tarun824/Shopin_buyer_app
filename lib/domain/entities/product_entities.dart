import 'package:equatable/equatable.dart';

class ProductFinalEntities {
  final String productId;
  final Map<String, ProductEntities> productEntities;

  ProductFinalEntities({
    required this.productId,
    required this.productEntities,
  });
}

class ProductEntities {
  final String title;
  final String description;
  final int price;
  final int qty;
  final Map<String, int> discount;
  final String sellerName;
  final List<forPara> para;
  // final Map<String, Map<String, Map<String, int>>> para;
  final Map<String, int> review;
  final List<Map<String, dynamic>> reviewText;

  final List<QueAndAns> queAndAns;
  final String cata;
  final List<dynamic> imgUrl;
  //want to change to date/time  **we donot want this here
  final int coin;
  final Map<String, dynamic>
      expirable; //first will be isExpirable :bool ,yes:"date"
  final Map<String, int> dimenstion; //**must be in CM
  ProductEntities({
    required this.title,
    required this.description,
    required this.price,
    required this.qty,
    required this.discount,
    required this.sellerName,
    required this.para,
    required this.review,
    required this.reviewText,
    required this.queAndAns,
    required this.cata,
    required this.imgUrl,
    required this.coin,
    required this.expirable,
    required this.dimenstion,
  });
}

class forPara {
  final String paraTitle;
  final List<ParaInside> paraInside;
  forPara({
    required this.paraInside,
    required this.paraTitle,
  });
}

class ParaInside {
  final String cate;
  final int price;
  final int qty;
  ParaInside({
    required this.cate,
    required this.price,
    required this.qty,
  });
}

class QueAndAns {
  final String question;
  final String answer;
  QueAndAns({
    required this.question,
    required this.answer,
  });
}
