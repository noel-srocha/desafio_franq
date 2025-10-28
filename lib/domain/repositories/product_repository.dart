import 'package:desafio_franq/domain/entities/product.dart';

abstract class ProductRepository {
  Future<List<Product>> fetchAllProducts();
  Future<List<String>> fetchCategories();
  Future<List<Product>> fetchProductsByCategory(String category);
  Future<void> cacheProducts(List<Product> products);
  Future<List<Product>?> getCachedProducts();

  // Favorites
  Future<Set<int>> getFavoriteIds();
  Future<void> toggleFavorite(int productId);
}
