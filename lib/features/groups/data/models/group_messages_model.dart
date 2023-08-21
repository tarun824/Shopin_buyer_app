class GroupMessageModel {
  final String message;
  final String senderId;
  final String senderName;
  final String date;
  Map<String, dynamic> productDetails;
  GroupMessageModel({
    required this.message,
    required this.senderId,
    required this.senderName,
    required this.date,
    required this.productDetails,
  });
}

//it is doen for reference not implemented because of storage
class ProductDetails {
  final String itemId;
  final String argumentproductCate;
  final bool isProduct;
  final String title;
  final String imgUrl;
  final int price;
  final int qty;
  ProductDetails({
    required this.itemId,
    required this.argumentproductCate,
    required this.isProduct,
    required this.title,
    required this.imgUrl,
    required this.price,
    required this.qty,
  });
}
