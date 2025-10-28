import 'package:desafio_franq/domain/entities/product.dart';
import 'package:desafio_franq/domain/entities/rating.dart';
import 'package:desafio_franq/domain/usecases/filter_products.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('filterProducts', () {
    final all = <Product>[
      Product(
        id: 1,
        title: 'Mens Casual Premium Slim Fit T-Shirts',
        price: 22.3,
        description: 'desc',
        category: 'men\'s clothing',
        image: 'url',
        rating: const Rating(rate: 4.1, count: 100),
      ),
      Product(
        id: 2,
        title: 'Solid Gold Petite Micropave',
        price: 168,
        description: 'desc',
        category: 'jewelery',
        image: 'url',
        rating: const Rating(rate: 4.8, count: 200),
      ),
      Product(
        id: 3,
        title: 'WD 2TB Elements Portable External Hard Drive',
        price: 64,
        description: 'desc',
        category: 'electronics',
        image: 'url',
        rating: const Rating(rate: 4.7, count: 300),
      ),
    ];

    test('returns all when no filters', () {
      final result = filterProducts(all, const ProductFilters());
      expect(result.length, all.length);
    });

    test('filters by query (case-insensitive)', () {
      final result = filterProducts(all, const ProductFilters(query: 'gold'));
      expect(result.map((e) => e.id), [2]);
    });

    test('filters by category', () {
      final result = filterProducts(all, const ProductFilters(category: 'electronics'));
      expect(result.map((e) => e.id), [3]);
    });

    test('filters by query and category', () {
      final result = filterProducts(all, const ProductFilters(query: 't-shirts', category: "men's clothing"));
      expect(result.map((e) => e.id), [1]);
    });
  });
}
