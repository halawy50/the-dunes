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
      print('Fetching locations from: ${ApiConstants.locationsAllEndpoint}');
      final response = await apiClient.get(ApiConstants.locationsAllEndpoint);
      print('Locations response: $response');
      final data = response['data'] as List<dynamic>? ?? [];
      print('Locations data: $data');
      return data.map((json) => LocationModel.fromJson(json)).toList();
    } catch (e) {
      // Return empty list instead of throwing - page should work even if endpoint fails
      print('⚠️ Error in getAllLocations (returning empty list): $e');
      return [];
    }
  }

  Future<List<AgentModel>> getAllAgents() async {
    try {
      print('Fetching agents from: ${ApiConstants.agentsAllEndpoint}');
      final response = await apiClient.get(ApiConstants.agentsAllEndpoint);
      print('Agents response: $response');
      final data = response['data'] as List<dynamic>? ?? [];
      print('Agents data: $data');
      return data.map((json) => AgentModel.fromJson(json)).toList();
    } catch (e) {
      // Return empty list instead of throwing - page should work even if endpoint fails
      print('⚠️ Error in getAllAgents (returning empty list): $e');
      return [];
    }
  }

  Future<List<ServiceModel>> getAllServices() async {
    try {
      print('[getAllServices] Fetching from: ${ApiConstants.servicesAllEndpoint}');
      final response = await apiClient.get(ApiConstants.servicesAllEndpoint);
      final data = response['data'] as List<dynamic>? ?? [];
      print('[getAllServices] Response data length: ${data.length}');
      if (data.isNotEmpty) {
        print('[getAllServices] First item keys: ${(data.first as Map).keys.toList()}');
        print('[getAllServices] First item: ${data.first}');
      }
      final services = data.map((json) {
        final service = ServiceModel.fromJson(json);
        print('[getAllServices] Parsed service: id=${service.id}, name="${service.name}"');
        return service;
      }).toList();
      print('[getAllServices] Total services parsed: ${services.length}');
      return services;
    } on ApiException {
      rethrow;
    } catch (e) {
      print('[getAllServices] Error: $e');
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
    } catch (e) {
      // Return empty list instead of throwing - dropdown should work even if endpoint fails
      print('⚠️ Error in getServicesByAgentAndLocation (returning empty list): $e');
      return [];
    }
  }

  Future<List<ServiceAgentModel>> getServicesByAgentOnly({
    required int agentId,
  }) async {
    try {
      print('Fetching global services for agent $agentId from: ${ApiConstants.agentGlobalServicesEndpoint(agentId)}');
      // Use the dedicated endpoint for global services (services without location)
      final response = await apiClient.get(
        ApiConstants.agentGlobalServicesEndpoint(agentId),
      );
      final data = response['data'] as List<dynamic>? ?? [];
      final services = data.map((json) => ServiceAgentModel.fromJson(json)).toList();
      print('✅ Retrieved ${services.length} global services for agent $agentId');
      return services;
    } catch (e) {
      // Return empty list instead of throwing - dropdown should work even if endpoint fails
      print('⚠️ Error in getServicesByAgentOnly (returning empty list): $e');
      return [];
    }
  }

  Future<List<DriverModel>> getDrivers() async {
    try {
      final response = await apiClient.get('/api/drivers/all');
      final data = response['data'] as List<dynamic>? ?? [];
      return data.map((json) => DriverModel.fromJson(json)).toList();
    } catch (e) {
      // Return default list instead of throwing - page should work even if endpoint fails
      print('⚠️ Error in getDrivers (returning default list): $e');
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
    } catch (e) {
      // Return default list instead of throwing - page should work even if endpoint fails
      print('⚠️ Error in getHotels (returning default list): $e');
      return [
        HotelModel(id: 1, name: 'Rixos The Palm Hotel & Suites'),
      ];
    }
  }
}


