import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/api_config.dart';
import '../../data/models/city.dart';
import '../../data/models/restaurant.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/restaurant_card.dart';
import '../restaurant/restaurant_detail_screen.dart';
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
        data: (restaurants) {
          if (restaurants.isEmpty) {
            return Center(child: Text('Sin restaurantes en ${city.name} (${ApiConfig.environment})'));
          }
          final sorted = [...restaurants]..sort((a, b) {
              if (a.isOpen == b.isOpen) return a.displayName.compareTo(b.displayName);
              return a.isOpen ? -1 : 1;
            });
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            itemCount: sorted.length + 1,
            itemBuilder: (_, i) {
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: Text(
                    'Restaurantes en ${city.name} (${sorted.length})',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                );
              }
              final r = sorted[i - 1];
              return Padding(
                padding: const EdgeInsets.only(top: 12),
                child: RestaurantCard(
                  restaurant: r,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => RestaurantDetailScreen(restaurant: r)),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
