import 'package:flutter/material.dart';
import '../data/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                child: Center(child: Icon(Icons.fastfood, size: 48, color: Colors.grey[600])),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  if (product.tenantName != null) Text(product.tenantName!, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                  Text('\$${product.price.toStringAsFixed(0)}', style: const TextStyle(color: Color(0xFF0E7A5A))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
