import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/api_client.dart';
import '../../data/models/product.dart';
import '../../widgets/product_card.dart';
import '../product/product_detail_screen.dart';

final apiClientProvider = Provider((ref) => ApiClient());
final productsProvider = FutureProvider<List<Product>>((ref) => ref.watch(apiClientProvider).fetchProducts());

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('WARO Marketplace')),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (products) => GridView.builder(
          padding: const EdgeInsets.all(12),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
          itemCount: products.length,
          itemBuilder: (_, i) => ProductCard(
            product: products[i],
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: products[i]))),
          ),
        ),
      ),
    );
  }
}
