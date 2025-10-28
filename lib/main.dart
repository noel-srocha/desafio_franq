import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'presentation/bloc/auth/auth_cubit.dart';
import 'presentation/bloc/auth/auth_state.dart';
import './data/datasources/auth_local_data_source.dart';
import './data/datasources/auth_remote_data_source.dart';
import './data/datasources/product_local_data_source.dart';
import './data/datasources/product_remote_data_source.dart';
import './data/repositories/auth_repository_impl.dart';
import './data/repositories/product_repository_impl.dart';
import './domain/repositories/auth_repository.dart';
import './domain/repositories/product_repository.dart';
import './presentation/pages/home_page.dart';
import './presentation/pages/login_page.dart';
import 'presentation/bloc/favorites/favorites_cubit.dart';
import 'presentation/bloc/products/product_list_cubit.dart';
import 'presentation/bloc/theme/theme_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  // build repositories
  final ProductRepository productRepository = ProductRepositoryImpl(
    remote: ProductRemoteDataSourceImpl(),
    local: ProductLocalDataSourceImpl(),
  );
  final AuthRepository authRepository = AuthRepositoryImpl(
    remote: AuthRemoteDataSourceImpl(),
    local: AuthLocalDataSourceImpl(),
  );

  runApp(MyApp(
    productRepository: productRepository,
    authRepository: authRepository,
  ));
}

class MyApp extends StatelessWidget {
  final ProductRepository productRepository;
  final AuthRepository authRepository;
  const MyApp({super.key, required this.productRepository, required this.authRepository});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepository>.value(value: productRepository),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit()..load()),
          BlocProvider(create: (ctx) => AuthCubit(repository: authRepository)..appStarted()),
          BlocProvider(create: (ctx) => ProductListCubit(repository: productRepository)),
          BlocProvider(create: (ctx) => FavoritesCubit(repository: productRepository)),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            final theme = ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: themeState.isDark ? Brightness.dark : Brightness.light),
              useMaterial3: true,
            );
            return MaterialApp(
              title: 'FakeStore Explorer',
              theme: theme,
              darkTheme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple, brightness: Brightness.dark),
                useMaterial3: true,
              ),
              themeMode: themeState.isDark ? ThemeMode.dark : ThemeMode.light,
              home: BlocBuilder<AuthCubit, AuthState>(
                builder: (context, authState) {
                  switch (authState.status) {
                    case AuthStatus.loading:
                    case AuthStatus.unknown:
                      return const Scaffold(body: Center(child: CircularProgressIndicator()));
                    case AuthStatus.authenticated:
                      return const HomePage();
                    case AuthStatus.unauthenticated:
                    case AuthStatus.failure:
                      return const LoginPage();
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
