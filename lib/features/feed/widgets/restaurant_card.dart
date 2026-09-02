import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String? description;
  final String? logoUrl;
  final bool isOpen;
  final VoidCallback? onTap;
  const RestaurantCard({super.key, required this.name, this.description, this.logoUrl, this.isOpen = true, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Logo(url: logoUrl),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(child: Text(name, style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                      const SizedBox(width: 8),
                      _Badge(open: isOpen),
                    ]),
                    if (description != null && description!.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.textSecondary)),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final String? url;
  const _Logo({this.url});
  @override
  Widget build(BuildContext context) {
    final isHttp = url != null && url!.startsWith('http');
    return Container(
      width: 48, height: 48,
      decoration: BoxDecoration(color: AppColors.titan200, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
      clipBehavior: Clip.antiAlias,
      child: isHttp ? CachedNetworkImage(imageUrl: url!, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Center(child: Text('🍽️'))) : const Center(child: Text('🍽️', style: TextStyle(fontSize: 24))),
    );
  }
}

class _Badge extends StatelessWidget {
  final bool open;
  const _Badge({required this.open});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: (open ? AppColors.success : AppColors.destructive).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6, decoration: BoxDecoration(color: open ? AppColors.success : AppColors.destructive, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(open ? 'Abierto' : 'Cerrado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: open ? AppColors.success : AppColors.destructive)),
      ]),
    );
  }
}
