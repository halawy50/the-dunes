import 'package:the_dunes/features/anylisis/domain/entities/statistics_entity.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';

class GetStatisticsUseCase {
  final StatisticsRepository repository;

  GetStatisticsUseCase(this.repository);

  Future<StatisticsEntity> call({
    int? startDate,
    int? endDate,
  }) async {
    return await repository.getStatistics(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

