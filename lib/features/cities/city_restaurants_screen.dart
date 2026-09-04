import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/api_config.dart';
import '../../data/models/city.dart';
import '../../data/models/restaurant.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../feed/feed_screen.dart';
import 'cities_screen.dart';

final cityRestaurantsProvider =
    FutureProvider.family<List<Restaurant>, String>((ref, slug) => ref.watch(apiClientProvider).fetchRestaurants(slug));

class CityRestaurantsScreen extends ConsumerWidget {
  final City city;
  const CityRestaurantsScreen({super.key, required this.city});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(cityRestaurantsProvider(city.slug));
    return Scaffold(
      appBar: AppHeader(
        onCitiesTap: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const CitiesScreen()),
            (_) => false,
          );
        },
      ),
      bottomNavigationBar: AppBottomNav(
        currentIndex: 1,
        onTap: (i) {
          if (i == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const FeedScreen()),
              (_) => false,
            );
          } else if (i == 1) {
            Navigator.pop(context);
          }
        },
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Error (${ApiConfig.environment}): $e'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.refresh(cityRestaurantsProvider(city.slug)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (restaurants) => restaurants.isEmpty
            ? Center(child: Text('Sin restaurantes en ${city.name} (${ApiConfig.environment})'))
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Restaurantes en ${city.name} (${restaurants.length})',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  ...restaurants.map(
                    (r) => ListTile(
                      leading: r.logoUrl != null
                          ? CircleAvatar(backgroundImage: NetworkImage(r.logoUrl!))
                          : const CircleAvatar(child: Icon(Icons.restaurant_outlined)),
                      title: Text(r.displayName),
                      subtitle: Text(r.isOpen ? 'Abierto' : 'Cerrado'),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
