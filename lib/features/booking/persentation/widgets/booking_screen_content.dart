import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/data/models/booking_filter_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_table_widget.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_filter_dialog.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_statistics_widget.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';

class BookingScreenContent extends StatefulWidget {
  const BookingScreenContent({
    super.key,
    required this.selectedBookings,
    required this.searchQuery,
    required this.onBookingSelect,
    required this.onBookingEdit,
    required this.onBookingDelete,
    required this.onSearchChanged,
  });

  final List<BookingModel> selectedBookings;
  final String searchQuery;
  final void Function(BookingModel, bool) onBookingSelect;
  final void Function(BookingModel, Map<String, dynamic>) onBookingEdit;
  final void Function(BookingModel) onBookingDelete;
  final void Function(String) onSearchChanged;

  @override
  State<BookingScreenContent> createState() => _BookingScreenContentState();
}

class _BookingScreenContentState extends State<BookingScreenContent> {
  final ScrollController _scrollController = ScrollController();
  int _previousPage = 1;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<BookingModel> _getFilteredBookings(List<BookingModel> bookings) {
    if (widget.searchQuery.isEmpty) return bookings;
    return bookings.where((booking) {
      final query = widget.searchQuery.toLowerCase();
      return booking.guestName.toLowerCase().contains(query) ||
          (booking.phoneNumber != null &&
              booking.phoneNumber!.toLowerCase().contains(query)) ||
          (booking.voucher != null &&
              booking.voucher!.toLowerCase().contains(query));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingCubit, BookingState>(
      listener: (context, state) {
        final cubit = context.read<BookingCubit>();
        final currentPage = cubit.currentPage;
        
        // عند تغيير الصفحة، ننتقل لأول الصفحة
        if (currentPage != _previousPage) {
          _previousPage = currentPage;
          // Scroll to top عند تغيير الصفحة - نستخدم addPostFrameCallback للتأكد من تحديث الواجهة أولاً
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
      child: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          final cubit = context.read<BookingCubit>();
          final bookings = cubit.allBookings;
          final filteredBookings = _getFilteredBookings(bookings);
          final totalPrice = cubit.totalPrice;
          final totalCount = cubit.totalCount;
          final currentPage = cubit.currentPage;
          final totalPages = cubit.totalPages;
          
          // Debug: Log data for troubleshooting
          if (kDebugMode) {
            print('[BookingScreenContent] All bookings count: ${bookings.length}');
            print('[BookingScreenContent] Filtered bookings count: ${filteredBookings.length}');
            print('[BookingScreenContent] TotalPrice: $totalPrice');
            print('[BookingScreenContent] TotalCount: $totalCount');
            print('[BookingScreenContent] Current page: $currentPage, Total pages: $totalPages');
            print('[BookingScreenContent] State: ${state.runtimeType}');
          }

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header - جزء من الصفحة ويتحرك معها
              Container(
                color: AppColor.WHITE,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BaseTableHeader(
                  onAdd: () => context.go('/booking/new'),
                  onDownload: () {},
                  onInvoice: () {},
                  onSearch: widget.onSearchChanged,
                  onRefresh: () async {
                    final cubit = context.read<BookingCubit>();
                    await cubit.refreshBookings();
                  },
                  onFilter: () async {
                    final cubit = context.read<BookingCubit>();
                    final currentFilter = cubit.currentFilter;
                    final result = await showDialog<BookingFilterModel?>(
                      context: context,
                      builder: (context) => BookingFilterDialog(
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
                    final cubit = context.read<BookingCubit>();
                    await cubit.clearFilter();
                  },
                  hasActiveFilter: cubit.currentFilter != null &&
                      cubit.currentFilter!.hasFilters,
                  addButtonText: 'booking.new_book'.tr(),
                  downloadButtonText: 'booking.download_sheet'.tr(),
                  invoiceButtonText: 'booking.invoice'.tr(),
                  searchHint: 'booking.search_by_name'.tr(),
                  filterButtonText: 'booking.filter'.tr(),
                ),
              ),
              // عدد الحجوزات والسعر الكلي - جزء من الصفحة ويتحرك معها
              Container(
                width: double.infinity,
                color: AppColor.WHITE,
                padding: const EdgeInsets.only(top: 15.0),
                alignment: Alignment.centerLeft,
                child: BookingStatisticsWidget(
                  totalPrice: totalPrice,
                  totalCount: totalCount,
                ),
              ),
              // الجدول مع إمكانية السحب الأفقي
              SingleChildScrollView(
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
                        // إظهار loading في مكان الجدول فقط
                        if (state is BookingLoading && 
                            state is! BookingPageChanged &&
                            state is! BookingUpdating &&
                            state is! BookingDeleting)
                          Container(
                            height: 400,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          )
                        else
                          BookingTableWidget(
                            bookings: filteredBookings,
                            selectedBookings: widget.selectedBookings,
                            onBookingSelect: widget.onBookingSelect,
                            onBookingEdit: widget.onBookingEdit,
                            onBookingDelete: widget.onBookingDelete,
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
            ],
          ),
        );
        },
      ),
    );
  }
}
