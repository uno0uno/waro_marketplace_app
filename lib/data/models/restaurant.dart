class DayHours {
  final String open;
  final String close;
  final bool closed;
  DayHours({required this.open, required this.close, this.closed = false});

  factory DayHours.fromJson(Map<String, dynamic> j) => DayHours(
        open: j['open']?.toString() ?? '',
        close: j['close']?.toString() ?? '',
        closed: j['closed'] ?? false,
      );
}

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
  final String? orderingLabel;
  final bool acceptsOnlineOrders;
  final Map<String, DayHours> businessHours;
  final Map<String, String> socialMedia;

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
    this.orderingLabel,
    this.acceptsOnlineOrders = true,
    this.businessHours = const {},
    this.socialMedia = const {},
  });

  /// Paridad front_nuxt (DirectoryView isOrderable): la apertura la define
  /// `public_ordering_status == 'open'`; `is_currently_open` es el fallback.
  factory Restaurant.fromJson(Map<String, dynamic> j) {
    final status = j['public_ordering_status'];
    final hours = <String, DayHours>{};
    final rawHours = j['business_hours'];
    if (rawHours is Map) {
      rawHours.forEach((k, v) {
        if (v is Map<String, dynamic>) hours[k.toString()] = DayHours.fromJson(v);
      });
    }
    final social = <String, String>{};
    final rawSocial = j['social_media'];
    if (rawSocial is Map) {
      rawSocial.forEach((k, v) {
        if (v != null && v.toString().isNotEmpty) social[k.toString()] = v.toString();
      });
    }
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
      orderingLabel: j['public_ordering_label']?.toString(),
      acceptsOnlineOrders: j['accepts_online_orders'] ?? true,
      businessHours: hours,
      socialMedia: social,
    );
  }
}
