import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class SearchableHotelDropdown extends StatefulWidget {
  final String? value;
  final List<HotelModel> hotels;
  final ValueChanged<String?> onChanged;
  final String? label;
  final bool isRequired;

  const SearchableHotelDropdown({
    super.key,
    this.value,
    required this.hotels,
    required this.onChanged,
    this.label,
    this.isRequired = false,
  });

  @override
  State<SearchableHotelDropdown> createState() => _SearchableHotelDropdownState();
}

class _SearchableHotelDropdownState extends State<SearchableHotelDropdown> {
  bool _isManualMode = false;
  final TextEditingController _manualController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _manualController.text = widget.value ?? '';
    // Check if current value is not in hotels list, then it's manual
    if (widget.value != null && widget.value!.isNotEmpty) {
      final hotelNames = widget.hotels.map((h) => h.name).toSet();
      if (!hotelNames.contains(widget.value)) {
        _isManualMode = true;
      }
    }
  }

  @override
  void didUpdateWidget(SearchableHotelDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only update controller if value changed externally
    if (widget.value != oldWidget.value) {
      // In manual mode, don't update controller from widget.value to avoid interrupting typing
      // The controller is the source of truth in manual mode
      if (!_isManualMode) {
        final newValue = widget.value ?? '';
        if (_manualController.text != newValue) {
          _manualController.text = newValue;
        }
      }
      
      // Check if value is manual (not in hotels list) to switch to manual mode
      if (widget.value != null && widget.value!.isNotEmpty) {
        final hotelNames = widget.hotels.map((h) => h.name).toSet();
        if (!hotelNames.contains(widget.value)) {
          _isManualMode = true;
          // Update controller when switching to manual mode
          if (_manualController.text != widget.value) {
            _manualController.text = widget.value!;
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _manualController.dispose();
    super.dispose();
  }

  void _switchToManualMode() {
    setState(() {
      _isManualMode = true;
      _manualController.text = widget.value ?? '';
    });
  }

  void _switchToDropdownMode() {
    setState(() {
      _isManualMode = false;
      // Keep the current value if it exists in hotels list
      final currentValue = _manualController.text;
      if (currentValue.isNotEmpty) {
        final hotelNames = widget.hotels.map((h) => h.name).toSet();
        if (!hotelNames.contains(currentValue)) {
          // If value is not in list, clear it when switching to dropdown
          _manualController.clear();
          widget.onChanged(null);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isManualMode) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null)
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.label! + (widget.isRequired ? ' *' : ''),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton.icon(
                  onPressed: _switchToDropdownMode,
                  icon: const Icon(
                    Icons.list,
                    size: 16,
                    color: AppColor.YELLOW,
                  ),
                  label: Text(
                    'common.select_from_list'.tr(),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColor.YELLOW,
                    ),
                  ),
                ),
              ],
            ),
          if (widget.label != null) const SizedBox(height: 8),
          TextField(
            controller: _manualController,
            focusNode: _focusNode,
            decoration: InputDecoration(
              hintText: widget.label ?? 'booking.hotel_name'.tr(),
              hintStyle: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
                fontWeight: FontWeight.normal,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColor.YELLOW, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              suffixIcon: widget.label == null
                  ? IconButton(
                      icon: const Icon(
                        Icons.list,
                        size: 18,
                        color: AppColor.YELLOW,
                      ),
                      onPressed: _switchToDropdownMode,
                      tooltip: 'common.select_from_list'.tr(),
                    )
                  : null,
            ),
            onChanged: (value) {
              widget.onChanged(value.isEmpty ? null : value);
            },
          ),
        ],
      );
    }

    // Create list of hotel names
    final hotelNames = widget.hotels.map((h) => h.name).where((name) => name.isNotEmpty).toSet().toList();
    
    // Ensure selected value exists in the list, or set to null
    final selectedValue = widget.value != null && hotelNames.contains(widget.value) ? widget.value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null)
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.label! + (widget.isRequired ? ' *' : ''),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _switchToManualMode,
                icon: const Icon(
                  Icons.edit,
                  size: 16,
                  color: AppColor.YELLOW,
                ),
                label: Text(
                  'common.manual_input'.tr(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColor.YELLOW,
                  ),
                ),
              ),
            ],
          ),
        if (widget.label != null) const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          menuMaxHeight: 200,
          iconSize: 20,
          enableFeedback: false,
          borderRadius: BorderRadius.circular(8),
          dropdownColor: Colors.white,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(
            Icons.arrow_drop_down,
            color: AppColor.GRAY_HULF,
            size: 20,
          ),
          decoration: InputDecoration(
            hintText: widget.label ?? 'booking.hotel_name'.tr(),
            hintStyle: const TextStyle(
              fontSize: 14,
              color: Colors.black54,
              fontWeight: FontWeight.normal,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.GRAY_D8D8D8),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColor.YELLOW, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            suffixIcon: widget.label == null
                ? IconButton(
                    icon: Icon(
                      _isManualMode ? Icons.list : Icons.edit,
                      size: 18,
                      color: AppColor.YELLOW,
                    ),
                    onPressed: _isManualMode ? _switchToDropdownMode : _switchToManualMode,
                    tooltip: _isManualMode
                        ? 'common.select_from_list'.tr()
                        : 'common.manual_input'.tr(),
                  )
                : null,
          ),
          items: hotelNames.isEmpty
              ? null
              : hotelNames.map((hotelName) {
                  return DropdownMenuItem<String>(
                    value: hotelName,
                    child: Text(
                      hotelName,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
          onChanged: widget.hotels.isEmpty ? null : (String? newValue) {
            widget.onChanged(newValue);
          },
        ),
      ],
    );
  }
}
