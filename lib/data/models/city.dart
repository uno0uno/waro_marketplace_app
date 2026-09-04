class City {
  final String name;
  final String slug;
  final String? countryCode;
  final int tenantCount;

  City({required this.name, required this.slug, this.countryCode, this.tenantCount = 0});

  factory City.fromJson(Map<String, dynamic> j) => City(
        name: j['city'] ?? j['name'] ?? '',
        slug: j['city_slug'] ?? j['slug'] ?? '',
        countryCode: j['country_code'],
        tenantCount: (j['tenant_count'] as num?)?.toInt() ?? 0,
      );
}
