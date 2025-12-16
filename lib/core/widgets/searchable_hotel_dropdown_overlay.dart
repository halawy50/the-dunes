import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/features/booking/data/models/hotel_model.dart';

class SearchableHotelDropdownOverlay {
  static OverlayEntry? createOverlay({
    required LayerLink layerLink,
    required double width,
    required List<HotelModel> filteredHotels,
    required Function(String) onHotelSelected,
    required VoidCallback onClose,
  }) {
    if (filteredHotels.isEmpty) {
      return OverlayEntry(
        builder: (context) => Positioned(
          width: width,
          child: CompositedTransformFollower(
            link: layerLink,
            showWhenUnlinked: false,
            offset: const Offset(0, 0),
            child: Material(
              elevation: 4,
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('common.no_results'.tr()),
              ),
            ),
          ),
        ),
      );
    }

    return OverlayEntry(
      builder: (context) => Positioned(
        width: width,
        child: CompositedTransformFollower(
          link: layerLink,
          showWhenUnlinked: false,
          offset: const Offset(0, 0),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(8),
            color: Colors.white,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 200),
              child: ListView.builder(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: filteredHotels.length + 1,
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          onHotelSelected('hotel1');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                          child: const Text(
                            'hotel1',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    );
                  }
                  final hotel = filteredHotels[index - 1];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        onHotelSelected(hotel.name);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                        child: Text(
                          hotel.name,
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ),
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
