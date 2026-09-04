class City {
  final String slug;
  final String name;

  const City({required this.slug, required this.name});

  factory City.fromJson(Map<String, dynamic> j) => City(
        slug: (j['city_slug'] ?? j['slug'] ?? '').toString(),
        name: (j['city'] ?? j['name'] ?? '').toString(),
      );
}

class Tenant {
  final String slug;
  final String displayName;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final String? citySlug;
  final bool isOpen;

  const Tenant({
    required this.slug,
    required this.displayName,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.citySlug,
    this.isOpen = true,
  });

  factory Tenant.fromJson(Map<String, dynamic> j) => Tenant(
        slug: (j['tenant_slug'] ?? j['slug'] ?? '').toString(),
        displayName: (j['display_name'] ?? j['name'] ?? '').toString(),
        description: j['description'] as String?,
        logoUrl: j['logo_url'] as String?,
        bannerUrl: j['banner_url'] as String?,
        citySlug: j['city_slug'] as String?,
        isOpen: j['is_open'] != false && j['is_currently_open'] != false,
      );
}
