import 'package:buyer/features/cart/data/models/cart_model.dart';

class GroupCartModel {
  final List<CartModel> cartItems;
  final String userId;
  final String userName;
  GroupCartModel({
    required this.cartItems,
    required this.userId,
    required this.userName,
  });
}
