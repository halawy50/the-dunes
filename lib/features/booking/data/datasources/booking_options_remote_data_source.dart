import 'package:the_dunes/core/network/api_client.dart';
import 'package:the_dunes/core/network/api_constants.dart';
import 'package:the_dunes/core/network/api_exception.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/models/driver_model.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_agent_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class BookingOptionsRemoteDataSource {
  final ApiClient apiClient;

  BookingOptionsRemoteDataSource(this.apiClient);

  Future<List<LocationModel>> getAllLocations() async {
    try {
      final response = await apiClient.get(ApiConstants.locationsAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => LocationModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<AgentModel>> getAllAgents() async {
    try {
      final response = await apiClient.get(ApiConstants.agentsAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => AgentModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<ServiceModel>> getAllServices() async {
    try {
      final response = await apiClient.get(ApiConstants.servicesAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => ServiceModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<ServiceAgentModel>> getServicesByAgentAndLocation({
    required int agentId,
    required int locationId,
  }) async {
    try {
      final response = await apiClient.get(
        ApiConstants.serviceAgentsByAgentLocationEndpoint,
        queryParams: {
          'agentId': agentId.toString(),
          'locationId': locationId.toString(),
        },
      );
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => ServiceAgentModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(message: e.toString(), statusCode: 500);
    }
  }

  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await apiClient.get('/api/drivers/all');
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => DriverModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      return [
        DriverModel(id: 1, name: 'NON'),
        DriverModel(id: 2, name: 'AZAM', phoneNumber: '+971 55 524 6715'),
        DriverModel(id: 3, name: 'RAHIL', phoneNumber: '+971 50 808 4801'),
        DriverModel(id: 4, name: 'ABU SAIF', phoneNumber: '+971 35 805 6033'),
        DriverModel(id: 5, name: 'SALMAN', phoneNumber: '+971 22 253 8796'),
      ];
    }
  }

  Future<List<HotelModel>> getHotels() async {
    try {
      final response = await apiClient.get('/api/hotels/all');
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => HotelModel.fromJson(json)).toList();
    } on ApiException {
      rethrow;
    } catch (e) {
      return [
        HotelModel(id: 1, name: 'Rixos The Palm Hotel & Suites'),
      ];
    }
  }
}


