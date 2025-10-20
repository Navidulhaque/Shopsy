import '../repositories/cart_storage.dart';

class ClearCart {
  final ICartStorage _storage;
  const ClearCart(this._storage);

  Future<void> call() => _storage.clear();
}