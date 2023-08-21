import 'package:buyer/features/cart/data/models/cart_model.dart';

class OrderModel {
  final String orderId;
  final List<CartModel> cartProducts;
  final String userId;
  final String name;

  final double totalPrice;
  final Address address;
  final int phNumber;
  final String paymentMode;

  final List<dynamic> status;
  OrderModel({
    required this.orderId,
    required this.cartProducts,
    required this.totalPrice,
    required this.userId,
    required this.name,
    required this.address,
    required this.phNumber,
    required this.paymentMode,
    required this.status,
  });
}

class Address {
  final String sideAddress;
  final String city;
  final String country;
  final String state;
  final int pinNumber;
  Address({
    required this.sideAddress,
    required this.city,
    required this.country,
    required this.state,
    required this.pinNumber,
  });
}
