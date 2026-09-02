import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_colors.dart';

class RestaurantHeader extends StatelessWidget {
  final String name;
  final String? description;
  final String? bannerUrl;
  final String? logoUrl;
  final bool isOpen;
  const RestaurantHeader({super.key, required this.name, this.description, this.bannerUrl, this.logoUrl, this.isOpen = true});

  @override
  Widget build(BuildContext context) {
    final hasBanner = bannerUrl != null && bannerUrl!.startsWith('http');
    return Column(
      children: [
        // Banner
        Container(
          height: 160,
          width: double.infinity,
          decoration: const BoxDecoration(gradient: LinearGradient(colors: [AppColors.crocus600, AppColors.crocus800])),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (hasBanner) CachedNetworkImage(imageUrl: bannerUrl!, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Center(child: Text('🏪', style: TextStyle(fontSize: 48))))
              else const Center(child: Text('🏪', style: TextStyle(fontSize: 48))),
              Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.5), Colors.transparent]))),
            ],
          ),
        ),
        // Info card overlapping
        Transform.translate(
          offset: const Offset(0, -24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 56, height: 56,
                    decoration: BoxDecoration(color: AppColors.titan200, borderRadius: BorderRadius.circular(12), border: Border.all(color: AppColors.border)),
                    clipBehavior: Clip.antiAlias,
                    child: (logoUrl != null && logoUrl!.startsWith('http'))
                        ? CachedNetworkImage(imageUrl: logoUrl!, fit: BoxFit.cover, errorWidget: (_, __, ___) => const Center(child: Text('🍽️')))
                        : const Center(child: Text('🍽️', style: TextStyle(fontSize: 28))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Row(children: [
                      Expanded(child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary))),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: (isOpen ? AppColors.success : AppColors.destructive).withOpacity(0.12), borderRadius: BorderRadius.circular(6)),
                        child: Text(isOpen ? 'Abierto' : 'Cerrado', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: isOpen ? AppColors.success : AppColors.destructive)),
                      ),
                    ]),
                    if (description != null) Padding(padding: const EdgeInsets.only(top: 4), child: Text(description!, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary))),
                  ])),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
