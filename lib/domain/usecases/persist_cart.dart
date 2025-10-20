import '../../models/cart_item.dart';
import '../repositories/cart_storage.dart';

class PersistCart {
  final ICartStorage _storage;
  const PersistCart(this._storage);

  Future<void> call(Map<String, CartItem> items) async {
    final Map<String, int> quantities = {
      for (final entry in items.entries) entry.key: entry.value.quantity,
    };
    await _storage.writeQuantities(quantities);
  }
}