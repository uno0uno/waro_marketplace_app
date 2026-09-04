class City {
  final String name;
  final String slug;
  final String? countryCode;

  City({required this.name, required this.slug, this.countryCode});

  factory City.fromJson(Map<String, dynamic> j) => City(
        name: j['city'] ?? j['name'] ?? '',
        slug: j['city_slug'] ?? j['slug'] ?? '',
        countryCode: j['country_code'],
      );
}
