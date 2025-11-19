import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTablePagination extends StatelessWidget {
  const BaseTablePagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPrevious,
    required this.onNext,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: currentPage > 1 ? onPrevious : null,
          child: Text('common.previous'.tr()),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.YELLOW,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$currentPage',
            style: const TextStyle(
              color: AppColor.WHITE,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        TextButton(
          onPressed: currentPage < totalPages ? onNext : null,
          child: Text('common.next'.tr()),
        ),
      ],
    );
  }
}


