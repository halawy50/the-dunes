import 'package:get_it/get_it.dart';
import 'package:the_dunes/features/login/data/repositories/login_repository_impl.dart';
import 'package:the_dunes/features/login/domain/repositories/login_repository.dart';
import 'package:the_dunes/features/login/domain/usecases/login_usecase.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Features - Login
  // Cubit
  sl.registerFactory(
    () => LoginCubit(
      sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Repository
  sl.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(),
  );

  // TODO: Add data sources when you implement them
  // sl.registerLazySingleton<LoginRemoteDataSource>(
  //   () => LoginRemoteDataSourceImpl(client: sl()),
  // );
  //
  // sl.registerLazySingleton<LoginLocalDataSource>(
  //   () => LoginLocalDataSourceImpl(sharedPreferences: sl()),
  // );

  // Core - External
  // TODO: Add external dependencies (SharedPreferences, etc.)
  // final sharedPreferences = await SharedPreferences.getInstance();
  // sl.registerLazySingleton(() => sharedPreferences);
}
