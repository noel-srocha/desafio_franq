class ApiEndpoints {
  static const String baseUrl = 'https://fakestoreapi.com';

  // Auth
  static const String login = '/auth/login';

  // Products
  static const String products = '/products';
  static const String product = '/products/'; // + id
  static const String categories = '/products/categories';
  static String productsByCategory(String category) => '/products/category/$category';
}
