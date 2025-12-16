import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class EditableHotelDropdownOverlay {
  static OverlayEntry createOverlay({
    required LayerLink layerLink,
    required double width,
    required List<String> filteredHotels,
    required Function(String) onHotelSelected,
    required VoidCallback onClose,
  }) {
    if (filteredHotels.isEmpty) {
      return OverlayEntry(builder: (_) => const SizedBox.shrink());
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 4),
          child: Material(
            elevation: 4,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              constraints: const BoxConstraints(maxHeight: 200),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColor.GRAY_D8D8D8),
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: filteredHotels.length,
                itemBuilder: (context, index) {
                  final hotel = filteredHotels[index];
                  return ListTile(
                    title: Text(hotel),
                    onTap: () {
                      onHotelSelected(hotel);
                      onClose();
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

