import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user.dart';
import '../datasources/auth_remote_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<User> login(String email, String password) async {
    print('AuthRepositoryImpl - Iniciando login');
    final token = await remoteDataSource.login(email, password);
    print('AuthRepositoryImpl - Token recibido del datasource: $token');
    return User(token: token);
  }

  @override
  Future<void> register(String email, String password) {
  return remoteDataSource.register(email, password);
    }
}


