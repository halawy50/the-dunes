import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_table_widget.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_voucher_table_widget.dart';

class CampDataContent extends StatelessWidget {
  const CampDataContent({
    super.key,
    required this.data,
    required this.horizontalScrollController,
    required this.onBookingStatusUpdate,
  });

  final CampDataEntity data;
  final ScrollController horizontalScrollController;
  final void Function(int, String) onBookingStatusUpdate;

  double _calculateTableWidth(bool isBooking) => isBooking ? 1180.0 : 1010.0;

  Widget _buildNoDataWidget() {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(child: Text('camp.no_data'.tr())),
    );
  }

  Widget _buildTableWrapper(Widget child, double? height, bool shouldFillWidth) {
    final container = Container(
      color: AppColor.WHITE,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: child,
    );

    if (shouldFillWidth) {
      return height != null ? SizedBox(height: height, child: container) : container;
    }

    final scrollView = SingleChildScrollView(
      controller: horizontalScrollController,
      physics: const ClampingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: container,
    );
    return height != null ? SizedBox(height: height, child: scrollView) : scrollView;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight.isFinite && constraints.maxHeight > 0
            ? constraints.maxHeight
            : null;
        final availableWidth = constraints.maxWidth - 48;
        final shouldFillBookings = availableWidth >= _calculateTableWidth(true);
        final shouldFillVouchers = availableWidth >= _calculateTableWidth(false);
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.bookings.isNotEmpty)
              _buildTableWrapper(
                CampTableWidget(
                  bookings: data.bookings,
                  onStatusUpdate: (booking, status) {
                    onBookingStatusUpdate(booking.id, status);
                  },
                  fillWidth: shouldFillBookings,
                ),
                height,
                shouldFillBookings,
              ),
            if (data.vouchers.isNotEmpty)
              _buildTableWrapper(
                CampVoucherTableWidget(
                  vouchers: data.vouchers,
                  fillWidth: shouldFillVouchers,
                ),
                height,
                shouldFillVouchers,
              ),
            if (data.bookings.isEmpty && data.vouchers.isEmpty)
              height != null
                  ? SizedBox(
                      height: height,
                      child: _buildNoDataWidget(),
                    )
                  : _buildNoDataWidget(),
          ],
        );
      },
    );
  }
}

