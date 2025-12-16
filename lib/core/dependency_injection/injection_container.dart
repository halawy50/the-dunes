import 'package:get_it/get_it.dart';
import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/features/anylisis/data/datasources/statistics_remote_data_source.dart';
import 'package:the_dunes/features/anylisis/data/repositories/statistics_repository_impl.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_bookings_by_agency_usecase.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_dashboard_summary_usecase.dart';
import 'package:the_dunes/features/anylisis/domain/usecases/get_employees_with_vouchers_usecase.dart';
import 'package:the_dunes/features/anylisis/persentation/cubit/analysis_cubit.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/datasources/document_analysis_remote_data_source.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/document_analysis_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/pickup_time_cubit.dart';
import 'package:the_dunes/features/camp/data/datasources/camp_remote_data_source.dart';
import 'package:the_dunes/features/camp/data/repositories/camp_repository_impl.dart';
import 'package:the_dunes/features/camp/domain/repositories/camp_repository.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/cubit/new_employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_detail_cubit.dart';
import 'package:the_dunes/features/history/persentation/cubit/history_cubit.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';
import 'package:the_dunes/features/operations/persentation/cubit/operation_cubit.dart';
import 'package:the_dunes/features/login/data/datasources/login_remote_data_source.dart';
import 'package:the_dunes/features/login/data/repositories/login_repository_impl.dart';
import 'package:the_dunes/features/login/domain/repositories/login_repository.dart';
import 'package:the_dunes/features/login/domain/usecases/login_usecase.dart';
import 'package:the_dunes/features/login/persentation/cubit/login_cubit.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';
import 'package:the_dunes/features/services/persentation/cubit/service_cubit.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';
import 'package:the_dunes/features/setting/data/datasources/currency_remote_data_source.dart';
import 'package:the_dunes/features/setting/data/repositories/currency_repository_impl.dart';
import 'package:the_dunes/features/setting/domain/repositories/currency_repository.dart';
import 'package:the_dunes/features/setting/domain/usecases/get_exchange_rates_usecase.dart';
import 'package:the_dunes/features/setting/domain/usecases/update_exchange_rates_usecase.dart';
import 'package:the_dunes/features/pickup_times/data/datasources/pickup_times_remote_data_source.dart';
import 'package:the_dunes/features/pickup_times/data/repositories/pickup_times_repository_impl.dart';
import 'package:the_dunes/features/pickup_times/domain/repositories/pickup_times_repository.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/assign_vehicle_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/get_pickup_times_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/get_vehicle_groups_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/remove_assignment_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_assignment_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_booking_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_voucher_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/domain/usecases/update_pickup_time_status_usecase.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/recipt_voucher/data/datasources/receipt_voucher_remote_data_source.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/new_receipt_voucher_cubit.dart';
import 'package:the_dunes/features/agents/data/datasources/agent_remote_data_source.dart';
import 'package:the_dunes/features/agents/data/datasources/service_agent_remote_data_source.dart';
import 'package:the_dunes/features/agents/data/repositories/agent_repository_impl.dart';
import 'package:the_dunes/features/agents/domain/repositories/agent_repository.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_all_agents_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_agent_by_id_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/create_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/update_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/delete_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_agent_services_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/create_agent_service_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_service_agents_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_all_service_agents_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/get_service_agent_by_id_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/update_service_agent_usecase.dart';
import 'package:the_dunes/features/agents/domain/usecases/delete_service_agent_usecase.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_cubit.dart';
import 'package:the_dunes/features/agents/presentation/cubit/agent_detail_cubit.dart';
import 'package:the_dunes/features/employees/data/datasources/employee_remote_data_source.dart';
import 'package:the_dunes/features/employees/data/datasources/commission_remote_data_source.dart';
import 'package:the_dunes/features/employees/data/datasources/salary_remote_data_source.dart';
import 'package:the_dunes/features/employees/data/repositories/employee_repository_impl.dart';
import 'package:the_dunes/features/employees/data/repositories/commission_repository_impl.dart';
import 'package:the_dunes/features/employees/data/repositories/salary_repository_impl.dart';
import 'package:the_dunes/features/employees/domain/repositories/employee_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/commission_repository.dart';
import 'package:the_dunes/features/employees/domain/repositories/salary_repository.dart';
import 'package:the_dunes/features/employees/domain/usecases/get_employees_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/get_employee_by_id_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/create_employee_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/update_employee_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/delete_employee_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/get_employee_commissions_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/get_employee_pending_commissions_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/get_employee_salaries_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/pay_commission_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/pay_salary_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/create_salary_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/update_salary_usecase.dart';
import 'package:the_dunes/features/employees/domain/usecases/delete_salary_usecase.dart';
import 'package:the_dunes/features/hotels/data/datasources/hotel_remote_data_source.dart';
import 'package:the_dunes/features/hotels/data/repositories/hotel_repository_impl.dart';
import 'package:the_dunes/features/hotels/domain/repositories/hotel_repository.dart';
import 'package:the_dunes/features/hotels/domain/usecases/get_hotels_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/get_all_hotels_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/get_hotel_by_id_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/create_hotel_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/update_hotel_usecase.dart';
import 'package:the_dunes/features/hotels/domain/usecases/delete_hotel_usecase.dart';
import 'package:the_dunes/features/services/data/datasources/service_remote_data_source.dart';
import 'package:the_dunes/features/services/data/repositories/service_repository_impl.dart';
import 'package:the_dunes/features/services/domain/repositories/service_repository.dart';
import 'package:the_dunes/features/services/domain/usecases/get_services_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/create_service_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/update_service_usecase.dart';
import 'package:the_dunes/features/services/domain/usecases/delete_service_usecase.dart';

