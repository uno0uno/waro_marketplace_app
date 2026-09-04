import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/api_config.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/menu_data.dart';
import '../../data/models/product.dart';
import '../../data/models/restaurant.dart';
import '../../widgets/app_header.dart';
import '../../widgets/app_bottom_nav.dart';
import '../../widgets/matrix_loader.dart';
import '../../widgets/product_card.dart';
import '../../widgets/restaurant_header.dart';
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
        loading: () => const MatrixLoader(),
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
        data: (d) => _MenuBody(profile: d.profile, menu: d.menu),
      ),
    );
  }
}

class _MenuBody extends ConsumerStatefulWidget {
  final Restaurant profile;
  final MenuData menu;
  const _MenuBody({required this.profile, required this.menu});

  @override
  ConsumerState<_MenuBody> createState() => _MenuBodyState();
}

class _MenuBodyState extends ConsumerState<_MenuBody> {
  String _query = '';
  String _selectedCategory = 'all';

  List<Product> get _filtered {
    final q = _query.trim().toLowerCase();
    var list = widget.menu.products;
    if (_selectedCategory != 'all') {
      list = widget.menu.productsIn(_selectedCategory);
    }
    if (q.isNotEmpty) {
      list = list
          .where((p) =>
              p.name.toLowerCase().contains(q) ||
              (p.description?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    return list;
  }

  int _countFor(String id) =>
      id == 'all' ? widget.menu.products.length : widget.menu.productsIn(id).length;

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final showSections = _query.trim().isEmpty && _selectedCategory == 'all';
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: RestaurantHeader(restaurant: widget.profile)),
        SliverPersistentHeader(
          pinned: true,
          delegate: _SearchHeader(
            query: _query,
            onQuery: (v) => setState(() => _query = v),
            pills: _Pills(
              categories: widget.menu.categories,
              selected: _selectedCategory,
              countFor: _countFor,
              onSelect: (id) => setState(() => _selectedCategory = id),
            ),
          ),
        ),
        if (!widget.profile.acceptsOnlineOrders)
          const SliverToBoxAdapter(
            child: _Notice(
                icon: '📋',
                text:
                    'Este restaurante no recibe pedidos en línea actualmente. Puedes ver el menú o contactar al restaurante.'),
          )
        else if (!widget.profile.isOpen)
          const SliverToBoxAdapter(
            child: _Notice(
                icon: '🔒',
                text:
                    'El restaurante está cerrado temporalmente. Puedes explorar el menú pero no se pueden realizar pedidos.'),
          ),
        if (filtered.isEmpty)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(_query.trim().isNotEmpty ? '🔍' : '🍽️',
                      style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 8),
                  Text(
                    _query.trim().isNotEmpty
                        ? 'No encontramos productos para «${_query.trim()}»'
                        : 'No hay productos disponibles (${ApiConfig.environment})',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          )
        else if (showSections)
          for (final cat in widget.menu.categories)
            if (widget.menu.productsIn(cat.id).isNotEmpty) ...[
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Text(cat.name.toUpperCase(),
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: AppColors.ebony500)),
                ),
              ),
              _ProductGrid(products: widget.menu.productsIn(cat.id)),
            ]
        else
          _ProductGrid(products: filtered),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<Product> products;
  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(12),
      sliver: SliverGrid.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, childAspectRatio: 0.72, crossAxisSpacing: 12, mainAxisSpacing: 12),
        itemCount: products.length,
        itemBuilder: (_, i) => ProductCard(
          product: products[i],
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ProductDetailScreen(product: products[i]))),
        ),
      ),
    );
  }
}

class _SearchHeader extends SliverPersistentHeaderDelegate {
  final String query;
  final ValueChanged<String> onQuery;
  final Widget pills;
  _SearchHeader({required this.query, required this.onQuery, required this.pills});

  @override
  double get minExtent => 128;
  @override
  double get maxExtent => 128;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: Column(
        children: [
          TextField(
            onChanged: onQuery,
            decoration: InputDecoration(
              hintText: 'Buscar en el menú…',
              prefixIcon: const Icon(Icons.search_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: pills),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _SearchHeader old) => old.query != query;
}

class _Pills extends StatelessWidget {
  final List<MenuCategory> categories;
  final String selected;
  final int Function(String) countFor;
  final ValueChanged<String> onSelect;
  const _Pills(
      {required this.categories,
      required this.selected,
      required this.countFor,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    final all = [const MenuCategory(id: 'all', name: 'Todos'), ...categories];
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: all.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, i) {
        final cat = all[i];
        final active = selected == cat.id;
        return FilledButton.tonal(
          style: FilledButton.styleFrom(
            backgroundColor: active ? AppColors.crocus600 : AppColors.titan200,
            foregroundColor: active ? Colors.white : AppColors.ebony500,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () => onSelect(cat.id),
          child: Text('${cat.name} (${countFor(cat.id)})'),
        );
      },
    );
  }
}

class _Notice extends StatelessWidget {
  final String icon;
  final String text;
  const _Notice({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red[100]!),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
          ],
        ),
      ),
    );
  }
}
