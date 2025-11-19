import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/app_router/app_router.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';

class AppRouterErrorBuilder {
  static Widget buildError(BuildContext context, GoRouterState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final token = await TokenStorage.getToken();
      if (context.mounted) {
        if (token != null) {
          context.go(AppRouter.home);
        } else {
          context.go(AppRouter.login);
        }
      }
    });
    
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

