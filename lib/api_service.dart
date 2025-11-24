import 'package:dio/dio.dart';
import 'models.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://dummyjson.com'));

  Future<List<String>> fetchCategories() async {
    final res = await _dio.get('/products/categories');
    if (res.statusCode == 200) {
      final data = res.data as List;
      return data.map((e) => e.toString()).toList();
    }
    return [];
  }

  Future<List<Product>> fetchProducts({String? category}) async {
    final path = category == null ? '/products' : '/products/category/$category';
    final res = await _dio.get(path);
    if (res.statusCode == 200) {
      final data = res.data;
      // /products returns { products: [ ... ], total: ... }
      final productsList = (data['products'] ?? data) as List;
      return productsList.map((p) => Product.fromJson(p)).toList();
    }
    return [];
  }

  Future<Product> fetchProductById(int id) async {
    final res = await _dio.get('/products/$id');
    if (res.statusCode == 200) {
      return Product.fromJson(res.data);
    }
    throw Exception('Failed to load product');
  }
}
