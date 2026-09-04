import 'dart:convert';
import 'package:http/http.dart' as http;
import '../core/config/api_config.dart';
import 'models/product.dart';

class ApiClient {
  final http.Client _http;
  final String? authToken;
  ApiClient({http.Client? client, this.authToken}) : _http = client ?? http.Client();

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        if (authToken != null && authToken!.isNotEmpty) 'Authorization': 'Bearer $authToken',
      };

  Future<List<Product>> fetchProducts() async {
    final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productsPath}'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final list = data is List ? data : (data['data'] as List? ?? []);
      return list.map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
    }
    throw Exception('fetchProducts failed: ${res.statusCode} ${res.body}');
  }

  Future<Product> fetchProduct(String id) async {
    final res = await _http.get(Uri.parse('${ApiConfig.baseUrl}${ApiConfig.productDetail(id)}'), headers: _headers);
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final map = data is Map<String, dynamic> ? (data['data'] ?? data) : data;
      return Product.fromJson(map as Map<String, dynamic>);
    }
    throw Exception('fetchProduct failed: ${res.statusCode}');
  }
}
