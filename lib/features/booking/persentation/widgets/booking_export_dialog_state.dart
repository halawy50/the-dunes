import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';

class BookingExportDialogState {
  int? agentId;
  String? status;
  DateTime? startDate;
  DateTime? endDate;
  DateRangeOption dateRangeOption;
  List<AgentModel> agents;
  bool loadingAgents;
  bool isExporting;

  BookingExportDialogState({
    this.agentId,
    this.status,
    this.startDate,
    this.endDate,
    this.dateRangeOption = DateRangeOption.today,
    this.agents = const [],
    this.loadingAgents = true,
    this.isExporting = false,
  });

  void setTodayRange() {
    startDate = BookingFilterDateRangeHelper.getTodayStart();
    endDate = BookingFilterDateRangeHelper.getTodayEnd();
    dateRangeOption = DateRangeOption.today;
  }

  void setLastMonthRange() {
    startDate = BookingFilterDateRangeHelper.getLastMonthStart();
    endDate = BookingFilterDateRangeHelper.getLastMonthEnd();
    dateRangeOption = DateRangeOption.lastMonth;
  }

  void setThisMonthRange() {
    startDate = BookingFilterDateRangeHelper.getThisMonthStart();
    endDate = BookingFilterDateRangeHelper.getThisMonthEnd();
    dateRangeOption = DateRangeOption.thisMonth;
  }

  void setLastYearRange() {
    startDate = BookingFilterDateRangeHelper.getLastYearStart();
    endDate = BookingFilterDateRangeHelper.getLastYearEnd();
    dateRangeOption = DateRangeOption.lastYear;
  }
}

