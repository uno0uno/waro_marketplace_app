import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;
  const AppBottomNav({super.key, this.currentIndex = 0, this.onTap});

  static const _items = [
    (Icons.home_outlined, 'Inicio'),
    (Icons.location_on_outlined, 'Ciudades'),
    (Icons.article_outlined, 'Blog'),
    (Icons.menu_book_outlined, 'Docs'),
    (Icons.person_outline, 'Ingresar'),
  ];

  @override
  Widget build(BuildContext context) {
    // Hidden on desktop (>=768)
    if (MediaQuery.of(context).size.width >= 768) return const SizedBox.shrink();
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.titan200))),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 58,
          child: Row(
            children: List.generate(_items.length, (i) {
              final active = i == currentIndex;
              return Expanded(
                child: InkWell(
                  onTap: () => onTap?.call(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(_items[i].$1, size: 22, color: active ? AppColors.crocus600 : AppColors.ebony500),
                      const SizedBox(height: 2),
                      Text(_items[i].$2, style: TextStyle(fontSize: 10, fontWeight: active ? FontWeight.w600 : FontWeight.w400, color: active ? AppColors.crocus600 : AppColors.ebony500)),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
