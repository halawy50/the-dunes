import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/login/domain/entities/user_entity.dart';
import 'package:the_dunes/features/login/domain/usecases/login_usecase.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase loginUseCase;

  LoginCubit(this.loginUseCase) : super(LoginInitial());

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> login(String email, String password) async {
    if (kDebugMode) {
      print('[LoginCubit] Login process started');
      print('[LoginCubit] Email: ${email.isNotEmpty ? '${email.substring(0, email.indexOf('@') > 0 ? email.indexOf('@') : email.length)}@***' : 'empty'}');
      print('[LoginCubit] Password length: ${password.length}');
    }

    // Validate empty fields
    if (email.isEmpty || password.isEmpty) {
      if (kDebugMode) print('[LoginCubit] ❌ Validation failed: Empty fields');
      emit(LoginError('login.fill_all_fields'));
      return;
    }

    // Validate email format
    if (!_isValidEmail(email)) {
      if (kDebugMode) print('[LoginCubit] ❌ Validation failed: Invalid email format');
      emit(LoginError('login.email_invalid'));
      return;
    }

    // Validate password length (minimum 6 characters)
    if (password.length < 6) {
      if (kDebugMode) print('[LoginCubit] ❌ Validation failed: Password too short (${password.length} < 6)');
      emit(LoginError('login.password_min_length'));
      return;
    }

    if (kDebugMode) print('[LoginCubit] ✅ Validation passed, starting login API call...');
    emit(LoginLoading());
    
    try {
      final user = await loginUseCase(email, password);
      if (kDebugMode) {
        print('[LoginCubit] ✅ Login successful');
        print('[LoginCubit] User ID: ${user.id}');
        print('[LoginCubit] User Email: ${user.email}');
        if (user.name != null) print('[LoginCubit] User Name: ${user.name}');
      }
      emit(LoginSuccess(user));
    } catch (e) {
      if (kDebugMode) {
        print('[LoginCubit] ❌ Login failed with error: $e');
        print('[LoginCubit] Error type: ${e.runtimeType}');
      }
      emit(LoginError(e.toString()));
    }
  }

  void reset() {
    if (kDebugMode) print('[LoginCubit] State reset');
    emit(LoginInitial());
  }
}
