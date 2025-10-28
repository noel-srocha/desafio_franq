import 'package:desafio_franq/core/constants/api_endpoints.dart';
import 'package:desafio_franq/core/error/exceptions.dart';
import 'package:desafio_franq/core/network/dio_client.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<String> login({required String username, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio _dio = DioClient().dio;

  @override
  Future<String> login({required String username, required String password}) async {
    try {
      final res = await _dio.post(
        ApiEndpoints.login,
        data: {
          'username': username,
          'password': password,
        },
      );
      final token = res.data['token'] as String?;
      if (token == null || token.isEmpty) {
        throw ServerException('Token inválido');
      }
      return token;
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Erro de autenticação', statusCode: e.response?.statusCode);
    }
  }
}
