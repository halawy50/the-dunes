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
    try {
      _locations = await optionsDataSource.getAllLocations();
      _agents = await optionsDataSource.getAllAgents();
      _drivers = await optionsDataSource.getDrivers();
      _hotels = await optionsDataSource.getHotels();
      _bookingRows = [NewBookingRow(guestName: '')];
      emit(NewBookingLoaded());
    } catch (e) {
      emit(NewBookingError(e.toString()));
    }
  }

  Future<List<ServiceAgentModel>> getServicesForAgentAndLocation(
    int agentId,
    int locationId,
  ) async {
    final key = '$agentId-$locationId';
    if (_servicesByAgentLocation.containsKey(key)) {
      return _servicesByAgentLocation[key]!;
    }
    try {
      final services = await optionsDataSource.getServicesByAgentAndLocation(
        agentId: agentId,
        locationId: locationId,
      );
      _servicesByAgentLocation[key] = services;
      return services;
    } catch (e) {
      return [];
    }
  }

  void addNewBookingRow() {
    _bookingRows.add(NewBookingRow(guestName: ''));
    emit(NewBookingLoaded());
  }

  void updateBookingRow(int index, NewBookingRow row) {
    if (index >= 0 && index < _bookingRows.length) {
      row.calculateTotals();
      _bookingRows[index] = row;
      emit(NewBookingLoaded());
    }
  }

  void removeBookingRow(int index) {
    if (index >= 0 && index < _bookingRows.length && _bookingRows.length > 1) {
      _bookingRows.removeAt(index);
      emit(NewBookingLoaded());
    }
  }

  Future<void> saveBookings() async {
    emit(NewBookingSaving());
    try {
      for (var row in _bookingRows) {
        if (row.guestName.isEmpty) continue;
        final bookingModel = await NewBookingRowConverter.toBookingModel(row);
        await bookingDataSource.createBooking(bookingModel);
      }
      emit(NewBookingSaved());
    } catch (e) {
      emit(NewBookingError(e.toString()));
    }
  }
}

