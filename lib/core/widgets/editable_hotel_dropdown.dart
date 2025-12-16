import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/editable_hotel_dropdown_content.dart';
import 'package:the_dunes/core/widgets/editable_hotel_dropdown_controller.dart';
import 'package:the_dunes/core/widgets/editable_hotel_dropdown_overlay_handler.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class EditableHotelDropdown extends StatefulWidget {
  final String? value;
  final List<HotelModel> hotels;
  final ValueChanged<String?> onChanged;
  final String? label;
  final bool isRequired;

  const EditableHotelDropdown({
    super.key,
    this.value,
    required this.hotels,
    required this.onChanged,
    this.label,
    this.isRequired = false,
  });

  @override
  State<EditableHotelDropdown> createState() => _EditableHotelDropdownState();
}

class _EditableHotelDropdownState extends State<EditableHotelDropdown> {
  late EditableHotelDropdownController _dropdownController;

  @override
  void initState() {
    super.initState();
    _dropdownController = EditableHotelDropdownController(
      initialValue: widget.value,
      hotels: widget.hotels,
    );
    _dropdownController.focusNode.addListener(_onFocusChange);
  }

  @override
  void didUpdateWidget(EditableHotelDropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      final newValue = widget.value ?? '';
      if (_dropdownController.controller.text != newValue) {
        _dropdownController.controller.text = newValue;
      }
    }
    if (widget.hotels != oldWidget.hotels) {
      _dropdownController.updateHotels(widget.hotels);
    }
  }

  @override
  void dispose() {
    _dropdownController.focusNode.removeListener(_onFocusChange);
    EditableHotelDropdownOverlayHandler.removeOverlay(_dropdownController);
    _dropdownController.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    if (_dropdownController.focusNode.hasFocus) {
      _showOverlay();
    } else {
      EditableHotelDropdownOverlayHandler.removeOverlay(_dropdownController);
    }
  }

  void _filterHotels(String query) {
    setState(() {
      _dropdownController.filterHotels(query, widget.hotels);
    });
    if (_dropdownController.isDropdownOpen) {
      _showOverlay();
    }
  }

  void _showOverlay() {
    EditableHotelDropdownOverlayHandler.showOverlay(
      context: context,
      controller: _dropdownController,
      onHotelSelected: widget.onChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    return EditableHotelDropdownContent(
      label: widget.label,
      isRequired: widget.isRequired,
      controller: _dropdownController.controller,
      focusNode: _dropdownController.focusNode,
      layerLink: _dropdownController.layerLink,
      onChanged: (value) {
        widget.onChanged(value.isEmpty ? null : value);
        _filterHotels(value);
      },
      onTap: () {
        if (!_dropdownController.isDropdownOpen) {
          _showOverlay();
        }
      },
    );
  }
}

