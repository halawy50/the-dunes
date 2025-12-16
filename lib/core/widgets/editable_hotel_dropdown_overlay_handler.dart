import 'package:flutter/material.dart';
import 'package:the_dunes/core/widgets/editable_hotel_dropdown_controller.dart';
import 'package:the_dunes/core/widgets/editable_hotel_dropdown_overlay.dart';

class EditableHotelDropdownOverlayHandler {
  static void showOverlay({
    required BuildContext context,
    required EditableHotelDropdownController controller,
    required Function(String) onHotelSelected,
  }) {
    removeOverlay(controller);
    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    controller.overlayEntry = EditableHotelDropdownOverlay.createOverlay(
      layerLink: controller.layerLink,
      width: renderBox.size.width,
      filteredHotels: controller.filteredHotels,
      onHotelSelected: (hotel) {
        removeOverlay(controller);
        controller.focusNode.unfocus();
        controller.controller.text = hotel;
        onHotelSelected(hotel);
      },
      onClose: () => removeOverlay(controller),
    );

    Overlay.of(context).insert(controller.overlayEntry!);
    controller.isDropdownOpen = true;
  }

  static void removeOverlay(EditableHotelDropdownController controller) {
    controller.overlayEntry?.remove();
    controller.overlayEntry = null;
    controller.isDropdownOpen = false;
  }
}

