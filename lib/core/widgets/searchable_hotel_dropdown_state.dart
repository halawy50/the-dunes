import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/searchable_hotel_dropdown_overlay.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class SearchableHotelDropdownStateManager {
  final TextEditingController controller;
  final FocusNode focusNode;
  final LayerLink layerLink;
  List<HotelModel> hotels;
  final ValueChanged<String?> onChanged;
  OverlayEntry? overlayEntry;
  bool isDropdownOpen = false;
  List<HotelModel> filteredHotels = [];

  SearchableHotelDropdownStateManager({
    required this.controller,
    required this.focusNode,
    required this.layerLink,
    required this.hotels,
    required this.onChanged,
  }) {
    filteredHotels = hotels;
  }

  void filterHotels(String query) {
    if (query.isEmpty) {
      filteredHotels = hotels;
    } else {
      final lowerQuery = query.toLowerCase();
      filteredHotels = hotels
          .where((hotel) => hotel.name.toLowerCase().contains(lowerQuery))
          .toList();
    }
  }

  void showOverlay(BuildContext context) {
    removeOverlay();
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    overlayEntry = SearchableHotelDropdownOverlay.createOverlay(
      layerLink: layerLink,
      width: renderBox.size.width,
      filteredHotels: filteredHotels,
      onHotelSelected: (hotelName) {
        // Update controller text immediately
        controller.text = hotelName;
        controller.selection = TextSelection.fromPosition(
          TextPosition(offset: hotelName.length),
        );
        // Notify parent widget of the change
        onChanged(hotelName);
        // Close overlay and remove focus
        removeOverlay();
        Future.delayed(const Duration(milliseconds: 100), () {
          focusNode.unfocus();
        });
      },
      onClose: removeOverlay,
    );

    if (overlayEntry != null) {
      Overlay.of(context).insert(overlayEntry!);
      isDropdownOpen = true;
    }
  }

  void removeOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    isDropdownOpen = false;
  }

  void dispose() {
    controller.dispose();
    focusNode.dispose();
    removeOverlay();
  }
}

