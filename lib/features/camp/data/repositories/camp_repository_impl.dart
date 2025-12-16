import 'package:the_dunes/features/camp/data/datasources/camp_remote_data_source.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/domain/repositories/camp_repository.dart';

class CampRepositoryImpl implements CampRepository {
  final CampRemoteDataSource dataSource;

  CampRepositoryImpl(this.dataSource);

  @override
  Future<CampDataEntity> getCampData() async {
    return await dataSource.getCampData();
  }

  @override
  Future<void> updateBookingStatus(int bookingId, String status) async {
    await dataSource.updateBookingStatus(bookingId, status);
  }
}

