class CartModel {
  final String productId;
  final String title;
  final List imgUrl;
  final int price;

  final Map<String, dynamic> discount;
  final Map<String, dynamic> review;

  final String cata;
  int numberOfItems;
  final List<dynamic> parameterSelected;
  final String sellerId;

  CartModel({
    required this.productId,
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.discount,
    required this.review,
    required this.cata,
    required this.numberOfItems,
    required this.parameterSelected,
    required this.sellerId,
  });
}
