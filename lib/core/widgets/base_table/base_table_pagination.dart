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
    this.onPageTap,
  });

  final int currentPage;
  final int totalPages;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final void Function(int)? onPageTap;

  List<int> _getPageNumbers() {
    if (totalPages <= 7) {
      return List.generate(totalPages, (i) => i + 1);
    }
    
    final List<int> pages = [];
    if (currentPage <= 4) {
      for (int i = 1; i <= 5; i++) {
        pages.add(i);
      }
      pages.add(-1); // Ellipsis
      pages.add(totalPages);
    } else if (currentPage >= totalPages - 3) {
      pages.add(1);
      pages.add(-1); // Ellipsis
      for (int i = totalPages - 4; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      pages.add(-1); // Ellipsis
      for (int i = currentPage - 1; i <= currentPage + 1; i++) {
        pages.add(i);
      }
      pages.add(-1); // Ellipsis
      pages.add(totalPages);
    }
    return pages;
  }

  @override
  Widget build(BuildContext context) {
    if (totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final pageNumbers = _getPageNumbers();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: currentPage > 1 ? onPrevious : null,
          icon: const Icon(Icons.chevron_left),
          tooltip: 'common.previous'.tr(),
        ),
        const SizedBox(width: 8),
        ...pageNumbers.map((page) {
          if (page == -1) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '...',
                style: TextStyle(
                  color: AppColor.BLACK.withOpacity(0.5),
                  fontSize: 16,
                ),
              ),
            );
          }
          
          final isCurrentPage = page == currentPage;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: InkWell(
              onTap: onPageTap != null && !isCurrentPage
                  ? () => onPageTap!(page)
                  : null,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isCurrentPage ? AppColor.YELLOW : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$page',
                  style: TextStyle(
                    color: isCurrentPage ? AppColor.WHITE : AppColor.BLACK,
                    fontWeight: isCurrentPage ? FontWeight.bold : FontWeight.normal,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          );
        }),
        const SizedBox(width: 8),
        IconButton(
          onPressed: currentPage < totalPages ? onNext : null,
          icon: const Icon(Icons.chevron_right),
          tooltip: 'common.next'.tr(),
        ),
      ],
    );
  }
}


