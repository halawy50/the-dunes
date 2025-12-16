import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/matched_data_model.dart';

class MatchedDataCard extends StatelessWidget {
  final int index;
  final MatchedDataModel data;

  const MatchedDataCard({
    super.key,
    required this.index,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColor.WHITE,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.YELLOW.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${'booking.booking'.tr()} ${index + 1}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (data.confidence != null) ...[
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getConfidenceColor(data.confidence!)
                          .withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${(data.confidence! * 100).toStringAsFixed(0)}%',
                      style: TextStyle(
                        color: _getConfidenceColor(data.confidence!),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildInfoRow('booking.guest_name'.tr(), data.guestName),
            if (data.phoneNumber != null)
              _buildInfoRow('booking.phone'.tr(), data.phoneNumber!),
            if (data.hotelName != null)
              _buildInfoRow('booking.hotel'.tr(), data.hotelName!),
            if (data.room != null)
              _buildInfoRow('booking.room'.tr(), '${data.room}'),
            if (data.agentName != null)
              _buildInfoRow('booking.agent'.tr(), data.agentName!),
            if (data.locationName != null)
              _buildInfoRow('booking.location'.tr(), data.locationName!),
            if (data.services.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                'booking.services'.tr(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...data.services.map((service) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      '  • ${service.serviceName}',
                      style: TextStyle(
                        color: service.matched == false
                            ? Colors.orange
                            : AppColor.BLACK,
                      ),
                    ),
                  )),
            ],
            if (data.finalPrice != null)
              _buildInfoRow(
                'booking.final_price'.tr(),
                '${data.finalPrice!.toStringAsFixed(2)} ${data.currencyName ?? ''}',
              ),
            if (data.warnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...data.warnings.map((warning) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning, color: Colors.orange, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            warning,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.orange,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
            if (data.errors.isNotEmpty) ...[
              const SizedBox(height: 12),
              ...data.errors.map((error) => Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            error,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                color: AppColor.GRAY_HULF,
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getConfidenceColor(double confidence) {
    if (confidence >= 0.8) return Colors.green;
    if (confidence >= 0.6) return Colors.orange;
    return Colors.red;
  }
}

