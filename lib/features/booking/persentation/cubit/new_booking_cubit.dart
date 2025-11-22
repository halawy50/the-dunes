import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/models/driver_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_agent_model.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row_converter.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

part 'new_booking_state.dart';

class NewBookingCubit extends Cubit<NewBookingState> {
  final BookingOptionsRemoteDataSource optionsDataSource;
  final BookingRemoteDataSource bookingDataSource;

  NewBookingCubit(
    this.optionsDataSource,
    this.bookingDataSource,
  ) : super(NewBookingInitial());

  List<NewBookingRow> _bookingRows = [];
  List<LocationModel> _locations = [];
  List<AgentModel> _agents = [];
  List<DriverModel> _drivers = [];
  List<HotelModel> _hotels = [];
  Map<String, List<ServiceAgentModel>> _servicesByAgentLocation = {};

  List<NewBookingRow> get bookingRows => _bookingRows;
  List<LocationModel> get locations => _locations;
  List<AgentModel> get agents => _agents;
  List<DriverModel> get drivers => _drivers;
  List<HotelModel> get hotels => _hotels;

  Future<void> init() async {
    emit(NewBookingLoading());
    
    // Initialize with empty lists to ensure page works even if some endpoints fail
    _locations = [];
    _agents = [];
    _drivers = [];
    _hotels = [];
    final initialRow = NewBookingRow(guestName: '');
    // Add one empty service row by default
    initialRow.services.add(NewBookingService());
    _bookingRows = [initialRow];
    
    // Fetch all options independently - if one fails, others still work
    // This ensures the page remains functional even if some endpoints return errors
    final futures = [
      _fetchLocationsSafely(),
      _fetchAgentsSafely(),
      _fetchDriversSafely(),
      _fetchHotelsSafely(),
    ];
    
    // Wait for all to complete (even if some fail)
    await Future.wait(futures);
    
    print('[NewBookingCubit] ✅ Loaded ${_locations.length} locations');
    print('[NewBookingCubit] ✅ Loaded ${_agents.length} agents');
    print('[NewBookingCubit] ✅ Loaded ${_drivers.length} drivers');
    print('[NewBookingCubit] ✅ Loaded ${_hotels.length} hotels');
    
    // Auto-select first agent and location for initial row to get services
    if (_bookingRows.isNotEmpty && _agents.isNotEmpty && _locations.isNotEmpty) {
      final row = _bookingRows[0];
      row.agent = _agents.first;
      row.location = _locations.first;
      
      // Fetch services automatically
      try {
        final services = await getServicesForAgentAndLocation(
          row.agent!.id,
          row.location!.id,
        );
        print('[NewBookingCubit] ✅ Auto-fetched ${services.length} services for initial row');
      } catch (e) {
        print('[NewBookingCubit] ⚠️ Failed to auto-fetch services: $e');
      }
    }
    
    // Always emit loaded state - page should work even if some data is missing
    emit(NewBookingLoaded());
  }
  
  Future<void> _fetchLocationsSafely() async {
    try {
      _locations = await optionsDataSource.getAllLocations();
    } catch (e) {
      print('[NewBookingCubit] ⚠️ Failed to load locations: $e');
      _locations = []; // Keep empty list, page will still work
    }
  }
  
  Future<void> _fetchAgentsSafely() async {
    try {
      _agents = await optionsDataSource.getAllAgents();
    } catch (e) {
      print('[NewBookingCubit] ⚠️ Failed to load agents: $e');
      _agents = []; // Keep empty list, page will still work
    }
  }
  
  Future<void> _fetchDriversSafely() async {
    try {
      _drivers = await optionsDataSource.getDrivers();
    } catch (e) {
      print('[NewBookingCubit] ⚠️ Failed to load drivers: $e');
      _drivers = []; // Keep empty list, page will still work
    }
  }
  
  Future<void> _fetchHotelsSafely() async {
    try {
      _hotels = await optionsDataSource.getHotels();
    } catch (e) {
      print('[NewBookingCubit] ⚠️ Failed to load hotels: $e');
      _hotels = []; // Keep empty list, page will still work
    }
  }

  // Get services from cache immediately (for real-time UI updates)
  List<ServiceAgentModel> getServicesFromCache(int agentId, int? locationId) {
    final key = locationId != null ? '$agentId-$locationId' : '$agentId-no-location';
    final services = _servicesByAgentLocation[key] ?? [];
    // Removed verbose logging for performance
    return services;
  }

  Future<List<ServiceAgentModel>> getServicesForAgentAndLocation(
    int agentId,
    int locationId,
  ) async {
    final key = '$agentId-$locationId';
    
    // Check if services are already cached
    if (_servicesByAgentLocation.containsKey(key)) {
      print('[NewBookingCubit] ✅ Using cached services for $key');
      return _servicesByAgentLocation[key]!;
    }
    
    // Emit loading state before fetching
    emit(NewBookingServicesLoading(agentId: agentId, locationId: locationId));
    
    // Fetch fresh data if not cached
    try {
      print('[NewBookingCubit] 🔄 Fetching services for agent: $agentId, location: $locationId');
      final services = await optionsDataSource.getServicesByAgentAndLocation(
        agentId: agentId,
        locationId: locationId,
      );
      
      // Cache the result
      _servicesByAgentLocation[key] = services;
      print('[NewBookingCubit] ✅ Cached ${services.length} services for $key');
      
      // Print each service being cached
      for (int i = 0; i < services.length; i++) {
        print('[NewBookingCubit] ✅ Caching Service $i: ID=${services[i].id}, Name="${services[i].serviceName}", AdultPrice=${services[i].adultPrice}');
      }
      
      // Emit loaded state to trigger UI rebuild - this will update all service dropdowns in real-time
      emit(NewBookingLoaded());
      
      return services;
    } catch (e) {
      print('[NewBookingCubit] ❌ Error fetching services: $e');
      // Emit loaded state even on error so UI can show error message
      emit(NewBookingLoaded());
      return [];
    }
  }

