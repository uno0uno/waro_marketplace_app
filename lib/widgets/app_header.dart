import 'package:flutter/material.dart';
import '../core/theme/app_colors.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final bool isLoggedIn;
  final VoidCallback? onCreateAccount;
  final VoidCallback? onSignIn;
  final VoidCallback? onHomeTap;
  final VoidCallback? onCitiesTap;
  const AppHeader({super.key, this.isLoggedIn = false, this.onCreateAccount, this.onSignIn, this.onHomeTap, this.onCitiesTap});

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 768;
    return AppBar(
      backgroundColor: AppColors.surface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(preferredSize: const Size.fromHeight(1), child: Container(height: 1, color: AppColors.titan200)),
      titleSpacing: 12,
      title: LayoutBuilder(builder: (context, c) {
        final compact = c.maxWidth < 360;
        return Row(
          children: [
            const Text('WARO', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.ebony900, fontSize: 16)),
            if (!compact)
              Container(
                margin: const EdgeInsets.only(left: 6),
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: AppColors.crocus50, border: Border.all(color: AppColors.crocus200), borderRadius: BorderRadius.circular(8)),
                child: const Text('COLOMBIA', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, letterSpacing: 1, color: AppColors.crocus600)),
              ),
            if (isDesktop) ...[
              const SizedBox(width: 24),
              _NavLink(label: 'Inicio', active: true, onTap: onHomeTap),
              _NavLink(label: 'Ciudades', onTap: onCitiesTap),
              const _NavLink(label: 'Blog'),
            ],
            const Spacer(),
            if (!compact) TextButton(onPressed: onSignIn, child: Text(isLoggedIn ? 'Mi Panel' : 'Ingresar', style: const TextStyle(fontSize: 11, color: AppColors.ebony600))),
            const SizedBox(width: 4),
            FilledButton(
              onPressed: onCreateAccount,
              style: FilledButton.styleFrom(backgroundColor: AppColors.crocus600, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), minimumSize: const Size(0, 32), tapTargetSize: MaterialTapTargetSize.shrinkWrap, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              child: const Text('Crear cuenta', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
            ),
          ],
        );
      }),
    );
  }
}

class _NavLink extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback? onTap;
  const _NavLink({required this.label, this.active = false, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
      margin: const EdgeInsets.only(right: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: active ? AppColors.crocus50 : Colors.transparent, borderRadius: BorderRadius.circular(10)),
      child: Text(label, style: TextStyle(fontSize: 13, fontWeight: active ? FontWeight.w600 : FontWeight.w500, color: active ? AppColors.crocus600 : AppColors.ebony500)),
      ),
    );
  }
}
