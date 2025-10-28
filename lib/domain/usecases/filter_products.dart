import 'package:desafio_franq/domain/entities/product.dart';

class ProductFilters {
  final String query;
  final String? category; // null or 'Todos'

  const ProductFilters({this.query = '', this.category});
}

List<Product> filterProducts(List<Product> input, ProductFilters filters) {
  final q = filters.query.trim().toLowerCase();
  final cat = (filters.category == null || filters.category == 'Todos')
      ? null
      : filters.category!.toLowerCase();

  return input.where((p) {
    final matchesQuery = q.isEmpty || p.title.toLowerCase().contains(q);
    final matchesCat = cat == null || p.category.toLowerCase() == cat;
    return matchesQuery && matchesCat;
  }).toList(growable: false);
}