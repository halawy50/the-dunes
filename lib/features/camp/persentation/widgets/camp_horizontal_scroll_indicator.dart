import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class CampHorizontalScrollIndicator extends StatefulWidget {
  const CampHorizontalScrollIndicator({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<CampHorizontalScrollIndicator> createState() =>
      _CampHorizontalScrollIndicatorState();
}

class _CampHorizontalScrollIndicatorState
    extends State<CampHorizontalScrollIndicator> {
  double _dragStartPosition = 0.0;
  double _dragStartScrollPosition = 0.0;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.scrollController,
      builder: (context, _) {
        try {
          if (!widget.scrollController.hasClients) {
            return const SizedBox.shrink();
          }

          final position = widget.scrollController.position;
          final maxScroll = position.maxScrollExtent;

          if (maxScroll <= 0 || maxScroll.isNaN || maxScroll.isInfinite) {
            return const SizedBox.shrink();
          }

          final currentScroll = position.pixels;
          final viewportWidth = position.viewportDimension;

          if (viewportWidth <= 0 || viewportWidth.isNaN || viewportWidth.isInfinite) {
            return const SizedBox.shrink();
          }

          final contentWidth = maxScroll + viewportWidth;
          final scrollPercentage = maxScroll > 0 ? currentScroll / maxScroll : 0.0;

          final indicatorWidth =
              (viewportWidth / contentWidth) * viewportWidth;
          final maxPosition =
              (viewportWidth - indicatorWidth).clamp(0.0, viewportWidth);
          final indicatorPosition = scrollPercentage * maxPosition;

          return Container(
            height: 12,
            margin: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColor.WHITE,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Stack(
              children: [
                Positioned(
                  left: indicatorPosition.clamp(0.0, maxPosition),
                  child: GestureDetector(
                    onPanStart: (details) {
                      if (!widget.scrollController.hasClients) return;
                      _dragStartPosition = details.localPosition.dx;
                      _dragStartScrollPosition =
                          widget.scrollController.position.pixels;
                    },
                    onPanUpdate: (details) {
                      if (!widget.scrollController.hasClients) return;

                      final pos = widget.scrollController.position;
                      final maxScrollValue = pos.maxScrollExtent;
                      final viewportWidthValue = pos.viewportDimension;

                      if (maxScrollValue <= 0 || viewportWidthValue <= 0) return;

                      final contentWidthValue =
                          maxScrollValue + viewportWidthValue;
                      final indicatorWidthValue =
                          (viewportWidthValue / contentWidthValue) *
                              viewportWidthValue;
                      final maxPositionValue =
                          (viewportWidthValue - indicatorWidthValue)
                              .clamp(0.0, viewportWidthValue);

                      if (maxPositionValue <= 0) return;

                      final dragDelta =
                          details.localPosition.dx - _dragStartPosition;
                      final scrollDelta =
                          (dragDelta / maxPositionValue) * maxScrollValue;
                      final newScrollPosition =
                          (_dragStartScrollPosition + scrollDelta)
                              .clamp(0.0, maxScrollValue);

                      widget.scrollController.jumpTo(newScrollPosition);
                    },
                    child: Container(
                      width: indicatorWidth.clamp(20.0, viewportWidth),
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppColor.YELLOW,
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        } catch (_) {
          return const SizedBox.shrink();
        }
      },
    );
  }
}


