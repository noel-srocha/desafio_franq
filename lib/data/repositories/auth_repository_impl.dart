import 'package:desafio_franq/data/datasources/auth_local_data_source.dart';
import 'package:desafio_franq/data/datasources/auth_remote_data_source.dart';
import 'package:desafio_franq/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  final AuthLocalDataSource local;

  AuthRepositoryImpl({required this.remote, required this.local});

  @override
  Future<String?> getToken() => local.getToken();

  @override
  Future<String> login({required String username, required String password}) async {
    final token = await remote.login(username: username, password: password);
    await local.saveToken(token);
    return token;
  }

  @override
  Future<void> logout() async {
    await local.clearToken();
  }

  @override
  Future<void> saveToken(String token) async {
    await local.saveToken(token);
  }
}
