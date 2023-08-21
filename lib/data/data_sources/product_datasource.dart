// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import '/core/network/client_api.dart';
// import 'package:buyer/data/model.dart/product_model.dart';

// class ProductDataSource {
//   final ApiClient apiClient;

//   ProductDataSource(this.apiClient);

//   Future<List<ProductModel>> getProducts() async {
//     final querySnapshot = await apiClient.get('');
//     List<ProductModel> decodedData = [];

//     await querySnapshot.listen((event) {
//       event.docs.forEach((doc) {
//         Map<String, dynamic> documentData = doc.data() as Map<String, dynamic>;
//         print(documentData);
//         documentData.forEach((key, value) {
//           print('key is $key,value is ${value}');
//           // ProductProvider().products.add(
//           //     ProductModel(productId: value, title: value, description: value));
//           // decodedData.add(eachProduct);
//         });
//       });
//     });
//     print("cam to ProductDataSource ${decodedData.toString()} ");
//     return await decodedData;
// // final List<dynamic> jsonList = json.decode(response.body);
// //       final List<ProductModel> products =
// //           jsonList.map((json) => ProductModel.fromJson(json)).toList();
//     if (true) {
//       // Process the response body and return the list of products
//       // Convert the JSON response to a list of Product objects
//     } else {
//       // Handle error cases, such as non-200 response codes
//       // Throw an exception or return an empty list
//       throw Exception('Failed to fetch products');
//     }
//   }
// }
