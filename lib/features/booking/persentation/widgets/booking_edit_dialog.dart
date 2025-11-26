import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/agent_model.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/data/datasources/booking_options_remote_data_source.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:intl/intl.dart';

class BookingEditDialog extends StatefulWidget {
  final BookingModel booking;
  final void Function(Map<String, dynamic>) onSave;

  const BookingEditDialog({
    super.key,
    required this.booking,
    required this.onSave,
  });

  @override
  State<BookingEditDialog> createState() => _BookingEditDialogState();
}

class _BookingEditDialogState extends State<BookingEditDialog> {
  late TextEditingController _guestNameController;
  late TextEditingController _phoneNumberController;
  late TextEditingController _hotelNameController;
  late TextEditingController _roomController;
  late TextEditingController _driverController;
  late TextEditingController _carNumberController;
  late TextEditingController _noteController;
  late TextEditingController _pickupTimeController;
  late TextEditingController _voucherController;
  late TextEditingController _orderNumberController;

  String? _statusBook;
  String? _pickupStatus;
  int? _agentId;
  int? _locationId;
  String? _payment;
  DateTime? _time;

  List<AgentModel> _agents = [];
  List<LocationModel> _locations = [];
  bool _loading = true;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _guestNameController = TextEditingController(text: widget.booking.guestName);
    _phoneNumberController = TextEditingController(text: widget.booking.phoneNumber ?? '');
    _hotelNameController = TextEditingController(text: widget.booking.hotelName ?? '');
    _roomController = TextEditingController(text: widget.booking.room?.toString() ?? '');
    _driverController = TextEditingController(text: widget.booking.driver ?? '');
    _carNumberController = TextEditingController(text: widget.booking.carNumber?.toString() ?? '');
    _noteController = TextEditingController(text: widget.booking.note ?? '');
    _pickupTimeController = TextEditingController(text: widget.booking.pickupTime ?? '');
    _voucherController = TextEditingController(text: widget.booking.voucher ?? '');
    _orderNumberController = TextEditingController(text: widget.booking.orderNumber ?? '');

    _statusBook = widget.booking.statusBook;
    _pickupStatus = widget.booking.pickupStatus ?? 'YET';
    _agentId = widget.booking.agentName;
    _locationId = widget.booking.locationId;
    _payment = widget.booking.payment;

    if (widget.booking.time != null) {
      try {
        _time = DateFormat('yyyy/MM/dd HH:mm').parse(widget.booking.time!);
      } catch (e) {
        _time = null;
      }
    }

    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    final dataSource = di<BookingOptionsRemoteDataSource>();
    try {
      final agents = await dataSource.getAllAgents();
      final locations = await dataSource.getAllLocations();
      setState(() {
        _agents = agents;
        _locations = locations;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _time ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: _time != null
            ? TimeOfDay.fromDateTime(_time!)
            : TimeOfDay.now(),
      );
      if (time != null) {
        setState(() {
          _time = DateTime(
            picked.year,
            picked.month,
            picked.day,
            time.hour,
            time.minute,
          );
        });
      }
    }
  }

