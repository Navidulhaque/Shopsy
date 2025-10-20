import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../domain/repositories/product_repository.dart';
import '../models/product.dart';

class ProductRepositoryImpl implements IProductRepository {
  @override
  Future<List<Product>> loadProducts() async {
    final String jsonStr =
        await rootBundle.loadString('assets/data/products.json');
    final List<dynamic> list = jsonDecode(jsonStr) as List<dynamic>;
    return list
        .map((dynamic e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Product?> findById(String id) async {
    final products = await loadProducts();
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}