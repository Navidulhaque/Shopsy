import 'package:flutter/foundation.dart';

import '../domain/usecases/get_products.dart';
import '../domain/usecases/search_products.dart';
import '../models/product.dart';

class ProductListViewModel extends ChangeNotifier {
  final GetProducts _getProducts;
  final SearchProducts _searchProducts;
  ProductListViewModel(this._getProducts, this._searchProducts);

  List<Product> _products = <Product>[];
  List<Product> _filtered = <Product>[];
  bool _loading = false;
  String? _error;
  String _query = '';

  List<Product> get products => _filtered;
  bool get isLoading => _loading;
  String? get error => _error;
  String get query => _query;

  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      _products = await _getProducts();
      _filtered = _products;
    } catch (e) {
      _error = 'Failed to load products';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  void search(String q) {
    _query = q;
    _filtered = _searchProducts(_products, _query);
    notifyListeners();
  }
}