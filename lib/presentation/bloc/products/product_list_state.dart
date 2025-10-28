import 'package:desafio_franq/domain/entities/product.dart';
import 'package:equatable/equatable.dart';

enum ProductListStatus { initial, loading, success, failure }

class ProductListState extends Equatable {
  final ProductListStatus status;
  final List<Product> all;
  final List<Product> visible;
  final List<String> categories; // includes 'Todos' at [0]
  final String? selectedCategory; // null or name
  final String query;
  final String? error;

  const ProductListState({
    this.status = ProductListStatus.initial,
    this.all = const [],
    this.visible = const [],
    this.categories = const ['Todos'],
    this.selectedCategory,
    this.query = '',
    this.error,
  });

  ProductListState copyWith({
    ProductListStatus? status,
    List<Product>? all,
    List<Product>? visible,
    List<String>? categories,
    String? selectedCategory,
    String? query,
    String? error,
  }) {
    return ProductListState(
      status: status ?? this.status,
      all: all ?? this.all,
      visible: visible ?? this.visible,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      query: query ?? this.query,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, all, visible, categories, selectedCategory, query, error];
}
