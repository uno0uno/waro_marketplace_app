import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/product.dart';

String formatPrice(double price) => '\$${price.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (m) => '${m[1]}.')}';

/// Fiel a front_nuxt/components/public/PublicProductCard.vue
class PublicProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final bool restaurantClosed;
  const PublicProductCard({super.key, required this.product, this.onTap, this.restaurantClosed = false});

  @override
  Widget build(BuildContext context) {
    final available = product.isAvailable && !restaurantClosed;
    final hasImage = product.imageUrl != null && product.imageUrl!.startsWith('http');
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: available ? onTap : null,
        child: Opacity(
          opacity: available ? 1 : 0.6,
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Stack(children: [
              Container(height: 140, width: double.infinity, color: AppColors.titan200,
                child: hasImage ? CachedNetworkImage(imageUrl: product.imageUrl!, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Center(child: Text('🍽️', style: TextStyle(fontSize: 32)))) : const Center(child: Text('🍽️', style: TextStyle(fontSize: 32)))),
              if (!available) Positioned(top: 8, left: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(6)), child: const Text('No disponible', style: TextStyle(color: Colors.white, fontSize: 10)))),
            ]),
            Padding(padding: const EdgeInsets.all(10), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
              if (product.description != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(product.description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary))),
              if (product.hasModifiers || product.preparationTime != null) Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(children: [
                  if (product.hasModifiers) Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2), decoration: BoxDecoration(color: AppColors.crocus50, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.crocus200)), child: const Text('Personalizable', style: TextStyle(fontSize: 10, color: AppColors.crocus700))),
                  if (product.hasModifiers && product.preparationTime != null) const Text(' · ', style: TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                  if (product.preparationTime != null) Text('${product.preparationTime} min', style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
                ]),
              ),
              const SizedBox(height: 8),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text(formatPrice(product.price), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.crocus600)),
                Container(width: 28, height: 28, decoration: BoxDecoration(color: available ? AppColors.crocus600 : AppColors.titan400, shape: BoxShape.circle), child: const Icon(Icons.add, size: 16, color: Colors.white)),
              ]),
            ])),
          ]),
        ),
      ),
    );
  }
}
