import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/product.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/favorites/favorites_state.dart';
import '../utils/currency.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      floatingActionButton: BlocBuilder<FavoritesCubit, FavoritesState>(
        builder: (context, favState) {
          final isFav = favState.ids.contains(product.id);
          return FloatingActionButton(
            onPressed: () => context.read<FavoritesCubit>().toggle(product.id),
            child: Icon(isFav ? Icons.favorite : Icons.favorite_border),
          );
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Hero(
            tag: 'product_${product.id}',
            child: AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.image,
                fit: BoxFit.contain,
                errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image)),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            product.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Chip(label: Text(product.category)),
              const SizedBox(width: 8),
              Row(
                children: [
                  const Icon(Icons.star, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text('${product.rating.rate} (${product.rating.count})'),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(
            Currency.brl(product.price),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(product.description),
        ],
      ),
    );
  }
}
