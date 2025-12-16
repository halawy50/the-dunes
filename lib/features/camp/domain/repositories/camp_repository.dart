import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';

abstract class CampRepository {
  Future<CampDataEntity> getCampData();
  Future<void> updateBookingStatus(int bookingId, String status);
}

