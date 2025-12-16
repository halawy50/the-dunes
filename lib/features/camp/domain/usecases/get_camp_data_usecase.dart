import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/domain/repositories/camp_repository.dart';

class GetCampDataUseCase {
  final CampRepository repository;

  GetCampDataUseCase(this.repository);

  Future<CampDataEntity> call() async {
    return await repository.getCampData();
  }
}

