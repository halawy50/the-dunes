import 'package:flutter/material.dart';

class CampScrollHandler {
  static void handleDragUpdate(
    ScrollController scrollController,
    double dragStartPosition,
    double dragStartScrollPosition,
    double localPosition,
  ) {
    if (!scrollController.hasClients) return;

    final pos = scrollController.position;
    final maxScrollValue = pos.maxScrollExtent;
    final viewportWidthValue = pos.viewportDimension;

    if (maxScrollValue <= 0 || viewportWidthValue <= 0) return;

    final contentWidthValue = maxScrollValue + viewportWidthValue;
    final indicatorWidthValue = (viewportWidthValue / contentWidthValue) * viewportWidthValue;
    final maxPositionValue = (viewportWidthValue - indicatorWidthValue).clamp(0.0, viewportWidthValue);

    if (maxPositionValue <= 0) return;

    final dragDelta = localPosition - dragStartPosition;
    final scrollDelta = (dragDelta / maxPositionValue) * maxScrollValue;
    final newScrollPosition = (dragStartScrollPosition + scrollDelta)
        .clamp(0.0, maxScrollValue);

    scrollController.jumpTo(newScrollPosition);
  }
}

