abstract class ICartStorage {
  Future<Map<String, int>> readQuantities();
  Future<void> writeQuantities(Map<String, int> quantities);
  Future<void> clear();
}