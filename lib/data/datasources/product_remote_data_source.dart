import 'package:desafio_franq/core/constants/api_endpoints.dart';
import 'package:desafio_franq/core/error/exceptions.dart';
import 'package:desafio_franq/core/network/dio_client.dart';
import 'package:desafio_franq/data/models/product_model.dart';
import 'package:dio/dio.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> fetchAllProducts();
  Future<List<String>> fetchCategories();
  Future<List<ProductModel>> fetchProductsByCategory(String category);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio _dio = DioClient().dio;

  @override
  Future<List<ProductModel>> fetchAllProducts() async {
    try {
      final res = await _dio.get(ApiEndpoints.products);
      final data = res.data as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro ao buscar produtos', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<String>> fetchCategories() async {
    try {
      final res = await _dio.get(ApiEndpoints.categories);
      final data = res.data as List<dynamic>;
      return data.map((e) => e.toString()).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro ao buscar categorias', statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<ProductModel>> fetchProductsByCategory(String category) async {
    try {
      final res = await _dio.get(ApiEndpoints.productsByCategory(category));
      final data = res.data as List<dynamic>;
      return data.map((e) => ProductModel.fromJson(e as Map<String, dynamic>)).toList();
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro ao buscar produtos por categoria', statusCode: e.response?.statusCode);
    }
  }
}
