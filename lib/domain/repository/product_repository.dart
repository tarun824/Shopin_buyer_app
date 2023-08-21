import 'package:buyer/domain/entities/product_entities.dart';

abstract class ProductRepository {
  Future<List<ProductEntities>> getProducts();
}
