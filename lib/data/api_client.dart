import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import 'models/catalog.dart';
import 'models/product.dart';

class ApiClient {
  final http.Client _http;
  ApiClient({http.Client? client}) : _http = client ?? http.Client();

  Future<List<City>> fetchCities() async {
    final res = await _http.get(
      Uri.parse('${ApiConfig.baseUrl}/public/restaurant/cities'),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => City.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('fetchCities failed: ${res.statusCode}');
  }

  Future<List<Tenant>> fetchTenants({String? citySlug}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}/public/restaurant/list')
        .replace(queryParameters: citySlug != null ? {'city_slug': citySlug} : {});
    final res = await _http.get(uri);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => Tenant.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('fetchTenants failed: ${res.statusCode}');
  }

  Future<Tenant> fetchTenantProfile(String slug) async {
    final res = await _http.get(
      Uri.parse('${ApiConfig.baseUrl}/public/restaurant/$slug'),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final map = data is Map<String, dynamic> ? (data['data'] ?? data) : data;
      return Tenant.fromJson(map as Map<String, dynamic>);
    }
    throw Exception('fetchTenantProfile failed: ${res.statusCode}');
  }

  Future<List<Product>> fetchTenantMenu(String slug) async {
    final res = await _http.get(
      Uri.parse('${ApiConfig.baseUrl}/public/restaurant/$slug/menu'),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final payload = data is Map<String, dynamic> ? (data['data'] ?? data) : data;
      final list = payload is List
          ? payload
          : ((payload as Map<String, dynamic>)['items'] as List? ?? []);
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('fetchTenantMenu failed: ${res.statusCode}');
  }

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

  Future<Product?> fetchProduct(String id) async {
    try {
      final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productDetail(id)}'));
      if (res.statusCode == 200) return Product.fromJson(jsonDecode(res.body));
    } catch (_) {}
    return Product.mock().firstWhere((p) => p.id == id, orElse: () => Product.mock().first);
  }
}
