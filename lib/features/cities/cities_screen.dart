import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/api_config.dart';
import '../../data/models/city.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../feed/feed_screen.dart';
import 'city_restaurants_screen.dart';

final citiesProvider = FutureProvider<List<City>>((ref) => ref.watch(apiClientProvider).fetchCities());

class CitiesScreen extends ConsumerWidget {
  const CitiesScreen({super.key});

  void _onNavTap(BuildContext context, int i) {
    if (i == 0) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const FeedScreen()),
        (_) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(citiesProvider);
    return Scaffold(
      appBar: AppHeader(onCitiesTap: () {}),
      bottomNavigationBar: AppBottomNav(currentIndex: 1, onTap: (i) => _onNavTap(context, i)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error (${ApiConfig.environment}): $e')),
        data: (cities) => cities.isEmpty
            ? Center(child: Text('Sin ciudades (${ApiConfig.environment})'))
            : ListView.separated(
                itemCount: cities.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (_, i) => ListTile(
                  leading: const Icon(Icons.location_on_outlined),
                  title: Text(cities[i].name),
                  subtitle: Text(cities[i].slug),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CityRestaurantsScreen(city: cities[i])),
                  ),
                ),
              ),
      ),
    );
  }
}
