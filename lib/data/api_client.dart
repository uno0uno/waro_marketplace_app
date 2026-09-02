import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import 'models/product.dart';

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

  Future<Product?> fetchProduct(String id) async {
    try {
      final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productDetail(id)}'));
      if (res.statusCode == 200) return Product.fromJson(jsonDecode(res.body));
    } catch (_) {}
    return Product.mock().firstWhere((p) => p.id == id, orElse: () => Product.mock().first);
  }
}
