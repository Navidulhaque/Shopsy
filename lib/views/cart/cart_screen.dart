import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/cart_view_model.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CartViewModel>();
    final entries = vm.items.entries.toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Your Cart')),
      body: entries.isEmpty
          ? const Center(child: Text('Your cart is empty'))
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: entries.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = entries[index];
                      final item = entry.value;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(item.product.imageUrl),
                        ),
                        title: Text(item.product.title),
                        subtitle:
                            Text('₹${item.product.price.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline),
                              onPressed: () => vm.removeOne(item.product),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline),
                              onPressed: () => vm.add(item.product),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline,color: Colors.red,),
                              onPressed: () => vm.removeAll(item.product),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total: ₹${vm.totalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      ElevatedButton(
                        onPressed: entries.isEmpty ? null : () {},
                        child: const Text('Checkout'),
                      ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
