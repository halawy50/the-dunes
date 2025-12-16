import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/assets/images.dart';

class CurrencyFlagIcon extends StatelessWidget {
  final String currencyTitle;
  final double size;

  const CurrencyFlagIcon({
    super.key,
    required this.currencyTitle,
    this.size = 20,
  });

  String _getFlagAsset() {
    switch (currencyTitle.toUpperCase()) {
      case 'AED':
        return AppImages.EMARATE_FLAG;
      case 'USD':
        return AppImages.AMERCA_FLAG;
      case 'EUR':
        return AppImages.EURO_CURRENCY;
      default:
        return AppImages.EMARATE_FLAG;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        _getFlagAsset(),
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}

