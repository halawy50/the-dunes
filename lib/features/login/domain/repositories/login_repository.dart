import 'package:the_dunes/features/login/domain/entities/user_entity.dart';

abstract class LoginRepository {
  Future<UserEntity> login(String email, String password);
  Future<void> logout();
  Future<UserEntity?> getCurrentUser();
}
