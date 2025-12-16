import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_filter_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_filter_date_range_helper.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_filter_date_range_buttons.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_filter_form_fields.dart';

class ReceiptVoucherFilterDialog extends StatefulWidget {
  final ReceiptVoucherFilterModel? initialFilter;

  const ReceiptVoucherFilterDialog({
    super.key,
    this.initialFilter,
  });

  @override
  State<ReceiptVoucherFilterDialog> createState() =>
      _ReceiptVoucherFilterDialogState();
}

class _ReceiptVoucherFilterDialogState
    extends State<ReceiptVoucherFilterDialog> {
  late ReceiptVoucherFilterModel _filter;
  final _guestNameController = TextEditingController();
  String? _status;
  DateTime? _timeStart;
  DateTime? _timeEnd;
  DateRangeOption _dateRangeOption = DateRangeOption.today;

  @override
  void initState() {
    super.initState();
    _filter = widget.initialFilter ?? const ReceiptVoucherFilterModel();
    _guestNameController.text = _filter.guestName ?? '';
    _status = _filter.status;

    if (_filter.timeStart != null && _filter.timeEnd != null) {
      _timeStart = ReceiptVoucherFilterDateRangeHelper.parseDateTime(
          _filter.timeStart!);
      _timeEnd = ReceiptVoucherFilterDateRangeHelper.parseDateTime(
          _filter.timeEnd!);
      _dateRangeOption = _detectDateRangeOption(_timeStart!, _timeEnd!);
    } else {
      _setTodayRange();
    }
  }

  void _setTodayRange() {
    setState(() {
      _timeStart = ReceiptVoucherFilterDateRangeHelper.getTodayStart();
      _timeEnd = ReceiptVoucherFilterDateRangeHelper.getTodayEnd();
      _dateRangeOption = DateRangeOption.today;
    });
  }

  void _setLastMonthRange() {
    setState(() {
      _timeStart = ReceiptVoucherFilterDateRangeHelper.getLastMonthStart();
      _timeEnd = ReceiptVoucherFilterDateRangeHelper.getLastMonthEnd();
      _dateRangeOption = DateRangeOption.lastMonth;
    });
  }

  void _setThisMonthRange() {
    setState(() {
      _timeStart = ReceiptVoucherFilterDateRangeHelper.getThisMonthStart();
      _timeEnd = ReceiptVoucherFilterDateRangeHelper.getThisMonthEnd();
      _dateRangeOption = DateRangeOption.thisMonth;
    });
  }

  void _setLastYearRange() {
    setState(() {
      _timeStart = ReceiptVoucherFilterDateRangeHelper.getLastYearStart();
      _timeEnd = ReceiptVoucherFilterDateRangeHelper.getLastYearEnd();
      _dateRangeOption = DateRangeOption.lastYear;
    });
  }

  DateRangeOption _detectDateRangeOption(DateTime start, DateTime end) {
    final todayStart = ReceiptVoucherFilterDateRangeHelper.getTodayStart();
    final todayEnd = ReceiptVoucherFilterDateRangeHelper.getTodayEnd();
    if (_isSameDateTime(start, todayStart) &&
        _isSameDateTime(end, todayEnd)) {
      return DateRangeOption.today;
    }

    final thisMonthStart =
        ReceiptVoucherFilterDateRangeHelper.getThisMonthStart();
    final thisMonthEnd = ReceiptVoucherFilterDateRangeHelper.getThisMonthEnd();
    if (_isSameDateTime(start, thisMonthStart) &&
        _isSameDateTime(end, thisMonthEnd)) {
      return DateRangeOption.thisMonth;
    }

    final lastMonthStart =
        ReceiptVoucherFilterDateRangeHelper.getLastMonthStart();
    final lastMonthEnd =
        ReceiptVoucherFilterDateRangeHelper.getLastMonthEnd();
    if (_isSameDateTime(start, lastMonthStart) &&
        _isSameDateTime(end, lastMonthEnd)) {
      return DateRangeOption.lastMonth;
    }

    final lastYearStart =
        ReceiptVoucherFilterDateRangeHelper.getLastYearStart();
    final lastYearEnd = ReceiptVoucherFilterDateRangeHelper.getLastYearEnd();
    if (_isSameDateTime(start, lastYearStart) &&
        _isSameDateTime(end, lastYearEnd)) {
      return DateRangeOption.lastYear;
    }

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
    final filter = ReceiptVoucherFilterModel(
      guestName: _guestNameController.text.trim().isEmpty
          ? null
          : _guestNameController.text.trim(),
      status: _status,
      timeStart: _timeStart != null
          ? ReceiptVoucherFilterDateRangeHelper.formatDateTime(_timeStart!)
          : null,
      timeEnd: _timeEnd != null
          ? ReceiptVoucherFilterDateRangeHelper.formatDateTime(_timeEnd!)
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
                'receipt_voucher.filter'.tr(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              ReceiptVoucherFilterFormFields(
                guestNameController: _guestNameController,
                status: _status,
                onStatusChanged: (value) => setState(() => _status = value),
              ),
              const SizedBox(height: 16),
              Text(
                'receipt_voucher.date_range'.tr(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              ReceiptVoucherFilterDateRangeButtons(
                selectedOption: _dateRangeOption,
                onOptionSelected: _handleDateRangeOption,
              ),
              if (_timeStart != null && _timeEnd != null) ...[
                const SizedBox(height: 12),
                Text(
                  '${'receipt_voucher.time_start'.tr()}: ${ReceiptVoucherFilterDateRangeHelper.formatDate(_timeStart!)}\n${'receipt_voucher.time_end'.tr()}: ${ReceiptVoucherFilterDateRangeHelper.formatDate(_timeEnd!)}',
                  style: const TextStyle(
                      fontSize: 12, color: AppColor.GRAY_DARK),
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

