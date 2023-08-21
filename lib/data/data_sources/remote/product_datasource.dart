// import 'package:http/http.dart' as http;
// import 'package:for_error/auth_with_secure.dart/core/network/client_api.dart';
// import 'package:for_error/auth_with_secure.dart/domain/entities/product_entities.dart';
// class ProductDataSource {
//   final ApiClient apiClient;

//   ProductDataSource(this.apiClient);

//   Future<List<Product>> getProducts() async {
//     final response = await apiClient.get('products');

//     if (response.statusCode == 200) {
//       // Process the response body and return the list of products
//       // Convert the JSON response to a list of Product objects
//       final List<dynamic> jsonList = json.decode(response.body);
//       final List<Product> products = jsonList.map((json) => Product.fromJson(json)).toList();
//       return products;
//     } else {
//       // Handle error cases, such as non-200 response codes
//       // Throw an exception or return an empty list
//       throw Exception('Failed to fetch products');
//     }
//   }
// }