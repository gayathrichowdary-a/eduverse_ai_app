import '../domain/auth_models.dart';
import '../domain/auth_repository.dart';

class LocalAuthRepository implements AuthRepository {
  @override
  Future<AuthResult> signIn({
    required String identifier,
    required String password,
    required UserRole role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> signUp({
    required AuthProfile profile,
    required String password,
    required UserRole role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> requestSignupOtp({
    required String identifier,
    required UserRole role,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> verifySignupOtp({
    required String identifier,
    required String otp,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<AuthResult> sendPasswordReset({
    required String identifier,
  }) async {
    throw UnimplementedError();
  }
}