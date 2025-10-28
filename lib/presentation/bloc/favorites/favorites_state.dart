import 'package:equatable/equatable.dart';

enum FavoritesStatus { initial, loading, ready, failure }

class FavoritesState extends Equatable {
  final FavoritesStatus status;
  final Set<int> ids;
  final String? error;

  const FavoritesState({
    this.status = FavoritesStatus.initial,
    this.ids = const <int>{},
    this.error,
  });

  FavoritesState copyWith({FavoritesStatus? status, Set<int>? ids, String? error}) => FavoritesState(
        status: status ?? this.status,
        ids: ids ?? this.ids,
        error: error,
      );

  @override
  List<Object?> get props => [status, ids, error];
}
