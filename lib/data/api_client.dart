import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import 'models/city.dart';
import 'models/product.dart';
import 'models/restaurant.dart';

class ApiClient {
  final http.Client _http;
  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  Future<List<Product>> fetchProducts() async {
    try {
      final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productsPath}'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final list = data is List ? data : (data['data'] as List? ?? []);
        return list.map((e) => Product.fromJson(e)).toList();
      }
    } catch (_) {}
    return Product.mock();
  }

  Future<List<City>> fetchCities({String countryCode = 'CO', bool includeEmpty = false}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.citiesPath}').replace(queryParameters: {
      'country_code': countryCode,
      'include_empty': includeEmpty ? 'true' : 'false',
    });
    final res = await _http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Ciudades (${ApiConfig.environment}): HTTP ${res.statusCode}');
  }

  Future<List<Restaurant>> fetchRestaurants(String citySlug) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.restaurantsPath}')
        .replace(queryParameters: {'city_slug': citySlug});
    final res = await _http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => Restaurant.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('Restaurantes (${ApiConfig.environment}): HTTP ${res.statusCode}');
  }

  Future<Product?> fetchProduct(String id) async {
    try {
      final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productDetail(id)}'));
      if (res.statusCode == 200) return Product.fromJson(jsonDecode(res.body));
    } catch (_) {}
    return Product.mock().firstWhere((p) => p.id == id, orElse: () => Product.mock().first);
  }
}
