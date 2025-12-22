import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_data_content.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_horizontal_scroll_indicator.dart';

class CampContentBody extends StatelessWidget {
  const CampContentBody({
    super.key,
    required this.scrollController,
    required this.horizontalScrollController,
    required this.data,
    required this.onRefresh,
    required this.onBookingStatusUpdate,
  });

  final ScrollController scrollController;
  final ScrollController horizontalScrollController;
  final CampDataEntity data;
  final void Function() onRefresh;
  final void Function(int, String) onBookingStatusUpdate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColor.WHITE,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BaseTableHeader(
            onSearch: (_) {},
            onRefresh: onRefresh,
            hasActiveFilter: false,
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CampDataContent(
                  data: data,
                  onBookingStatusUpdate: onBookingStatusUpdate,
                ),
                CampHorizontalScrollIndicator(
                  scrollController: horizontalScrollController,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

