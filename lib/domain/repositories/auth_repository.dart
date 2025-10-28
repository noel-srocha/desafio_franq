abstract class AuthRepository {
  Future<String> login({required String username, required String password});
  Future<void> logout();
  Future<String?> getToken();
  Future<void> saveToken(String token);
}