import 'package:desafio_franq/presentation/pages/products_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/auth/auth_cubit.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/products/product_list_cubit.dart';
import '../bloc/theme/theme_cubit.dart';
import 'favorites_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await context.read<ProductListCubit>().load();
      await context.read<FavoritesCubit>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      const ProductsPage(),
      const FavoritesPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('FakeStore Explorer'),
        actions: [
          IconButton(
            tooltip: 'Alternar tema',
            onPressed: () => context.read<ThemeCubit>().toggle(),
            icon: const Icon(Icons.brightness_6),
          ),
          IconButton(
            tooltip: 'Logout',
            onPressed: () => context.read<AuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.store), label: 'Produtos'),
        
          NavigationDestination(icon: Icon(Icons.favorite), label: 'Favoritos'),
        ],
        onDestinationSelected: (i) => setState(() => _index = i),
      ),
    );
  }
}
