import 'package:flutter/foundation.dart';

import '../domain/usecases/clear_cart.dart';
import '../domain/usecases/hydrate_cart.dart';
import '../domain/usecases/persist_cart.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class CartViewModel extends ChangeNotifier {
  final HydrateCart _hydrateCart;
  final PersistCart _persistCart;
  final ClearCart _clearCart;
  final Map<String, CartItem> _items = <String, CartItem>{};

  CartViewModel(this._hydrateCart, this._persistCart, this._clearCart);

  Map<String, CartItem> get items => Map.unmodifiable(_items);

  int get totalItems =>
      _items.values.fold(0, (sum, item) => sum + item.quantity);
  double get totalPrice => _items.values
      .fold(0.0, (sum, item) => sum + (item.product.price * item.quantity));

  Future<void> hydrate() async {
    final hydrated = await _hydrateCart();
    _items
      ..clear()
      ..addAll(hydrated);
    notifyListeners();
  }

  Future<void> add(Product product) async {
    final CartItem? existing = _items[product.id];
    final int nextQty = (existing?.quantity ?? 0) + 1;
    _items[product.id] = CartItem(product: product, quantity: nextQty);
    notifyListeners();
    await _persistCart(_items);
  }

  Future<void> removeOne(Product product) async {
    final CartItem? existing = _items[product.id];
    if (existing == null) return;
    if (existing.quantity <= 1) {
      _items.remove(product.id);
    } else {
      _items[product.id] = existing.copyWith(quantity: existing.quantity - 1);
    }
    notifyListeners();
    await _persistCart(_items);
  }

  Future<void> removeAll(Product product) async {
    _items.remove(product.id);
    notifyListeners();
    await _persistCart(_items);
  }

  Future<void> clear() async {
    _items.clear();
    notifyListeners();
    await _clearCart();
  }
}