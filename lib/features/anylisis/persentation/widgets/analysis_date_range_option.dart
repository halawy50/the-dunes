enum AnalysisDateRangeOption {
  thisYear,
  thisMonth,
  lastMonth,
  lastYear,
  custom,
}

extension AnalysisDateRangeOptionExtension on AnalysisDateRangeOption {
  String getTranslationKey() {
    switch (this) {
      case AnalysisDateRangeOption.thisYear:
        return 'analysis.this_year';
      case AnalysisDateRangeOption.thisMonth:
        return 'analysis.this_month';
      case AnalysisDateRangeOption.lastMonth:
        return 'analysis.last_month';
      case AnalysisDateRangeOption.lastYear:
        return 'analysis.last_year';
      case AnalysisDateRangeOption.custom:
        return 'analysis.custom';
    }
  }
}

