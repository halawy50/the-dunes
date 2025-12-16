import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BaseTableLoadMoreButton extends StatelessWidget {
  const BaseTableLoadMoreButton({
    super.key,
    required this.hasMore,
    required this.onLoadMore,
    this.isLoading = false,
  });

  final bool hasMore;
  final VoidCallback onLoadMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Center(
        child: ElevatedButton(
          onPressed: isLoading ? null : onLoadMore,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.YELLOW,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(AppColor.WHITE),
                  ),
                )
              : Text('common.load_more'.tr()),
        ),
      ),
    );
  }
}

