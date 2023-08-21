import 'package:buyer/domain/entities/product_entities.dart';
import 'package:buyer/domain/repository/product_repository.dart';

class GetProductsUseCase {
  final ProductRepository _productRepository;

  GetProductsUseCase(this._productRepository);

  Future<List<ProductEntities>> execute() async {
    try {
      // Fetch product data from the repository
      final products = await _productRepository.getProducts();
      return products;
    } catch (e) {
      // Handleing  errors or exceptions
      throw Exception('Failed to get products: $e');
    }
  }
}
