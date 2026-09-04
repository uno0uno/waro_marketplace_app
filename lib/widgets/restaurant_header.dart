import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';
import '../data/models/restaurant.dart';

const _dayLabels = {
  'monday': 'Lunes',
  'tuesday': 'Martes',
  'wednesday': 'Miércoles',
  'thursday': 'Jueves',
  'friday': 'Viernes',
  'saturday': 'Sábado',
  'sunday': 'Domingo',
};

/// Paridad con front_nuxt `RestaurantHeader`: banner, card con logo
/// superpuesto rounded, badge de apertura, descripcion, contacto/redes
/// y acordeon de horarios.
class RestaurantHeader extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantHeader({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    final r = restaurant;
    final bannerUrl = (r.bannerUrl?.startsWith('http') ?? false) ? r.bannerUrl : null;
    final logoUrl = (r.logoUrl?.startsWith('http') ?? false) ? r.logoUrl : null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 21 / 9,
          child: bannerUrl != null
              ? Image.network(bannerUrl, fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _bannerFallback())
              : _bannerFallback(),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.titan200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: AppColors.titan200,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.titan200, width: 2),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: logoUrl != null
                          ? Image.network(logoUrl, fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Center(child: Text('🍽️', style: TextStyle(fontSize: 28))))
                          : const Center(child: Text('🍽️', style: TextStyle(fontSize: 28))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(r.displayName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          _OpenBadge(
                              isOpen: r.isOpen, label: r.orderingLabel),
                        ],
                      ),
                    ),
                  ],
                ),
                if (r.description?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 12),
                  Text(r.description!),
                ],
                if (r.address?.isNotEmpty ?? false) ...[
                  const SizedBox(height: 8),
                  Text('📍 ${r.address!}',
                      style: const TextStyle(color: AppColors.ebony500)),
                ],
                if (r.socialMedia.isNotEmpty || (r.phoneNumber?.isNotEmpty ?? false)) ...[
                  const SizedBox(height: 12),
                  const Text('Contacto y redes',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (r.phoneNumber?.isNotEmpty ?? false)
                        _ContactChip(icon: Icons.phone_outlined, label: r.phoneNumber!),
                      for (final e in r.socialMedia.entries)
                        _ContactChip(icon: _socialIcon(e.key), label: e.value),
                    ],
                  ),
                ],
                if (r.businessHours.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: const Text('Horarios de atención',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      children: [
                        for (final day in _dayLabels.keys)
                          if (r.businessHours.containsKey(day))
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: Row(
                                children: [
                                  Expanded(child: Text(_dayLabels[day]!)),
                                  Text(
                                    r.businessHours[day]!.closed
                                        ? 'Cerrado'
                                        : '${r.businessHours[day]!.open} – ${r.businessHours[day]!.close}',
                                    style: const TextStyle(color: AppColors.ebony500),
                                  ),
                                ],
                              ),
                            ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  static IconData _socialIcon(String key) {
    switch (key) {
      case 'whatsapp':
        return Icons.chat_outlined;
      case 'instagram':
        return Icons.camera_alt_outlined;
      case 'facebook':
        return Icons.thumb_up_outlined;
      case 'tiktok':
        return Icons.music_note_outlined;
      default:
        return Icons.link_outlined;
    }
  }
}

Widget _bannerFallback() => Container(
      color: AppColors.titan200,
      child: const Center(child: Text('🏪', style: TextStyle(fontSize: 48))),
    );

class _OpenBadge extends StatelessWidget {
  final bool isOpen;
  final String? label;
  const _OpenBadge({required this.isOpen, this.label});

  @override
  Widget build(BuildContext context) {
    final bg = isOpen ? Colors.green[50]! : Colors.red[50]!;
    final fg = isOpen ? Colors.green[700]! : Colors.red[700]!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(shape: BoxShape.circle, color: fg)),
          const SizedBox(width: 8),
          Text(label ?? (isOpen ? 'Abierto' : 'Cerrado'),
              style: TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500, color: fg)),
        ],
      ),
    );
  }
}

class _ContactChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _ContactChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.titan200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
