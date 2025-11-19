import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/booking/persentation/widgets/booking_table_widget.dart';

class BookingScreenContent extends StatefulWidget {
  const BookingScreenContent({
    super.key,
    required this.selectedBookings,
    required this.searchQuery,
    required this.onBookingSelect,
    required this.onBookingEdit,
    required this.onSearchChanged,
  });

  final List<BookingModel> selectedBookings;
  final String searchQuery;
  final void Function(BookingModel, bool) onBookingSelect;
  final void Function(BookingModel, Map<String, dynamic>) onBookingEdit;
  final void Function(String) onSearchChanged;

  @override
  State<BookingScreenContent> createState() => _BookingScreenContentState();
}

class _BookingScreenContentState extends State<BookingScreenContent> {
  final ScrollController _pageScrollController = ScrollController();

  @override
  void dispose() {
    _pageScrollController.dispose();
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
    final cubit = context.read<BookingCubit>();
    final bookings = cubit.bookings?.data ?? [];
    final filteredBookings = _getFilteredBookings(bookings);
    final pagination = cubit.bookings?.pagination;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Scrollbar(
          controller: _pageScrollController,
          thumbVisibility: true,
          thickness: 8,
          radius: const Radius.circular(4),
          child: SingleChildScrollView(
            controller: _pageScrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Container(
                width: double.infinity,
                color: AppColor.GRAY_F6F6F6,
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BaseTableHeader(
                      onAdd: () => context.go('/booking/new'),
                      onDownload: () {},
                      onInvoice: () {},
                      onSearch: widget.onSearchChanged,
                      onFilter: () {},
                      addButtonText: 'booking.new_book'.tr(),
                      downloadButtonText: 'booking.download_sheet'.tr(),
                      invoiceButtonText: 'booking.invoice'.tr(),
                      searchHint: 'booking.search_by_name'.tr(),
                      filterButtonText: 'booking.filter'.tr(),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: constraints.maxHeight - 200,
                      child: BookingTableWidget(
                        bookings: filteredBookings,
                        selectedBookings: widget.selectedBookings,
                        onBookingSelect: widget.onBookingSelect,
                        onBookingEdit: widget.onBookingEdit,
                      ),
                    ),
                    if (pagination != null) ...[
                      const SizedBox(height: 12),
                      BaseTablePagination(
                        currentPage: pagination.currentPage,
                        totalPages: pagination.totalPages,
                        onPrevious: () {
                          if (pagination.currentPage > 1) {
                            cubit.loadBookings(page: pagination.currentPage - 1);
                          }
                        },
                        onNext: () {
                          if (pagination.currentPage < pagination.totalPages) {
                            cubit.loadBookings(page: pagination.currentPage + 1);
                          }
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

