import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class EditableHotelDropdownController {
  final TextEditingController controller;
  final FocusNode focusNode;
  final LayerLink layerLink;
  OverlayEntry? overlayEntry;
  bool isDropdownOpen = false;
  List<String> filteredHotels = [];

  EditableHotelDropdownController({
    String? initialValue,
    required List<HotelModel> hotels,
  })  : controller = TextEditingController(text: initialValue ?? ''),
        focusNode = FocusNode(),
        layerLink = LayerLink() {
    filteredHotels = _getHotelNames(hotels);
  }

  List<String> _getHotelNames(List<HotelModel> hotels) {
    return hotels
        .map((h) => h.name)
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  void filterHotels(String query, List<HotelModel> hotels) {
    if (query.isEmpty) {
      filteredHotels = _getHotelNames(hotels);
    } else {
      final lowerQuery = query.toLowerCase();
      filteredHotels = _getHotelNames(hotels)
          .where((name) => name.toLowerCase().contains(lowerQuery))
          .toList();
    }
  }

  void updateHotels(List<HotelModel> hotels) {
    filteredHotels = _getHotelNames(hotels);
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
    overlayEntry?.remove();
  }
}

