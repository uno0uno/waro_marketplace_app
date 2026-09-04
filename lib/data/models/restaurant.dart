class Restaurant {
  final String slug;
  final String displayName;
  final String? logoUrl;
  final bool isOpen;

  Restaurant({required this.slug, required this.displayName, this.logoUrl, this.isOpen = false});

  factory Restaurant.fromJson(Map<String, dynamic> j) => Restaurant(
        slug: j['slug'] ?? j['city_slug'] ?? '',
        displayName: j['display_name'] ?? j['name'] ?? '',
        logoUrl: j['logo_url'] ?? j['logoUrl'],
        isOpen: j['is_currently_open'] ?? j['isOpen'] ?? false,
      );
}
