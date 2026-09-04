class Product {
  final String id;
  final String name;
  final String? description;
  final double price;
  final String? imageUrl;
  final String? tenantName;
  final List<ModifierGroup> modifierGroups;
  final bool hasModifiers;
  final bool isAvailable;
  final int? preparationTime;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    this.imageUrl,
    this.tenantName,
    this.modifierGroups = const [],
    this.hasModifiers = false,
    this.isAvailable = true,
    this.preparationTime,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
        id: j['id'].toString(),
        name: j['name'] ?? '',
        description: j['description'],
        price: (j['price'] as num?)?.toDouble() ?? 0,
        imageUrl: j['image_url'] ?? j['imageUrl'],
        tenantName: j['tenant_name'] ?? j['tenantName'],
        modifierGroups: (j['modifier_groups'] as List?)
                ?.map((e) => ModifierGroup.fromJson(e))
                .toList() ??
            [],
        hasModifiers: j['has_modifiers'] == true || (j['modifier_groups'] as List?)?.isNotEmpty == true,
        isAvailable: j['is_available'] != false && j['isAvailable'] != false,
        preparationTime: (j['preparation_time'] ?? j['preparationTime']) as int?,
      );

  static List<Product> mock() => [
        Product(id: '1', name: 'Bandeja Paisa', price: 28000, tenantName: 'Restaurante Demo', description: 'Clásico paisa'),
        Product(id: '2', name: 'Hamburguesa WARO', price: 22000, tenantName: 'Waro Labs'),
        Product(id: '3', name: 'Café Especial', price: 8500, tenantName: 'Café Central'),
      ];
}

class ModifierGroup {
  final String name;
  final List<Modifier> modifiers;
  ModifierGroup({required this.name, this.modifiers = const []});
  factory ModifierGroup.fromJson(Map<String, dynamic> j) => ModifierGroup(
        name: j['name'] ?? '',
        modifiers: (j['modifiers'] as List?)?.map((e) => Modifier.fromJson(e)).toList() ?? [],
      );
}

class Modifier {
  final String name;
  final double extraPrice;
  Modifier({required this.name, this.extraPrice = 0});
  factory Modifier.fromJson(Map<String, dynamic> j) => Modifier(
        name: j['name'] ?? '',
        extraPrice: (j['extra_price'] as num?)?.toDouble() ?? 0,
      );
}
