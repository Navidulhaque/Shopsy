import '../../models/cart_item.dart';
import '../../models/product.dart';
import '../repositories/cart_storage.dart';
import '../repositories/product_repository.dart';

class HydrateCart {
  final ICartStorage _storage;
  final IProductRepository _products;

  const HydrateCart(this._storage, this._products);

  Future<Map<String, CartItem>> call() async {
    final quantities = await _storage.readQuantities();
    if (quantities.isEmpty) return <String, CartItem>{};

    final allProducts = await _products.loadProducts();
    final Map<String, Product> idToProduct = {
      for (final p in allProducts) p.id: p,
    };

    return Map.fromEntries(
      quantities.entries
          .where((e) => idToProduct.containsKey(e.key))
          .map((e) => MapEntry(
                e.key,
                CartItem(product: idToProduct[e.key]!, quantity: e.value),
              )),
    );
  }
}