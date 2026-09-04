import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/providers.dart';
import '../../data/models/catalog.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import 'widgets/tenants_screen.dart';

final citiesProvider = FutureProvider<List<City>>(
  (ref) => ref.watch(apiClientProvider).fetchCities(),
);

class CitiesScreen extends ConsumerWidget {
  const CitiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(citiesProvider);
    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('No se pudieron cargar las ciudades: $e',
                textAlign: TextAlign.center),
          ),
        ),
        data: (cities) => cities.isEmpty
            ? const Center(child: Text('Estamos cargando las ciudades disponibles…'))
            : ListView.separated(
                padding: const EdgeInsets.all(12),
                itemCount: cities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(cities[i].name),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TenantsScreen(city: cities[i]),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
