import '../../models/product.dart';
import '../repositories/product_repository.dart';

class GetProducts {
  final IProductRepository _repository;
  const GetProducts(this._repository);

  Future<List<Product>> call() {
    return _repository.loadProducts();
  }
}