import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../domain/repositories/cart_storage.dart';

class CartStorageImpl implements ICartStorage {
  static const String _key = 'cart_v1';

  @override
  Future<Map<String, int>> readQuantities() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return <String, int>{};
    final Map<String, dynamic> map = jsonDecode(raw) as Map<String, dynamic>;
    return map.map((String k, dynamic v) => MapEntry(k, (v as num).toInt()));
  }

  @override
  Future<void> writeQuantities(Map<String, int> quantities) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String raw = jsonEncode(quantities);
    await prefs.setString(_key, raw);
  }

  @override
  Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}