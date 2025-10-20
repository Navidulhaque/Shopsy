import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/product.dart';
import '../../viewmodels/cart_view_model.dart';
import '../../viewmodels/product_list_view_model.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductListViewModel vm = context.watch<ProductListViewModel>();
    final int cartCount = context.select<CartViewModel, int>(
      (c) => c.totalItems,
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopsy'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined),
                onPressed: () => Navigator.of(context).pushNamed('/cart'),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: _Body(vm: vm),
    );
  }
}

class _Body extends StatelessWidget {
  final ProductListViewModel vm;
  const _Body({required this.vm});

  @override
  Widget build(BuildContext context) {
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (vm.error != null) {
      return Center(child: Text(vm.error!));
    }
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Search by name or type',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: vm.search,
                ),
                // search history UI removed
              ],
            ),
          ),
        ),
        if (vm.products.isEmpty)
          const SliverFillRemaining(
            hasScrollBody: false,
            child: Center(child: Text('No products found')),
          )
        else
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              final Product p = vm.products[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Card(
                  elevation: 1,
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: InkWell(
                    onTap:
                        () => Navigator.of(
                          context,
                        ).pushNamed('/detail', arguments: p),
                    child: SizedBox(
                      height: 160,
                      child: Row(
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: Image.network(p.imageUrl, fit: BoxFit.cover),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p.title,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        p.type,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '₹${p.price.toStringAsFixed(2)}',
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleMedium,
                                      ),
                                      Builder(
                                        builder: (context) {
                                          final int qty = context.select<
                                            CartViewModel,
                                            int
                                          >(
                                            (c) => c.items[p.id]?.quantity ?? 0,
                                          );
                                          if (qty <= 0) {
                                            return IconButton(
                                              icon: const Icon(
                                                Icons.add_shopping_cart,
                                              ),
                                              onPressed:
                                                  () => context
                                                      .read<CartViewModel>()
                                                      .add(p),
                                            );
                                          }
                                          return Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.remove_circle_outline,
                                                ),
                                                onPressed:
                                                    () => context
                                                        .read<CartViewModel>()
                                                        .removeOne(p),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color:
                                                      Theme.of(context)
                                                          .colorScheme
                                                          .surfaceVariant,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  '$qty',
                                                  style:
                                                      Theme.of(
                                                        context,
                                                      ).textTheme.titleMedium,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(
                                                  Icons.add_circle_outline,
                                                ),
                                                onPressed:
                                                    () => context
                                                        .read<CartViewModel>()
                                                        .add(p),
                                              ),
                                            ],
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }, childCount: vm.products.length),
          ),
      ],
    );
  }
}
