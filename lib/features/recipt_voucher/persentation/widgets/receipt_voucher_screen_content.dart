import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_table_widget.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_statistics_widget.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_filter_dialog.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_load_more_button.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';
import 'package:the_dunes/core/data/datasources/token_storage.dart';

class ReceiptVoucherScreenContent extends StatefulWidget {
  const ReceiptVoucherScreenContent({
    super.key,
    required this.selectedVouchers,
    required this.searchQuery,
    required this.onVoucherSelect,
    required this.onVoucherEdit,
    required this.onVoucherDelete,
    required this.onSearchChanged,
    required this.onDownloadPdf,
  });

  final List<ReceiptVoucherModel> selectedVouchers;
  final String searchQuery;
  final void Function(ReceiptVoucherModel, bool) onVoucherSelect;
  final void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit;
  final void Function(ReceiptVoucherModel) onVoucherDelete;
  final void Function(String) onSearchChanged;
  final Future<String> Function(int) onDownloadPdf;

  @override
  State<ReceiptVoucherScreenContent> createState() =>
      _ReceiptVoucherScreenContentState();
}

class _ReceiptVoucherScreenContentState
    extends State<ReceiptVoucherScreenContent> {
  final ScrollController _scrollController = ScrollController();
  final ScrollController _horizontalScrollController = ScrollController();
  int _previousPage = 1;
  double _dragStartPosition = 0.0;
  double _dragStartScrollPosition = 0.0;

  @override
  void dispose() {
    _scrollController.dispose();
    _horizontalScrollController.dispose();
    super.dispose();
  }

  List<ReceiptVoucherModel> _getFilteredVouchers(
      List<ReceiptVoucherModel> vouchers) {
    if (widget.searchQuery.isEmpty) return vouchers;
    return vouchers.where((voucher) {
      final query = widget.searchQuery.toLowerCase();
      return voucher.guestName.toLowerCase().contains(query) ||
          (voucher.phoneNumber != null &&
              voucher.phoneNumber!.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReceiptVoucherCubit, ReceiptVoucherState>(
      listener: (context, state) {
        final cubit = context.read<ReceiptVoucherCubit>();
        final currentPage = cubit.currentPage;

        if (currentPage != _previousPage) {
          _previousPage = currentPage;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients && mounted) {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      },
      child: BlocBuilder<ReceiptVoucherCubit, ReceiptVoucherState>(
        builder: (context, state) {
          final cubit = context.read<ReceiptVoucherCubit>();
          final vouchers = cubit.allVouchers;
          final filteredVouchers = _getFilteredVouchers(vouchers);
          final totalPrice = cubit.totalPrice;
          final totalCount = cubit.totalCount;
          final currentPage = cubit.currentPage;
          final totalPages = cubit.totalPages;

          final statistics = cubit.statistics;
          if (kDebugMode) {
            print('[ReceiptVoucherScreenContent] All vouchers count: ${vouchers.length}');
            print('[ReceiptVoucherScreenContent] Filtered vouchers count: ${filteredVouchers.length}');
            print('[ReceiptVoucherScreenContent] TotalPrice: $totalPrice');
            print('[ReceiptVoucherScreenContent] TotalCount: $totalCount');
            print('[ReceiptVoucherScreenContent] Statistics: $statistics');
            if (statistics != null) {
              print('[ReceiptVoucherScreenContent] Statistics - total: ${statistics.total}, completed: ${statistics.completed}, pending: ${statistics.pending}, accepted: ${statistics.accepted}, cancelled: ${statistics.cancelled}');
            } else {
              print('[ReceiptVoucherScreenContent] Statistics is NULL');
            }
          }

          return FutureBuilder(
            future: TokenStorage.getPermissions(),
            builder: (context, snapshot) {
              final permissions = snapshot.data;
              final canAdd = permissions?.addNewReceiptVoucherMe ?? false;
              final canEdit = permissions?.editReceiptVoucher ?? false;
              final canDelete = permissions?.deleteReceiptVoucher ?? false;

              return SingleChildScrollView(
                controller: _scrollController,
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: AppColor.WHITE,
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: BaseTableHeader(
                        onAdd: canAdd ? () => context.go('/receipt_voucher/new') : null,
                        onSearch: widget.onSearchChanged,
                        onRefresh: () async {
                          final cubit = context.read<ReceiptVoucherCubit>();
                          await cubit.refreshReceiptVouchers();
                        },
                        onFilter: () async {
                          final cubit = context.read<ReceiptVoucherCubit>();
                          final currentFilter = cubit.currentFilter;
                          final result = await showDialog(
                            context: context,
                            builder: (context) => ReceiptVoucherFilterDialog(
                              initialFilter: currentFilter,
                            ),
                          );
                          if (result == null) {
                            await cubit.clearFilter();
                          } else if (result.hasFilters) {
                            await cubit.applyFilter(result);
                          } else {
                            await cubit.clearFilter();
                          }
                        },
                        onClearFilter: () async {
                          final cubit = context.read<ReceiptVoucherCubit>();
                          await cubit.clearFilter();
                        },
                        hasActiveFilter: cubit.currentFilter != null &&
                            cubit.currentFilter!.hasFilters,
                        addButtonText: 'receipt_voucher.new_voucher'.tr(),
                        searchHint: 'receipt_voucher.search_by_name'.tr(),
                      ),
                    ),
                    if (statistics != null)
                      Container(
                        width: double.infinity,
                        color: AppColor.WHITE,
                        padding: const EdgeInsets.only(top: 15.0),
                        alignment: Alignment.centerLeft,
                        child: ReceiptVoucherStatisticsWidget(
                          key: ValueKey('stats_${statistics.total}_${statistics.completed}_${statistics.pending}_${statistics.accepted}_${statistics.cancelled}'),
                          statistics: statistics,
                        ),
                      ),
                    SingleChildScrollView(
                      controller: _horizontalScrollController,
                      physics: const ClampingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        color: AppColor.WHITE,
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (state is ReceiptVoucherLoading &&
                                  state is! ReceiptVoucherPageChanged &&
                                  state is! ReceiptVoucherUpdating &&
                                  state is! ReceiptVoucherDeleting)
                                Container(
                                  height: 400,
                                  alignment: Alignment.center,
                                  child: const CircularProgressIndicator(),
                                )
                              else
                                ReceiptVoucherTableWidget(
                                  vouchers: filteredVouchers,
                                  selectedVouchers: widget.selectedVouchers,
                                  onVoucherSelect: widget.onVoucherSelect,
                                  onVoucherEdit: canEdit
                                      ? widget.onVoucherEdit
                                      : (_, __) {},
                                  onVoucherDelete: canDelete
                                      ? widget.onVoucherDelete
                                      : (_) {},
                                  onDownloadPdf: widget.onDownloadPdf,
                                  canEdit: canEdit,
                                  canDelete: canDelete,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<ReceiptVoucherCubit, ReceiptVoucherState>(
                      builder: (context, state) {
                        final hasMore = currentPage < totalPages;
                        final isLoading = state is ReceiptVoucherLoading;
                        return BaseTableLoadMoreButton(
                          hasMore: hasMore,
                          isLoading: isLoading,
                          onLoadMore: () => cubit.loadMore(),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20.0),
                      child: BaseTablePagination(
                        currentPage: currentPage,
                        totalPages: totalPages,
                        onPrevious: () async {
                          await cubit.goToPreviousPage();
                        },
                        onNext: () async {
                          await cubit.goToNextPage();
                        },
                        onPageTap: (page) async {
                          await cubit.goToPage(page);
                        },
                      ),
                    ),
                    // Horizontal scroll indicator at the bottom of the page
                    _buildHorizontalScrollIndicator(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildHorizontalScrollIndicator() {
    return ListenableBuilder(
      listenable: _horizontalScrollController,
      builder: (context, _) {
        try {
          if (!_horizontalScrollController.hasClients) {
            return const SizedBox.shrink();
          }

          final position = _horizontalScrollController.position;
          final maxScroll = position.maxScrollExtent;
          
          // Only show indicator if content is scrollable
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
          
          // Calculate indicator width (proportional to viewport)
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
                      if (!_horizontalScrollController.hasClients) return;
                      _dragStartPosition = details.localPosition.dx;
                      _dragStartScrollPosition = _horizontalScrollController.position.pixels;
                    },
                    onPanUpdate: (details) {
                      if (!_horizontalScrollController.hasClients) return;
                      
                      final pos = _horizontalScrollController.position;
                      final maxScrollValue = pos.maxScrollExtent;
                      final viewportWidthValue = pos.viewportDimension;
                      
                      if (maxScrollValue <= 0 || viewportWidthValue <= 0) return;
                      
                      final contentWidthValue = maxScrollValue + viewportWidthValue;
                      final indicatorWidthValue = (viewportWidthValue / contentWidthValue) * viewportWidthValue;
                      final maxPositionValue = (viewportWidthValue - indicatorWidthValue).clamp(0.0, viewportWidthValue);
                      
                      if (maxPositionValue <= 0) return;
                      
                      final dragDelta = details.localPosition.dx - _dragStartPosition;
                      final scrollDelta = (dragDelta / maxPositionValue) * maxScrollValue;
                      final newScrollPosition = (_dragStartScrollPosition + scrollDelta)
                          .clamp(0.0, maxScrollValue);
                      
                      _horizontalScrollController.jumpTo(newScrollPosition);
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
          // If any error occurs, return empty widget
          return const SizedBox.shrink();
        }
      },
    );
  }
}

 