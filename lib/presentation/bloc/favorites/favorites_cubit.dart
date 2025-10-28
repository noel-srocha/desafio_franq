import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/product_repository.dart';
import 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  final ProductRepository repository;

  FavoritesCubit({required this.repository}) : super(const FavoritesState());

  Future<void> load() async {
    emit(state.copyWith(status: FavoritesStatus.loading));
    try {
      final ids = await repository.getFavoriteIds();
      emit(state.copyWith(status: FavoritesStatus.ready, ids: ids));
    } catch (e) {
      emit(state.copyWith(status: FavoritesStatus.failure, error: e.toString()));
    }
  }

  Future<void> toggle(int productId) async {
    await repository.toggleFavorite(productId);
    final ids = await repository.getFavoriteIds();
    emit(state.copyWith(status: FavoritesStatus.ready, ids: ids));
  }
}
