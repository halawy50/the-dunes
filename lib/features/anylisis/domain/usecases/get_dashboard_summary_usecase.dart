import 'package:the_dunes/features/anylisis/domain/entities/dashboard_summary_entity.dart';
import 'package:the_dunes/features/anylisis/domain/repositories/statistics_repository.dart';

class GetDashboardSummaryUseCase {
  final StatisticsRepository repository;

  GetDashboardSummaryUseCase(this.repository);

  Future<DashboardSummaryEntity> call({
    int? startDate,
    int? endDate,
  }) async {
    return await repository.getDashboardSummary(
      startDate: startDate,
      endDate: endDate,
    );
  }
}

