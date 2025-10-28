import 'dart:async';

import 'package:desafio_franq/presentation/bloc/products/product_list_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/product.dart';
import '../../../domain/repositories/product_repository.dart';
import '../../../domain/usecases/filter_products.dart';

class ProductListCubit extends Cubit<ProductListState> {
  final ProductRepository repository;
  Timer? _debounce;
  static const int _pageSize = 10;
  int _visibleCount = 0;

  ProductListCubit({required this.repository}) : super(const ProductListState());

  Future<void> load() async {
    emit(state.copyWith(status: ProductListStatus.loading, error: null));
    try {
      final results = await Future.wait([
        repository.fetchAllProducts(),
        repository.fetchCategories(),
      ]);
      final products = results[0] as List<Product>;
      final categories = ['Todos', ...((results[1] as List<String>))];

      _visibleCount = 0;
      final visible = _applyFilters(products: products, categories: categories);
      emit(state.copyWith(
        status: ProductListStatus.success,
        all: products,
        categories: categories,
        visible: visible,
      ));
    } catch (e) {
      // Try cache
      final cached = await repository.getCachedProducts();
      if (cached != null && cached.isNotEmpty) {
        final categories = ['Todos', ...{...cached.map((e) => e.category)}];
        _visibleCount = 0;
        final visible = _applyFilters(products: cached, categories: categories);
        emit(state.copyWith(
          status: ProductListStatus.success,
          all: cached,
          categories: categories,
          visible: visible,
          error: 'Exibindo dados em cache. Erro: $e',
        ));
      } else {
        emit(state.copyWith(status: ProductListStatus.failure, error: e.toString()));
      }
    }
  }

  List<Product> _applyFilters({List<Product>? products, List<String>? categories}) {
    final all = products ?? state.all;
    final filtered = filterProducts(all, ProductFilters(query: state.query, category: state.selectedCategory));
    // pagination via local slicing
    _visibleCount = _pageSize;
    return filtered.take(_visibleCount).toList();
  }

  void updateQuery(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      final filtered = filterProducts(state.all, ProductFilters(query: query, category: state.selectedCategory));
      _visibleCount = _pageSize;
      emit(state.copyWith(query: query, visible: filtered.take(_visibleCount).toList()));
    });
  }

  void selectCategory(String? category) {
    final filtered = filterProducts(state.all, ProductFilters(query: state.query, category: category));
    _visibleCount = _pageSize;
    emit(state.copyWith(selectedCategory: category, visible: filtered.take(_visibleCount).toList()));
  }

  void loadMore() {
    if (state.status != ProductListStatus.success) return;
    final filtered = filterProducts(state.all, ProductFilters(query: state.query, category: state.selectedCategory));
    if (_visibleCount >= filtered.length) return;
    _visibleCount = (_visibleCount + _pageSize).clamp(0, filtered.length);
    emit(state.copyWith(visible: filtered.take(_visibleCount).toList()));
  }

  Future<void> refresh() async {
    await load();
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }
}