final di = GetIt.instance;

Future<void> init() async {
  // Reset GetIt if already initialized (for hot reload)
  if (di.isRegistered<ApiClient>()) {
    await di.reset();
  }

  // Network
  di.registerLazySingleton(() => ApiClient());

  // Data Sources
  di.registerLazySingleton<LoginRemoteDataSource>(
    () => LoginRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSource(di()),
  );
  di.registerLazySingleton<BookingOptionsRemoteDataSource>(
    () => BookingOptionsRemoteDataSource(di()),
  );
  di.registerLazySingleton<DocumentAnalysisRemoteDataSource>(
    () => DocumentAnalysisRemoteDataSource(di()),
  );
  di.registerLazySingleton<PickupTimesRemoteDataSource>(
    () => PickupTimesRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<ReceiptVoucherRemoteDataSource>(
    () => ReceiptVoucherRemoteDataSource(di()),
  );
  di.registerLazySingleton<EmployeeRemoteDataSource>(
    () => EmployeeRemoteDataSource(di()),
  );
  di.registerLazySingleton<CommissionRemoteDataSource>(
    () => CommissionRemoteDataSource(di()),
  );
  di.registerLazySingleton<SalaryRemoteDataSource>(
    () => SalaryRemoteDataSource(di()),
  );
  di.registerLazySingleton<HotelRemoteDataSource>(
    () => HotelRemoteDataSource(di()),
  );
  di.registerLazySingleton<AgentRemoteDataSource>(
    () => AgentRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<ServiceAgentRemoteDataSource>(
    () => ServiceAgentRemoteDataSourceImpl(di()),
  );
  di.registerLazySingleton<ServiceRemoteDataSource>(
    () => ServiceRemoteDataSource(di()),
  );
  di.registerLazySingleton<CurrencyRemoteDataSource>(
    () => CurrencyRemoteDataSource(di()),
  );
  di.registerLazySingleton<CampRemoteDataSource>(
    () => CampRemoteDataSource(di()),
  );
  di.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSource(di()),
  );

  // Repositories
  di.registerLazySingleton<LoginRepository>(
    () => LoginRepositoryImpl(di()),
  );
  di.registerLazySingleton<PickupTimesRepository>(
    () => PickupTimesRepositoryImpl(di()),
  );
  di.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(di()),
  );
  di.registerLazySingleton<CommissionRepository>(
    () => CommissionRepositoryImpl(di()),
  );
  di.registerLazySingleton<SalaryRepository>(
    () => SalaryRepositoryImpl(di()),
  );
  di.registerLazySingleton<HotelRepository>(
    () => HotelRepositoryImpl(di()),
  );
  di.registerLazySingleton<AgentRepository>(
    () => AgentRepositoryImpl(di(), di()),
  );
  di.registerLazySingleton<ServiceRepository>(
    () => ServiceRepositoryImpl(di()),
  );
  di.registerLazySingleton<CurrencyRepository>(
    () => CurrencyRepositoryImpl(di()),
  );
  di.registerLazySingleton<CampRepository>(
    () => CampRepositoryImpl(di()),
  );
  di.registerLazySingleton<StatisticsRepository>(
    () => StatisticsRepositoryImpl(di()),
  );

  // Use cases
  di.registerLazySingleton(() => LoginUseCase(di()));
  di.registerLazySingleton(() => GetPickupTimesUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => GetVehicleGroupsUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => AssignVehicleUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => UpdateAssignmentUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => RemoveAssignmentUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => UpdateVoucherStatusUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => UpdateBookingStatusUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => UpdatePickupTimeStatusUseCase(di<PickupTimesRepository>()));
  di.registerLazySingleton(() => GetEmployeesUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => GetEmployeeByIdUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => CreateEmployeeUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => UpdateEmployeeUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => DeleteEmployeeUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => GetEmployeeCommissionsUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => GetEmployeePendingCommissionsUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => GetEmployeeSalariesUseCase(di<EmployeeRepository>()));
  di.registerLazySingleton(() => PayCommissionUseCase(di<CommissionRepository>()));
  di.registerLazySingleton(() => PaySalaryUseCase(di<SalaryRepository>()));
  di.registerLazySingleton(() => CreateSalaryUseCase(di<SalaryRepository>()));
  di.registerLazySingleton(() => UpdateSalaryUseCase(di<SalaryRepository>()));
  di.registerLazySingleton(() => DeleteSalaryUseCase(di<SalaryRepository>()));
  di.registerLazySingleton(() => GetHotelsUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => GetAllHotelsUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => GetHotelByIdUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => CreateHotelUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => UpdateHotelUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => DeleteHotelUseCase(di<HotelRepository>()));
  di.registerLazySingleton(() => GetAllAgentsUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetAgentByIdUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => CreateAgentUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => UpdateAgentUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => DeleteAgentUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetAgentServicesUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => CreateAgentServiceUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetServiceAgentsUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetAllServiceAgentsUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetServiceAgentByIdUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => UpdateServiceAgentUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => DeleteServiceAgentUseCase(di<AgentRepository>()));
  di.registerLazySingleton(() => GetServicesUseCase(di<ServiceRepository>()));
  di.registerLazySingleton(() => CreateServiceUseCase(di<ServiceRepository>()));
  di.registerLazySingleton(() => UpdateServiceUseCase(di<ServiceRepository>()));
  di.registerLazySingleton(() => DeleteServiceUseCase(di<ServiceRepository>()));
  di.registerLazySingleton(() => GetExchangeRatesUseCase(di<CurrencyRepository>()));
  di.registerLazySingleton(() => UpdateExchangeRatesUseCase(di<CurrencyRepository>()));
  di.registerLazySingleton(() => GetDashboardSummaryUseCase(di<StatisticsRepository>()));
  di.registerLazySingleton(() => GetBookingsByAgencyUseCase(di<StatisticsRepository>()));
  di.registerLazySingleton(() => GetEmployeesWithVouchersUseCase(di<StatisticsRepository>()));

  // Cubits
  di.registerFactory(() => LoginCubit(di()));
  di.registerFactory(() => NavbarCubit());
  di.registerFactory(
    () => AnalysisCubit(
      getDashboardSummaryUseCase: di(),
      getBookingsByAgencyUseCase: di(),
      getEmployeesWithVouchersUseCase: di(),
    ),
  );
  di.registerFactory(() => BookingCubit(di<BookingRemoteDataSource>()));
  di.registerFactory(
    () => NewBookingCubit(
      di<BookingOptionsRemoteDataSource>(),
      di<BookingRemoteDataSource>(),
    ),
  );
  di.registerFactory(
    () => DocumentAnalysisCubit(
      di<DocumentAnalysisRemoteDataSource>(),
      di<BookingRemoteDataSource>(),
    ),
  );
  di.registerFactory(() => PickupTimeCubit());
  di.registerFactory(() => ReceiptVoucherCubit(di<ReceiptVoucherRemoteDataSource>()));
  di.registerFactory(
    () => NewReceiptVoucherCubit(
      di<ReceiptVoucherRemoteDataSource>(),
      di<BookingOptionsRemoteDataSource>(),
    ),
  );
  di.registerFactory(
    () => EmployeeCubit(
      employeeRepository: di<EmployeeRepository>(),
      commissionRepository: di<CommissionRepository>(),
      salaryRepository: di<SalaryRepository>(),
    ),
  );
  di.registerFactory(
    () => NewEmployeeCubit(di<EmployeeRepository>()),
  );
  di.registerFactory(
    () => EmployeeDetailCubit(
      employeeRepository: di<EmployeeRepository>(),
      commissionRepository: di<CommissionRepository>(),
      salaryRepository: di<SalaryRepository>(),
    ),
  );
  di.registerFactory(
    () => ServiceCubit(
      getServicesUseCase: di(),
      createServiceUseCase: di(),
      updateServiceUseCase: di(),
      deleteServiceUseCase: di(),
    ),
  );
  di.registerFactory(
    () => HotelCubit(
      getHotelsUseCase: di(),
      createHotelUseCase: di(),
      updateHotelUseCase: di(),
      deleteHotelUseCase: di(),
    ),
  );
  di.registerFactory(() => OperationCubit());
  di.registerFactory(() => CampCubit(di()));
  di.registerFactory(() => HistoryCubit());
  di.registerFactory(() => SettingCubit(
        getExchangeRatesUseCase: di(),
        updateExchangeRatesUseCase: di(),
      ));
  di.registerFactory(() => PickupTimesCubit(
        getPickupTimesUseCase: di(),
        getVehicleGroupsUseCase: di(),
        assignVehicleUseCase: di(),
        updateAssignmentUseCase: di(),
        removeAssignmentUseCase: di(),
        updateVoucherStatusUseCase: di(),
        updateBookingStatusUseCase: di(),
        updatePickupTimeStatusUseCase: di(),
      ));
  di.registerFactory(
    () => AgentCubit(
      getAllAgentsUseCase: di(),
      createAgentUseCase: di(),
      updateAgentUseCase: di(),
      deleteAgentUseCase: di(),
    ),
  );
  di.registerFactory(
    () => AgentDetailCubit(
      getAgentByIdUseCase: di(),
      getAgentServicesUseCase: di(),
      createAgentServiceUseCase: di(),
      updateServiceAgentUseCase: di(),
      deleteServiceAgentUseCase: di(),
      updateAgentUseCase: di(),
      deleteAgentUseCase: di(),
    ),
  );
}
