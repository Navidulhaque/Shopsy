import '../../models/product.dart';

class SearchProducts {
  const SearchProducts();

  List<Product> call(List<Product> products, String query) {
    final q = query.trim();
    if (q.isEmpty) return products;
    final lower = q.toLowerCase();
    return products.where((p) {
      return p.title.toLowerCase().contains(lower) ||
          p.type.toLowerCase().contains(lower);
    }).toList();
  }
}