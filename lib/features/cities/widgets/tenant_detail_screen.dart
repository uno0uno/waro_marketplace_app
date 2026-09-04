import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/providers.dart';
import '../../../data/models/catalog.dart';
import '../../../data/models/product.dart';
import '../../../widgets/app_header.dart';
import '../../../widgets/app_bottom_nav.dart';
import '../../restaurant/widgets/restaurant_header.dart';
import '../../restaurant/widgets/public_product_card.dart';
import '../../product/product_detail_screen.dart';

final tenantMenuProvider = FutureProvider.family<List<Product>, String>(
  (ref, slug) => ref.watch(apiClientProvider).fetchTenantMenu(slug),
);

class TenantDetailScreen extends ConsumerWidget {
  final Tenant tenant;
  const TenantDetailScreen({super.key, required this.tenant});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(tenantMenuProvider(tenant.slug));
    return Scaffold(
      appBar: const AppHeader(),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            RestaurantHeader(
              name: tenant.displayName,
              description: tenant.description,
              bannerUrl: tenant.bannerUrl,
              logoUrl: tenant.logoUrl,
              isOpen: tenant.isOpen,
            ),
            async.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(24),
                child: Text('No se pudo cargar el menú: $e',
                    textAlign: TextAlign.center),
              ),
              data: (products) => products.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Este restaurante aún no tiene productos.',
                          textAlign: TextAlign.center),
                    )
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: products.length,
                      itemBuilder: (_, i) => PublicProductCard(
                        product: products[i],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProductDetailScreen(product: products[i]),
                          ),
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
