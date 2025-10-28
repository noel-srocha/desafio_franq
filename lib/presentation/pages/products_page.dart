import 'package:desafio_franq/presentation/pages/product_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/favorites/favorites_state.dart';
import '../bloc/products/product_list_cubit.dart';
import '../bloc/products/product_list_state.dart';
import '../widgets/product_card.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;
    if (current >= max - 200) {
      context.read<ProductListCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProductListCubit, ProductListState>(
      builder: (context, state) {
        if (state.status == ProductListStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == ProductListStatus.failure) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline, size: 48),
                const SizedBox(height: 12),
                Text(state.error ?? 'Erro ao carregar'),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: () => context.read<ProductListCubit>().load(),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Tentar novamente'),
                ),
              ],
            ),
          );
        }

        final products = state.visible;

        return RefreshIndicator(
          onRefresh: () => context.read<ProductListCubit>().refresh(),
          child: CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          hintText: 'Buscar por nome',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (q) => context.read<ProductListCubit>().updateQuery(q),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text('Categoria: '),
                          const SizedBox(width: 8),
                          Expanded(
                            child: DropdownButtonFormField<String>(
                              initialValue: state.selectedCategory ?? 'Todos',
                              items: state.categories
                                  .map((c) => DropdownMenuItem<String>(value: c, child: Text(c)))
                                  .toList(),
                              onChanged: (val) {
                                final category = (val == 'Todos') ? null : val;
                                context.read<ProductListCubit>().selectCategory(category);
                              },
                              decoration: const InputDecoration(border: OutlineInputBorder()),
                            ),
                          ),
                        ],
                      ),
                      if (state.error != null) ...[
                        const SizedBox(height: 8),
                        Row(children: [
                          const Icon(Icons.offline_bolt, size: 16),
                          const SizedBox(width: 4),
                          Expanded(child: Text(state.error!, style: const TextStyle(fontSize: 12))),
                        ]),
                      ],
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                sliver: BlocBuilder<FavoritesCubit, FavoritesState>(
                  builder: (context, favState) {
                    return SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.66,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final p = products[index];
                          final isFav = favState.ids.contains(p.id);
                          return ProductCard(
                            product: p,
                            isFavorite: isFav,
                            onFavoriteToggle: () => context.read<FavoritesCubit>().toggle(p.id),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(builder: (_) => ProductDetailsPage(product: p)),
                            ),
                          );
                        },
                        childCount: products.length,
                      ),
                    );
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          ),
        );
      },
    );
  }
}
