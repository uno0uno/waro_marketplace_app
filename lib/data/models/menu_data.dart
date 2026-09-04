import 'product.dart';

class MenuCategory {
  final String id;
  final String name;
  final String? description;

  MenuCategory({required this.id, required this.name, this.description});

  factory MenuCategory.fromJson(Map<String, dynamic> j) => MenuCategory(
        id: j['id'].toString(),
        name: j['name'] ?? '',
        description: j['description'],
      );
}

class MenuData {
  final String? restaurantName;
  final List<MenuCategory> categories;
  final List<Product> products;
  final Map<String, String> _productCategory;

  MenuData({
    this.restaurantName,
    this.categories = const [],
    this.products = const [],
    Map<String, String> productCategory = const {},
  }) : _productCategory = productCategory;

  factory MenuData.fromJson(Map<String, dynamic> j) {
    final raw = (j['products'] as List? ?? []).cast<Map<String, dynamic>>();
    final catByProduct = <String, String>{};
    for (final p in raw) {
      final id = p['id']?.toString();
      if (id != null) catByProduct[id] = p['category_id']?.toString() ?? '';
    }
    return MenuData(
      restaurantName: j['restaurant_name'],
      categories: (j['categories'] as List?)
              ?.map((e) => MenuCategory.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      products: raw.map(Product.fromJson).toList(),
      productCategory: catByProduct,
    );
  }

  List<Product> productsIn(String categoryId) =>
      products.where((p) => (_productCategory[p.id] ?? '') == categoryId).toList();

  List<Product> get uncategorized =>
      products.where((p) => (_productCategory[p.id] ?? '').isEmpty).toList();
}
