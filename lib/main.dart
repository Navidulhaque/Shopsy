import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'data/cart_storage.dart';
import 'data/product_repository.dart';
import 'domain/repositories/cart_storage.dart';
import 'domain/repositories/product_repository.dart';
import 'domain/usecases/clear_cart.dart';
import 'domain/usecases/get_products.dart';
import 'domain/usecases/hydrate_cart.dart';
import 'domain/usecases/persist_cart.dart';
import 'domain/usecases/search_products.dart';
import 'viewmodels/cart_view_model.dart';
import 'viewmodels/product_list_view_model.dart';

void main() {
  GoogleFonts.config.allowRuntimeFetching = false;
  runApp(
    MultiProvider(
      providers: [
        Provider<IProductRepository>(create: (_) => ProductRepositoryImpl()),
        Provider<ICartStorage>(create: (_) => CartStorageImpl()),
        Provider<GetProducts>(
          create: (context) => GetProducts(context.read<IProductRepository>()),
        ),
        Provider<SearchProducts>(create: (_) => const SearchProducts()),
        Provider<HydrateCart>(
          create: (context) => HydrateCart(
            context.read<ICartStorage>(),
            context.read<IProductRepository>(),
          ),
        ),
        Provider<PersistCart>(
          create: (context) => PersistCart(context.read<ICartStorage>()),
        ),
        Provider<ClearCart>(
          create: (context) => ClearCart(context.read<ICartStorage>()),
        ),
        ChangeNotifierProvider<ProductListViewModel>(
          create: (context) => ProductListViewModel(
            context.read<GetProducts>(),
            context.read<SearchProducts>(),
          )..loadProducts(),
        ),
        ChangeNotifierProvider<CartViewModel>(
          create: (context) => CartViewModel(
            context.read<HydrateCart>(),
            context.read<PersistCart>(),
            context.read<ClearCart>(),
          )..hydrate(),
        ),
      ],
      child: const App(),
    ),
  );
}