class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.warolabs.com',
  );

  /// Etiqueta del entorno activo (para mostrar en errores/logs).
  static String get environment =>
      baseUrl.contains('localhost') || baseUrl.contains('127.0.0.1')
          ? 'local'
          : 'prod';
  static const String productsPath = '/products';
  static const String citiesPath = '/public/restaurant/cities';
  static String productDetail(String id) => '/products/$id';
  static String waroColProductUrl(String id) => 'https://warocol.com/product/$id';
}
