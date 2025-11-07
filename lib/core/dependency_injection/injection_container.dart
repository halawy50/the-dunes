import 'package:get_it/get_it.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/pickup_time_cubit.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/history/persentation/cubit/history_cubit.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';
import 'package:the_dunes/features/login/data/repositories/login_repository_impl.dart';
import 'package:the_dunes/features/login/domain/repositories/login_repository.dart';
import 'package:the_dunes/features/login/domain/usecases/login_usecase.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';
import 'package:the_dunes/features/services/persentation/cubit/service_cubit.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';

final di = GetIt.instance;

Future<void> init() async {
  di.registerFactory(() => LoginCubit(di()));

  di.registerFactory(() => NavbarCubit());
  di.registerFactory(() => AnalysisCubit());
  di.registerFactory(() => BookingCubit());
  di.registerFactory(() => PickupTimeCubit());
  di.registerFactory(() => ReceiptVoucherCubit());
  di.registerFactory(() => EmployeeCubit());
  di.registerFactory(() => ServiceCubit());
  di.registerFactory(() => HotelCubit());
  di.registerFactory(() => HistoryCubit());
  di.registerFactory(() => SettingCubit());

  // Use cases
  di.registerLazySingleton(() => LoginUseCase(di()));

  // Repository
  di.registerLazySingleton<LoginRepository>(() => LoginRepositoryImpl());
}
