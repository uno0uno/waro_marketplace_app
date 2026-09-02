class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.warolabs.com',
  );
  static const String productsPath = '/products';
  static String productDetail(String id) => '/products/$id';
  static String waroColProductUrl(String id) => 'https://warocol.com/product/$id';
}
