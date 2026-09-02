import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/config/api_config.dart';
import '../../data/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(height: 200, color: Colors.grey[200], child: const Icon(Icons.fastfood, size: 64)),
          const SizedBox(height: 16),
          Text(product.name, style: Theme.of(context).textTheme.headlineSmall),
          if (product.tenantName != null) Text(product.tenantName!),
          const SizedBox(height: 8),
          Text('\$${product.price.toStringAsFixed(0)}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0E7A5A))),
          if (product.description != null) Padding(padding: const EdgeInsets.only(top: 12), child: Text(product.description!)),
          if (product.modifierGroups.isNotEmpty) ...[
            const Divider(height: 32),
            for (final g in product.modifierGroups) ListTile(title: Text(g.name), subtitle: Text(g.modifiers.map((m) => m.name).join(', '))),
          ],
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => launchUrl(Uri.parse(ApiConfig.waroColProductUrl(product.id)), mode: LaunchMode.externalApplication),
            icon: const Icon(Icons.open_in_new),
            label: const Text('Ver en warocol.com'),
          ),
        ],
      ),
    );
  }
}
