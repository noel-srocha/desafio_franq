import 'package:desafio_franq/data/datasources/product_local_data_source.dart';
import 'package:desafio_franq/data/datasources/product_remote_data_source.dart';
import 'package:desafio_franq/data/models/product_model.dart';
import 'package:desafio_franq/domain/entities/product.dart';
import 'package:desafio_franq/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;
  final ProductLocalDataSource local;

  ProductRepositoryImpl({required this.remote, required this.local});

  @override
  Future<void> cacheProducts(List<Product> products) async {
    final models = products.map(ProductModel.fromEntity).toList();
    await local.cacheProducts(models);
  }

  @override
  Future<List<Product>> fetchAllProducts() async {
    final models = await remote.fetchAllProducts();
    final products = models.map((e) => e.toEntity()).toList();
    // cache in background
    try {
      await local.cacheProducts(models);
    } catch (_) {}
    return products;
  }

  @override
  Future<List<String>> fetchCategories() async {
    return remote.fetchCategories();
  }

  @override
  Future<List<Product>> fetchProductsByCategory(String category) async {
    final models = await remote.fetchProductsByCategory(category);
    return models.map((e) => e.toEntity()).toList();
  }

  @override
  Future<List<Product>?> getCachedProducts() async {
    final cached = await local.getCachedProducts();
    return cached?.map((e) => e.toEntity()).toList();
  }

  @override
  Future<Set<int>> getFavoriteIds() async {
    return local.getFavoriteIds();
  }

  @override
  Future<void> toggleFavorite(int productId) async {
    await local.toggleFavorite(productId);
  }
}
