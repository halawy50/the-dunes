import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_content_body.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_content_state_handler.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_scroll_handler.dart';

class CampContentBuilder extends StatefulWidget {
  const CampContentBuilder({
    super.key,
    required this.scrollController,
  });

  final ScrollController scrollController;

  @override
  State<CampContentBuilder> createState() => _CampContentBuilderState();
}

class _CampContentBuilderState extends State<CampContentBuilder> {
  final ScrollController _horizontalScrollController = ScrollController();
  double _dragStartPosition = 0.0;
  double _dragStartScrollPosition = 0.0;
  CampDataEntity? _lastLoadedData;

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _handleDragStart(double position, double scrollPosition) {
    _dragStartPosition = position;
    _dragStartScrollPosition = scrollPosition;
  }

  void _handleDragUpdate(double localPosition) {
    CampScrollHandler.handleDragUpdate(
      _horizontalScrollController,
      _dragStartPosition,
      _dragStartScrollPosition,
      localPosition,
    );
  }

  Widget _buildContent(CampDataEntity data) {
    return CampContentBody(
      scrollController: widget.scrollController,
      horizontalScrollController: _horizontalScrollController,
      data: data,
      dragStartPosition: _dragStartPosition,
      dragStartScrollPosition: _dragStartScrollPosition,
      onDragStart: _handleDragStart,
      onDragUpdate: _handleDragUpdate,
      onRefresh: () async {
        final cubit = context.read<CampCubit>();
        await cubit.refreshCampData();
      },
      onBookingStatusUpdate: (bookingId, status) async {
        final cubit = context.read<CampCubit>();
        await cubit.updateBookingStatus(bookingId, status);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CampCubit, CampState>(
      builder: (context, state) {
        if (state is CampLoaded) {
          _lastLoadedData = state.data;
        }
        return CampContentStateHandler.buildWidget(
          state,
          _lastLoadedData,
          _buildContent,
        );
      },
    );
  }
}

