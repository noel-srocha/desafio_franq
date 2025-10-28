import 'package:desafio_franq/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/favorites/favorites_state.dart';
import '../bloc/products/product_list_cubit.dart';
import '../bloc/products/product_list_state.dart';
import '../widgets/product_card.dart';

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, productsState) {
        return BlocBuilder<FavoritesCubit, FavoritesState>(
          builder: (context, favState) {
            final favIds = favState.ids;
            final favProducts = productsState.all.where((p) => favIds.contains(p.id)).toList();

            if (favProducts.isEmpty) {
              return const Center(
                child: Text('Nenhum favorito ainda.'),
              );
            }

            return GridView.builder(
              padding: const EdgeInsets.all(8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 0.66,
              ),
              itemCount: favProducts.length,
              itemBuilder: (context, index) {
                final p = favProducts[index];
                return ProductCard(
                  product: p,
                  isFavorite: true,
                  onFavoriteToggle: () => context.read<FavoritesCubit>().toggle(p.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
