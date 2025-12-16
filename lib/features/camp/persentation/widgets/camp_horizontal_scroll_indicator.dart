import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class CampHorizontalScrollIndicator extends StatelessWidget {
  const CampHorizontalScrollIndicator({
    super.key,
    required this.scrollController,
    required this.dragStartPosition,
    required this.dragStartScrollPosition,
    required this.onDragStart,
    required this.onDragUpdate,
  });

  final ScrollController scrollController;
  final double dragStartPosition;
  final double dragStartScrollPosition;
  final void Function(double, double) onDragStart;
  final void Function(double) onDragUpdate;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: scrollController,
      builder: (context, _) {
        try {
          if (!scrollController.hasClients) {
            return const SizedBox.shrink();
          }

          final position = scrollController.position;
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

          final indicatorWidth = (viewportWidth / contentWidth) * viewportWidth;
          final maxPosition = (viewportWidth - indicatorWidth).clamp(0.0, viewportWidth);
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
                      if (!scrollController.hasClients) return;
                      onDragStart(details.localPosition.dx, scrollController.position.pixels);
                    },
                    onPanUpdate: (details) {
                      onDragUpdate(details.localPosition.dx);
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
        } catch (e) {
          return const SizedBox.shrink();
        }
      },
    );
  }
}

