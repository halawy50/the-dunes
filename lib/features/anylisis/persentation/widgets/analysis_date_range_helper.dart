import 'package:the_dunes/features/anylisis/persentation/widgets/analysis_date_range_option.dart';

class AnalysisDateRangeHelper {
  static Map<String, int?> getDateRange(AnalysisDateRangeOption option) {
    final now = DateTime.now();
    int? startDate;
    int? endDate;

    switch (option) {
      case AnalysisDateRangeOption.thisYear:
        startDate = DateTime(now.year, 1, 1).millisecondsSinceEpoch ~/ 1000;
        endDate = DateTime(now.year, 12, 31, 23, 59, 59).millisecondsSinceEpoch ~/ 1000;
        break;
      case AnalysisDateRangeOption.thisMonth:
        startDate = DateTime(now.year, now.month, 1).millisecondsSinceEpoch ~/ 1000;
        endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch ~/ 1000;
        break;
      case AnalysisDateRangeOption.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1);
        startDate = DateTime(lastMonth.year, lastMonth.month, 1).millisecondsSinceEpoch ~/ 1000;
        endDate = DateTime(lastMonth.year, lastMonth.month + 1, 0, 23, 59, 59).millisecondsSinceEpoch ~/ 1000;
        break;
      case AnalysisDateRangeOption.lastYear:
        startDate = DateTime(now.year - 1, 1, 1).millisecondsSinceEpoch ~/ 1000;
        endDate = DateTime(now.year - 1, 12, 31, 23, 59, 59).millisecondsSinceEpoch ~/ 1000;
        break;
      case AnalysisDateRangeOption.custom:
        startDate = null;
        endDate = null;
        break;
    }

    return {'startDate': startDate, 'endDate': endDate};
  }
}

