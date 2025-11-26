import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_filter_model.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_helper.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_date_range_buttons.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_form_fields.dart';

class BookingFilterDialog extends StatefulWidget {
  final BookingFilterModel? initialFilter;

  const BookingFilterDialog({
    super.key,
    this.initialFilter,
  });

  @override
  State<BookingFilterDialog> createState() => _BookingFilterDialogState();
}

class _BookingFilterDialogState extends State<BookingFilterDialog> {
  late BookingFilterModel _filter;
  final _guestNameController = TextEditingController();
  String? _statusBook;
  String? _pickupStatus;
  int? _agentId;
  DateTime? _timeStart;
  DateTime? _timeEnd;
  DateRangeOption _dateRangeOption = DateRangeOption.today;
  List<AgentModel> _agents = [];
  bool _loadingAgents = true;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? const BookingFilterModel();
    _guestNameController.text = _filter.guestName ?? '';
    _statusBook = _filter.statusBook;
    _pickupStatus = _filter.pickupStatus;
    _agentId = _filter.agentId;
    
    if (_filter.timeStart != null && _filter.timeEnd != null) {
      _timeStart = BookingFilterDateRangeHelper.parseDateTime(_filter.timeStart!);
      _timeEnd = BookingFilterDateRangeHelper.parseDateTime(_filter.timeEnd!);
      // تحديد الخيار بناءً على التاريخ
      _dateRangeOption = _detectDateRangeOption(_timeStart!, _timeEnd!);
    } else {
      _setTodayRange();
    }
    _loadAgents();
  }

  void _setTodayRange() {
    setState(() {
      _timeStart = BookingFilterDateRangeHelper.getTodayStart();
      _timeEnd = BookingFilterDateRangeHelper.getTodayEnd();
      _dateRangeOption = DateRangeOption.today;
    });
  }

  void _setLastMonthRange() {
    setState(() {
      _timeStart = BookingFilterDateRangeHelper.getLastMonthStart();
      _timeEnd = BookingFilterDateRangeHelper.getLastMonthEnd();
      _dateRangeOption = DateRangeOption.lastMonth;
    });
  }

  void _setThisMonthRange() {
    setState(() {
      _timeStart = BookingFilterDateRangeHelper.getThisMonthStart();
      _timeEnd = BookingFilterDateRangeHelper.getThisMonthEnd();
      _dateRangeOption = DateRangeOption.thisMonth;
    });
  }

  void _setLastYearRange() {
    setState(() {
      _timeStart = BookingFilterDateRangeHelper.getLastYearStart();
      _timeEnd = BookingFilterDateRangeHelper.getLastYearEnd();
      _dateRangeOption = DateRangeOption.lastYear;
    });
  }

  DateRangeOption _detectDateRangeOption(DateTime start, DateTime end) {
    // التحقق من "اليوم"
    final todayStart = BookingFilterDateRangeHelper.getTodayStart();
    final todayEnd = BookingFilterDateRangeHelper.getTodayEnd();
    if (_isSameDateTime(start, todayStart) && _isSameDateTime(end, todayEnd)) {
      return DateRangeOption.today;
    }
    
    // التحقق من "هذا الشهر"
    final thisMonthStart = BookingFilterDateRangeHelper.getThisMonthStart();
    final thisMonthEnd = BookingFilterDateRangeHelper.getThisMonthEnd();
    if (_isSameDateTime(start, thisMonthStart) && _isSameDateTime(end, thisMonthEnd)) {
      return DateRangeOption.thisMonth;
    }
    
    // التحقق من "آخر شهر"
    final lastMonthStart = BookingFilterDateRangeHelper.getLastMonthStart();
    final lastMonthEnd = BookingFilterDateRangeHelper.getLastMonthEnd();
    if (_isSameDateTime(start, lastMonthStart) && _isSameDateTime(end, lastMonthEnd)) {
      return DateRangeOption.lastMonth;
    }
    
    // التحقق من "آخر سنة"
    final lastYearStart = BookingFilterDateRangeHelper.getLastYearStart();
    final lastYearEnd = BookingFilterDateRangeHelper.getLastYearEnd();
    if (_isSameDateTime(start, lastYearStart) && _isSameDateTime(end, lastYearEnd)) {
      return DateRangeOption.lastYear;
    }
    
    // إذا لم يطابق أي خيار، فهو Custom
    return DateRangeOption.custom;
  }

  bool _isSameDateTime(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day &&
        date1.hour == date2.hour &&
        date1.minute == date2.minute;
  }

  void _handleDateRangeOption(DateRangeOption option) {
    if (option == DateRangeOption.custom) {
      _selectCustomDateRange();
    } else if (option == DateRangeOption.today) {
      _setTodayRange();
    } else if (option == DateRangeOption.thisMonth) {
      _setThisMonthRange();
    } else if (option == DateRangeOption.lastMonth) {
      _setLastMonthRange();
    } else if (option == DateRangeOption.lastYear) {
      _setLastYearRange();
    }
  }

  Future<void> _loadAgents() async {
    try {
      final dataSource = di<BookingOptionsRemoteDataSource>();
      final agents = await dataSource.getAllAgents();
      setState(() {
        _agents = agents;
        _loadingAgents = false;
      });
    } catch (e) {
      setState(() {
        _loadingAgents = false;
      });
    }
  }

  Future<void> _selectCustomDateRange() async {
    final startDate = await showDatePicker(
      context: context,
      initialDate: _timeStart ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    if (startDate != null) {
      final endDate = await showDatePicker(
        context: context,
        initialDate: _timeEnd ?? startDate,
        firstDate: startDate,
        lastDate: DateTime(2100),
      );
      if (endDate != null) {
        setState(() {
          _timeStart = DateTime(startDate.year, startDate.month, startDate.day, 0, 0);
          _timeEnd = DateTime(endDate.year, endDate.month, endDate.day, 23, 59);
          _dateRangeOption = DateRangeOption.custom;
        });
      }
    }
  }

  void _applyFilter() {
    final filter = BookingFilterModel(
      guestName: _guestNameController.text.trim().isEmpty
          ? null
          : _guestNameController.text.trim(),
      statusBook: _statusBook,
      pickupStatus: _pickupStatus,
      agentId: _agentId,
      timeStart: _timeStart != null
          ? BookingFilterDateRangeHelper.formatDateTime(_timeStart!)
          : null,
      timeEnd: _timeEnd != null
          ? BookingFilterDateRangeHelper.formatDateTime(_timeEnd!)
          : null,
    );
    Navigator.of(context).pop(filter);
  }

  void _clearFilter() {
    Navigator.of(context).pop(null);
  }


  @override
  void dispose() {
    _guestNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.WHITE,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        color: AppColor.WHITE,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'booking.filter'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              BookingFilterFormFields(
                guestNameController: _guestNameController,
                statusBook: _statusBook,
                pickupStatus: _pickupStatus,
                agentId: _agentId,
                agents: _agents,
                loadingAgents: _loadingAgents,
                onStatusBookChanged: (value) => setState(() => _statusBook = value),
                onPickupStatusChanged: (value) => setState(() => _pickupStatus = value),
                onAgentIdChanged: (value) => setState(() => _agentId = value),
              ),
              const SizedBox(height: 16),
              Text(
                'booking.date_range'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              BookingFilterDateRangeButtons(
                selectedOption: _dateRangeOption,
                onOptionSelected: _handleDateRangeOption,
              ),
              if (_timeStart != null && _timeEnd != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${'booking.time_start'.tr()}: ${BookingFilterDateRangeHelper.formatDate(_timeStart!)}\n${'booking.time_end'.tr()}: ${BookingFilterDateRangeHelper.formatDate(_timeEnd!)}',
                  style: const TextStyle(fontSize: 12, color: AppColor.GRAY_DARK),
                ),
              ],
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _clearFilter,
                    child: Text('common.clear'.tr()),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: _applyFilter,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.YELLOW,
                      foregroundColor: AppColor.WHITE,
                    ),
                    child: Text('common.apply'.tr()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

