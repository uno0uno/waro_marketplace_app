import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/models/restaurant.dart';

/// Paridad visual con front_nuxt `DirectoryView` (.restaurant-card):
/// foto (banner > logo > placeholder), badges de barrio y apertura,
/// cuerpo con nombre/descripcion/direccion/telefono y CTA.
class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final VoidCallback? onTap;
  const RestaurantCard({super.key, required this.restaurant, this.onTap});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    final photoUrl = (r.bannerUrl?.startsWith('http') ?? false)
        ? r.bannerUrl
        : (r.logoUrl?.startsWith('http') ?? false)
            ? r.logoUrl
            : null;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: photoUrl != null
                      ? Image.network(photoUrl, fit: BoxFit.cover,
                          errorBuilder: (_, Object err, ___) {
                            debugPrint('RestaurantCard image failed (${r.slug}): $err');
                            return const _Placeholder(isError: true);
                          })
                      : const _Placeholder(),
                ),
                Positioned.fill(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.transparent, Colors.black.withValues(alpha: 0.35)],
                      ),
                    ),
                  ),
                ),
                if (r.neighborhood != null && r.neighborhood!.isNotEmpty)
                  Positioned(
                    left: 8,
                    top: 8,
                    child: _Badge(label: r.neighborhood!),
                  ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: _Badge(
                    label: r.isOpen ? 'Abierto' : 'Cerrado',
                    dotColor: r.isOpen ? Colors.greenAccent : Colors.grey,
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(r.displayName,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(
                    (r.description?.isNotEmpty ?? false)
                        ? r.description!
                        : 'Explora el menú y haz tu pedido en línea.',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13, color: AppColors.ebony500),
                  ),
                  if (r.address != null && r.address!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(r.address!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 12)),
                      ),
                    ]),
                  ],
                  if (r.phoneNumber != null && r.phoneNumber!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Row(children: [
                      const Icon(Icons.phone_outlined, size: 14),
                      const SizedBox(width: 4),
                      Text(r.phoneNumber!, style: const TextStyle(fontSize: 12)),
                    ]),
                  ],
                  const SizedBox(height: 8),
                  const Text('Ver restaurante',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.crocus600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final bool isError;
  const _Placeholder({this.isError = false});
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.titan200,
      child: Center(
        child: isError
            ? const Icon(Icons.broken_image_outlined, size: 40, color: AppColors.ebony500)
            : const Text('🍽️', style: TextStyle(fontSize: 40)),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color? dotColor;
  const _Badge({required this.label, this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (dotColor != null) ...[
            Container(
                width: 8, height: 8,
                decoration: BoxDecoration(shape: BoxShape.circle, color: dotColor)),
            const SizedBox(width: 4),
          ],
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.white)),
        ],
      ),
    );
  }
}
