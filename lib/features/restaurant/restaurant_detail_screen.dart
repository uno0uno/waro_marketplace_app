import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/api_config.dart';
import '../../data/models/menu_data.dart';
import '../../data/models/product.dart';
import '../../data/models/restaurant.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/product_card.dart';
import '../feed/feed_screen.dart';
import '../product/product_detail_screen.dart';
import '../cities/cities_screen.dart';

class _DetailData {
  final Restaurant profile;
  final MenuData menu;
  _DetailData(this.profile, this.menu);
}

final restaurantDetailProvider = FutureProvider.family<_DetailData, String>((ref, slug) async {
  final api = ref.watch(apiClientProvider);
  final results = await Future.wait([api.fetchProfile(slug), api.fetchMenu(slug)]);
  return _DetailData(results[0] as Restaurant, results[1] as MenuData);
});

class RestaurantDetailScreen extends ConsumerWidget {
  final Restaurant restaurant;
  const RestaurantDetailScreen({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(restaurantDetailProvider(restaurant.slug));
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
                onPressed: () => ref.refresh(restaurantDetailProvider(restaurant.slug)),
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
        data: (d) => _Body(profile: d.profile, menu: d.menu),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Restaurant profile;
  final MenuData menu;
  const _Body({required this.profile, required this.menu});

  @override
  Widget build(BuildContext context) {
    final photoUrl = (profile.bannerUrl?.startsWith('http') ?? false)
        ? profile.bannerUrl
        : (profile.logoUrl?.startsWith('http') ?? false)
            ? profile.logoUrl
            : null;
    return ListView(
      children: [
        if (photoUrl != null)
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(photoUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink()),
          ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(profile.displayName, style: Theme.of(context).textTheme.headlineSmall),
              if (profile.description?.isNotEmpty ?? false) ...[
                const SizedBox(height: 8),
                Text(profile.description!),
              ],
              const SizedBox(height: 8),
              Text(profile.isOpen ? 'Abierto ahora' : 'Cerrado ahora',
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: profile.isOpen ? Colors.green[700] : Colors.grey[600])),
              if (profile.address?.isNotEmpty ?? false) Text('📍 ${profile.address!}'),
              if (profile.phoneNumber?.isNotEmpty ?? false) Text('📞 ${profile.phoneNumber!}'),
            ],
          ),
        ),
        if (menu.products.isEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text('Sin productos disponibles (${ApiConfig.environment})'),
          )
        else
          for (final cat in menu.categories)
            if (menu.productsIn(cat.id).isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text('${cat.name} (${menu.productsIn(cat.id).length})',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, childAspectRatio: 0.8, crossAxisSpacing: 12, mainAxisSpacing: 12),
                itemCount: menu.productsIn(cat.id).length,
                itemBuilder: (_, i) {
                  final Product p = menu.productsIn(cat.id)[i];
                  return ProductCard(
                    product: p,
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
                  );
                },
              ),
            ],
      ],
    );
  }
}
