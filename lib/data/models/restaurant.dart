class Restaurant {
  final String slug;
  final String displayName;
  final String? description;
  final String? logoUrl;
  final String? bannerUrl;
  final String? neighborhood;
  final String? address;
  final String? phoneNumber;
  final bool isOpen;

  Restaurant({
    required this.slug,
    required this.displayName,
    this.description,
    this.logoUrl,
    this.bannerUrl,
    this.neighborhood,
    this.address,
    this.phoneNumber,
    this.isOpen = false,
  });

  /// Paridad front_nuxt (DirectoryView isOrderable): la apertura la define
  /// `public_ordering_status == 'open'`; `is_currently_open` es el fallback.
  factory Restaurant.fromJson(Map<String, dynamic> j) {
    final status = j['public_ordering_status'];
    return Restaurant(
      slug: j['slug'] ?? j['city_slug'] ?? '',
      displayName: j['display_name'] ?? j['name'] ?? '',
      description: j['description'],
      logoUrl: j['logo_url'] ?? j['logoUrl'],
      bannerUrl: j['banner_url'] ?? j['bannerUrl'],
      neighborhood: j['neighborhood'],
      address: j['address'],
      phoneNumber: j['phone_number'] ?? j['phoneNumber'],
      isOpen: status != null ? status == 'open' : (j['is_currently_open'] ?? j['isOpen'] ?? false),
    );
  }
}
