import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogLogic {
  static Future<List<LocationModel>> loadLocations() async {
    final dataSource = di<BookingOptionsRemoteDataSource>();
    try {
      return await dataSource.getAllLocations();
    } catch (e) {
      return [];
    }
  }
}

