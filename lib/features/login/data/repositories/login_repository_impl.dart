import 'package:the_dunes/core/data/datasources/token_storage.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart'
    as di;
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/login/data/datasources/login_remote_data_source.dart';
import 'package:the_dunes/features/login/data/models/user_model.dart';
import 'package:the_dunes/features/login/domain/entities/user_entity.dart';
import 'package:the_dunes/features/login/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginRemoteDataSource remoteDataSource;

  LoginRepositoryImpl(this.remoteDataSource);

  @override
  Future<UserEntity> login(String email, String password) async {
    try {
      final response = await remoteDataSource.login(email, password);

      if (response.success && response.data != null) {
        await TokenStorage.saveToken(response.data!.token);
        
        if (response.data!.employee.permissions != null) {
          await TokenStorage.savePermissions(
            response.data!.employee.permissions!,
          );
        }
        
        await TokenStorage.saveUserData({
          'id': response.data!.employee.id,
          'name': response.data!.employee.name,
          'email': response.data!.employee.email,
          'image': response.data!.employee.image,
        });
        
        final userModel = UserModel.fromEmployeeData(response.data!.employee);
        return userModel;
      } else {
        throw ApiException(
          message: response.message,
          error: response.error,
          statusCode: 400,
        );
      }
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: e.toString(),
        statusCode: 500,
      );
    }
  }

  @override
  Future<void> logout() async {
    await TokenStorage.deleteToken();
    di.di<ApiClient>().setToken(null);
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final token = await TokenStorage.getToken();
    if (token == null) return null;
    
    final userData = await TokenStorage.getUserData();
    if (userData == null) return null;
    
    return UserModel(
      id: userData['id'].toString(),
      email: userData['email'] ?? '',
      name: userData['name'],
      image: userData['image'],
    );
  }
}
