import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/models/product.dart';

String formatCop(double value) {
  final n = value.toStringAsFixed(0);
  final buf = StringBuffer('\$');
  for (var i = 0; i < n.length; i++) {
    if (i > 0 && (n.length - i) % 3 == 0) buf.write('.');
    buf.write(n[i]);
  }
  return buf.toString();
}

/// Paridad con front_nuxt `PublicMenu`: foto, nombre, descripcion,
/// precio COP, badge de no-disponible y boton agregar (visual).
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback? onAdd;
  const ProductCard({super.key, required this.product, required this.onTap, this.onAdd});

  @override
  Widget build(BuildContext context) {
    final photoUrl = (product.imageUrl?.startsWith('http') ?? false) ? product.imageUrl : null;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (photoUrl != null)
                    Image.network(
                      photoUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, Object err, ___) {
                        debugPrint('ProductCard image failed (${product.id}): $err');
                        return const _PhotoFallback(isError: true);
                      },
                    )
                  else
                    const _PhotoFallback(),
                  if (!product.isAvailable)
                    Positioned(
                      left: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text('No disponible',
                            style: TextStyle(fontSize: 11, color: Colors.white)),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  if (product.description?.isNotEmpty ?? false)
                    Text(product.description!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.ebony500)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(formatCop(product.price),
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: AppColors.crocus600)),
                      ),
                      InkWell(
                        onTap: product.isAvailable ? (onAdd ?? onTap) : null,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: product.isAvailable
                                ? AppColors.crocus600
                                : AppColors.titan200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Agregar',
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoFallback extends StatelessWidget {
  final bool isError;
  const _PhotoFallback({this.isError = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.titan200,
      child: Center(
        child: Icon(isError ? Icons.broken_image_outlined : Icons.fastfood,
            size: 48, color: AppColors.ebony500),
      ),
    );
  }
}
