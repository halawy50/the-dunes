import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/models/service_model.dart';

class AddServiceDialogLogic {
  static Future<Map<String, dynamic>> loadData() async {
    final dataSource = di<BookingOptionsRemoteDataSource>();
    try {
      final services = await dataSource.getAllServices();
      final locations = await dataSource.getAllLocations();
      return {
        'services': services,
        'locations': locations,
        'error': null,
      };
    } catch (e) {
      return {
        'services': <ServiceModel>[],
        'locations': <LocationModel>[],
        'error': e.toString(),
      };
    }
  }
}


