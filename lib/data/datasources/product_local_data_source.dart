import 'dart:convert';

import 'package:desafio_franq/core/error/exceptions.dart';
import 'package:desafio_franq/data/models/product_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

abstract class ProductLocalDataSource {
  Future<void> cacheProducts(List<ProductModel> products);
  Future<List<ProductModel>?> getCachedProducts();

  Future<Set<int>> getFavoriteIds();
  Future<void> toggleFavorite(int productId);
}

class ProductLocalDataSourceImpl implements ProductLocalDataSource {
  static const String cacheBoxName = 'cache_box';
  static const String favoritesBoxName = 'favorites_box';
  static const String productsKey = 'products_json';
  static const String favoritesKey = 'favorite_ids';

  Future<Box> _openCacheBox() async => await Hive.openBox(cacheBoxName);
  Future<Box> _openFavBox() async => await Hive.openBox(favoritesBoxName);

  @override
  Future<void> cacheProducts(List<ProductModel> products) async {
    try {
      final box = await _openCacheBox();
      final jsonList = products.map((e) => e.toJson()).toList();
      await box.put(productsKey, jsonEncode(jsonList));
    } catch (e) {
      throw CacheException('Falha ao salvar cache: $e');
    }
  }

  @override
  Future<List<ProductModel>?> getCachedProducts() async {
    try {
      final box = await _openCacheBox();
      final String? data = box.get(productsKey) as String?;
      if (data == null) return null;
      final List<dynamic> decoded = jsonDecode(data) as List<dynamic>;
      return decoded.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      throw CacheException('Falha ao ler cache: $e');
    }
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    final box = await _openFavBox();
    final List<dynamic>? list = box.get(favoritesKey)?.cast<dynamic>();
    if (list == null) return <int>{};
    return list.map((e) => (e as num).toInt()).toSet();
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    final box = await _openFavBox();
    final current = await getFavoriteIds();
    if (current.contains(productId)) {
      current.remove(productId);
    } else {
      current.add(productId);
    }
    await box.put(favoritesKey, current.toList());
  }
}