  void _save() {
    final updates = <String, dynamic>{};

    // guestName is required - always include it
    final guestName = _guestNameController.text.trim();
    if (guestName.isEmpty) {
      // Show error or return early
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('booking.guest_name_required'.tr())),
      );
      return;
    }
    updates['guestName'] = guestName;

    final phoneNumber = _phoneNumberController.text.trim();
    if (phoneNumber.isNotEmpty) {
      updates['phoneNumber'] = phoneNumber;
    }

    if (_statusBook != null) {
      updates['statusBook'] = _statusBook;
    }

    if (_pickupStatus != null) {
      updates['pickupStatus'] = _pickupStatus;
    }

    if (_agentId != null) {
      updates['agentName'] = _agentId; // API expects agentName, not agentId
    }

    if (_locationId != null) {
      updates['locationId'] = _locationId;
    }

    final hotelName = _hotelNameController.text.trim();
    if (hotelName.isNotEmpty) {
      updates['hotelName'] = hotelName;
    }

    final roomStr = _roomController.text.trim();
    if (roomStr.isNotEmpty) {
      final room = int.tryParse(roomStr);
      if (room != null) {
        updates['room'] = room;
      }
    }

    final driver = _driverController.text.trim();
    if (driver.isNotEmpty) {
      updates['driver'] = driver;
    }

    final carNumberStr = _carNumberController.text.trim();
    if (carNumberStr.isNotEmpty) {
      final carNumber = int.tryParse(carNumberStr);
      if (carNumber != null) {
        updates['carNumber'] = carNumber;
      }
    }

    if (_payment != null) {
      updates['payment'] = _payment;
    }

    final note = _noteController.text.trim();
    if (note.isNotEmpty) {
      updates['note'] = note;
    }

    final pickupTime = _pickupTimeController.text.trim();
    if (pickupTime.isNotEmpty) {
      updates['pickupTime'] = pickupTime;
    }

    final voucher = _voucherController.text.trim();
    if (voucher.isNotEmpty) {
      updates['voucher'] = voucher;
    }

    final orderNumber = _orderNumberController.text.trim();
    if (orderNumber.isNotEmpty) {
      updates['orderNumber'] = orderNumber;
    }

    if (_time != null) {
      updates['time'] = DateFormat('yyyy/MM/dd HH:mm').format(_time!);
    }

    // التحقق من وجود تحديثات قبل الحفظ
    if (updates.isEmpty) {
      if (context.mounted) {
        Navigator.of(context).pop(null);
      }
      return;
    }

    // إرجاع التحديثات (سيتم استدعاء onBookingEdit في booking_table_columns)
    // Dialog سيُغلق تلقائياً عند النجاح أو الخطأ من خلال BlocListener في booking_screen
    if (context.mounted) {
      Navigator.of(context).pop(updates);
    }
  }

  @override
  void dispose() {
    _guestNameController.dispose();
    _phoneNumberController.dispose();
    _hotelNameController.dispose();
    _roomController.dispose();
    _driverController.dispose();
    _carNumberController.dispose();
    _noteController.dispose();
    _pickupTimeController.dispose();
    _voucherController.dispose();
    _orderNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColor.WHITE,
      child: Container(
        width: 600,
        constraints: const BoxConstraints(maxHeight: 700),
        padding: const EdgeInsets.all(24),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _isSaving
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'common.edit'.tr(),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                      controller: _guestNameController,
                      label: 'booking.guest_name'.tr(),
                      required: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneNumberController,
                      label: 'booking.phone_number'.tr(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatusDropdown(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPickupStatusDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildAgentDropdown(),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildLocationDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _hotelNameController,
                      label: 'booking.hotel_name'.tr(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _roomController,
                            label: 'booking.room'.tr(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _driverController,
                            label: 'booking.driver'.tr(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _carNumberController,
                            label: 'booking.car_number'.tr(),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildPaymentDropdown(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildDateField(),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            controller: _pickupTimeController,
                            label: 'booking.pickup_time_col'.tr(),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                            controller: _voucherController,
                            label: 'booking.voucher'.tr(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _orderNumberController,
                      label: 'booking.order_number'.tr(),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _noteController,
                      label: 'booking.note'.tr(),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            if (context.mounted) {
                              Navigator.of(context).pop(null);
                            }
                          },
                          child: Text('common.cancel'.tr()),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          child: _isSaving
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : Text('common.save'.tr()),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool required = false,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: required ? '$label *' : label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _statusBook,
      decoration: InputDecoration(
        labelText: 'booking.status'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
        DropdownMenuItem(value: 'ACCEPTED', child: Text('ACCEPTED')),
        DropdownMenuItem(value: 'COMPLETED', child: Text('COMPLETED')),
        DropdownMenuItem(value: 'CANCELLED', child: Text('CANCELLED')),
      ],
      onChanged: (value) => setState(() => _statusBook = value),
    );
  }

  Widget _buildPickupStatusDropdown() {
    return DropdownButtonFormField<String>(
      value: _pickupStatus,
      decoration: InputDecoration(
        labelText: 'booking.pickup_status'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'YET', child: Text('YET')),
        DropdownMenuItem(value: 'PICKED', child: Text('PICKED')),
        DropdownMenuItem(value: 'INWAY', child: Text('INWAY')),
      ],
      onChanged: (value) => setState(() => _pickupStatus = value),
    );
  }

  Widget _buildAgentDropdown() {
    return DropdownButtonFormField<int>(
      value: _agentId,
      decoration: InputDecoration(
        labelText: 'booking.agent_name'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: _agents.map((agent) {
        return DropdownMenuItem(
          value: agent.id,
          child: Text(agent.name),
        );
      }).toList(),
      onChanged: (value) => setState(() => _agentId = value),
    );
  }

  Widget _buildLocationDropdown() {
    return DropdownButtonFormField<int>(
      value: _locationId,
      decoration: InputDecoration(
        labelText: 'booking.location'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: _locations.map((location) {
        return DropdownMenuItem(
          value: location.id,
          child: Text(location.name),
        );
      }).toList(),
      onChanged: (value) => setState(() => _locationId = value),
    );
  }

  Widget _buildPaymentDropdown() {
    return DropdownButtonFormField<String>(
      value: _payment,
      decoration: InputDecoration(
        labelText: 'booking.payment'.tr(),
        border: const OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'CASH', child: Text('CASH')),
        DropdownMenuItem(value: 'CARD', child: Text('CARD')),
        DropdownMenuItem(value: 'PENDING', child: Text('PENDING')),
      ],
      onChanged: (value) => setState(() => _payment = value),
    );
  }

  Widget _buildDateField() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: 'booking.time'.tr(),
          border: const OutlineInputBorder(),
          suffixIcon: const Icon(Icons.calendar_today),
        ),
        child: Text(
          _time != null
              ? DateFormat('yyyy/MM/dd HH:mm').format(_time!)
              : 'booking.time'.tr(),
        ),
      ),
    );
  }
}

