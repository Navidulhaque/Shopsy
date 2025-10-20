import '../../models/product.dart';

abstract class IProductRepository {
  Future<List<Product>> loadProducts();
  Future<Product?> findById(String id);
}