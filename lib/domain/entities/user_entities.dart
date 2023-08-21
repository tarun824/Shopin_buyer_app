import 'package:equatable/equatable.dart';

class UserEntities extends Equatable {
  final String profileurl;
  final String userId;
  final String name;
  final int phNumber;
  final String emailId;
  final String password;
  final List isFavorite;
  final List<FavoriteDetails> isFavoriteDetails;
  final List<FavoriteDetails> cart;
  final List<List<OrderProduct>> orderHistory;
  final Map<String, int> coupan;
  final List<ReturnProduct> returnProducts;
  final int coins;
  final String status;

  UserEntities({
    required this.profileurl,
    required this.userId,
    required this.name,
    required this.phNumber,
    required this.emailId,
    required this.password,
    required this.isFavorite,
    required this.isFavoriteDetails,
    required this.cart,
    required this.orderHistory,
    required this.coupan,
    required this.returnProducts,
    required this.coins,
    required this.status,
  });
  @override
  List<Object?> get props {
    return [
      profileurl,
      userId,
      name,
      phNumber,
      emailId,
      password,
      isFavorite,
      isFavoriteDetails,
      cart,
      orderHistory,
      coupan,
      returnProducts,
      coins,
      status,
    ];
  }
}

class FavoriteDetails {
  final String productId;
  final List category;
  FavoriteDetails({
    required this.productId,
    required this.category,
  });
}

class OrderProduct {
  final String productId;
  final List category;
  final int quantityBooked;
  final int price;
  final Map<String, String> selectedPara;

  OrderProduct({
    required this.productId,
    required this.category,
    required this.quantityBooked,
    required this.selectedPara,
    required this.price,
  });
}

class ReturnProduct {
  final String returnId;
  final String productId;
  final int quantityReturned;
  final int price;
  final List<String> listCase;
  final List category;

  ReturnProduct({
    required this.returnId,
    required this.productId,
    required this.quantityReturned,
    required this.price,
    required this.listCase,
    required this.category,
  });
}