  Future<List<ServiceAgentModel>> getServicesForAgentOnly(int agentId) async {
    final key = '$agentId-no-location';
    
    // Check if services are already cached
    if (_servicesByAgentLocation.containsKey(key)) {
      print('[NewBookingCubit] ✅ Using cached services for agent $agentId (no location)');
      return _servicesByAgentLocation[key]!;
    }
    
    // Emit loading state before fetching
    emit(NewBookingServicesLoading(agentId: agentId, locationId: null));
    
    // Fetch fresh data if not cached
    try {
      print('[NewBookingCubit] 🔄 Fetching services for agent: $agentId (no location)');
      final services = await optionsDataSource.getServicesByAgentOnly(
        agentId: agentId,
      );
      
      // Cache the result
      _servicesByAgentLocation[key] = services;
      print('[NewBookingCubit] ✅ Cached ${services.length} services for agent $agentId (no location)');
      
      // Print each service being cached
      for (int i = 0; i < services.length; i++) {
        print('[NewBookingCubit] ✅ Caching Service $i: ID=${services[i].id}, Name="${services[i].serviceName}", AdultPrice=${services[i].adultPrice}');
      }
      
      // Emit loaded state to trigger UI rebuild
      emit(NewBookingLoaded());
      
      return services;
    } catch (e) {
      print('[NewBookingCubit] ❌ Error fetching services for agent only: $e');
      emit(NewBookingLoaded());
      return [];
    }
  }

  void addNewBookingRow() async {
    // Emit loading state first
    emit(NewBookingAddingRow());
    
    // Small delay to show loading state (defer to next frame)
    await Future.delayed(const Duration(milliseconds: 50));
    
    final newRow = NewBookingRow(guestName: '');
    // Add one empty service row by default
    newRow.services.add(NewBookingService());
    
    _bookingRows.add(newRow);
    
    // Emit loaded state after adding the row
    emit(NewBookingLoaded());
    
    // Don't auto-select agent and location - let user choose
    // This ensures default values are not sent in the request body
  }

  void updateBookingRow(int index, NewBookingRow row) async {
    if (index >= 0 && index < _bookingRows.length) {
      // Emit loading state
      emit(NewBookingAddingService(index));
      
      // Small delay to show loading state
      await Future.delayed(const Duration(milliseconds: 50));
      
      row.calculateTotals();
      _bookingRows[index] = row;
      // Removed logging for performance - this is called frequently
      emit(NewBookingLoaded());
    }
  }

  void removeBookingRow(int index) {
    if (index >= 0 && index < _bookingRows.length && _bookingRows.length > 1) {
      _bookingRows.removeAt(index);
      emit(NewBookingLoaded());
    }
  }

  // Get count of valid bookings ready to be saved
  int getValidBookingsCount() {
    int count = 0;
    for (var row in _bookingRows) {
      if (_isRowValid(row)) {
        count++;
      }
    }
    return count;
  }

  // Validate a single row
  bool _isRowValid(NewBookingRow row) {
    // Skip empty rows
    if (row.guestName.trim().isEmpty) return false;
    
    // Validate required fields
    if (row.agent == null) return false;
    
    // Validate that at least one service is selected and has quantities
    final validServices = row.services.where((s) => 
      s.serviceAgent != null && 
      (s.adult > 0 || s.child > 0 || s.kid > 0)
    ).toList();
    
    if (validServices.isEmpty) return false;
    
    return true;
  }

  // Get validation errors for a row
  List<String> getRowValidationErrors(NewBookingRow row, int rowIndex) {
    final errors = <String>[];
    
    if (row.guestName.trim().isEmpty) {
      errors.add('booking.guest_name_required'.tr());
    }
    
    if (row.agent == null) {
      errors.add('booking.agent_required'.tr());
    }
    
    final validServices = row.services.where((s) => 
      s.serviceAgent != null && 
      (s.adult > 0 || s.child > 0 || s.kid > 0)
    ).toList();
    
    if (validServices.isEmpty) {
      errors.add('booking.at_least_one_service_required'.tr());
    }
    
    return errors;
  }

  Future<void> saveBookings() async {
    emit(NewBookingSaving());
    try {
      final validRows = <NewBookingRow>[];
      
      // Validate all rows first
      for (int i = 0; i < _bookingRows.length; i++) {
        final row = _bookingRows[i];
        
        // Skip empty rows
        if (row.guestName.trim().isEmpty) continue;
        
        // Validate required fields
        final errors = getRowValidationErrors(row, i);
        if (errors.isNotEmpty) {
          throw Exception('${'booking.validation_error_row'.tr()} ${i + 1}: ${errors.join(', ')}');
        }
        
        validRows.add(row);
      }
      
      if (validRows.isEmpty) {
        throw Exception('booking.no_valid_bookings'.tr());
      }
      
      // Calculate totals and save
      for (var row in validRows) {
        row.calculateTotals();
        final bookingModel = await NewBookingRowConverter.toBookingModel(row);
        await bookingDataSource.createBooking(bookingModel);
      }
      
      emit(NewBookingSaved());
    } catch (e) {
      emit(NewBookingError(e.toString()));
    }
  }
}

