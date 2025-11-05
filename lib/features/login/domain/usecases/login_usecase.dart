import 'package:the_dunes/features/login/domain/entities/user_entity.dart';
import 'package:the_dunes/features/login/domain/repositories/login_repository.dart';

class LoginUseCase {
  final LoginRepository repository;

  LoginUseCase(this.repository);

  Future<UserEntity> call(String email, String password) {
    return repository.login(email, password);
  }
}
