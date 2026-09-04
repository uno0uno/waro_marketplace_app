import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers.dart';
import '../../../data/models/catalog.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../feed/widgets/restaurant_card.dart';
import 'tenant_detail_screen.dart';

final tenantsProvider =
    FutureProvider.family<List<Tenant>, String>((ref, citySlug) =>
        ref.watch(apiClientProvider).fetchTenants(citySlug: citySlug));

class TenantsScreen extends ConsumerWidget {
  final City city;
  const TenantsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tenantsProvider(city.slug));
    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudieron cargar los restaurantes: $e',
                textAlign: TextAlign.center),
          ),
        ),
        data: (tenants) => tenants.isEmpty
            ? const Center(child: Text('No hay restaurantes en esta ciudad todavía.'))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: tenants.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) {
                  final t = tenants[i];
                  return RestaurantCard(
                    name: t.displayName,
                    description: t.description,
                    logoUrl: t.logoUrl,
                    isOpen: t.isOpen,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TenantDetailScreen(tenant: t),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
