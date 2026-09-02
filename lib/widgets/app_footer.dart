import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/theme/app_colors.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});
  @override
  Widget build(BuildContext context) {
    final year = DateTime.now().year;
    return Container(
      decoration: const BoxDecoration(color: Colors.white, border: Border(top: BorderSide(color: AppColors.border))),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        children: [
          const Text('Waro Colombia', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
          const SizedBox(height: 12),
          Wrap(spacing: 16, children: [
            _Link(label: 'Github', url: 'https://github.com/uno0uno/warocol.com'),
            _Link(label: 'Instagram', url: 'https://instagram.com/warocolombia'),
            _Link(label: 'Blog', onTap: () {}),
          ]),
          const SizedBox(height: 12),
          Text('© $year Waro Colombia. Todos los derechos reservados.', style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final String label;
  final String? url;
  final VoidCallback? onTap;
  const _Link({required this.label, this.url, this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? (url != null ? () => launchUrl(Uri.parse(url!), mode: LaunchMode.externalApplication) : null),
      child: Text(label, style: const TextStyle(fontSize: 12, color: AppColors.ebony600, decoration: TextDecoration.underline)),
    );
  }
}
