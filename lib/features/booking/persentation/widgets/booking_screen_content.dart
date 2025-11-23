import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/booking/data/models/booking_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';
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
  final ScrollController _scrollController = ScrollController();

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
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        final cubit = context.read<BookingCubit>();
        final bookings = cubit.allBookings;
        final filteredBookings = _getFilteredBookings(bookings);
        final hasMore = cubit.hasMore;
        final isLoadingMore = state is BookingLoadingMore;

        return SingleChildScrollView(
          controller: _scrollController,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              // Dropdown ثابت عند horizontal scroll
              // Container(
              //   color: AppColor.GRAY_F6F6F6,
              //   padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.end,
              //     children: [
              //       DropdownButton<int>(
              //         value: cubit.pageSize,
              //         items: const [
              //           DropdownMenuItem(value: 50, child: Text('50')),
              //           DropdownMenuItem(value: 100, child: Text('100')),
              //           DropdownMenuItem(value: 150, child: Text('150')),
              //           DropdownMenuItem(value: 200, child: Text('200')),
              //           DropdownMenuItem(value: 250, child: Text('250')),
              //         ],
              //         onChanged: (value) {
              //           if (value != null) {
              //             cubit.setPageSize(value);
              //           }
              //         },
              //       ),
              //     ],
              //   ),
              // ),
              SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Align(
                    alignment: Alignment.topLeft,
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
                        BookingTableWidget(
                          bookings: filteredBookings,
                          selectedBookings: widget.selectedBookings,
                          onBookingSelect: widget.onBookingSelect,
                          onBookingEdit: widget.onBookingEdit,
                        ),
                        if (hasMore || isLoadingMore) ...[
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Center(
                              child: isLoadingMore
                                  ? const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : ElevatedButton(
                                      onPressed: () async {
                                        await cubit.loadMoreBookings();
                                        // Auto scroll to bottom after loading
                                        if (_scrollController.hasClients) {
                                          WidgetsBinding.instance.addPostFrameCallback((_) {
                                            _scrollController.animateTo(
                                              _scrollController.position.maxScrollExtent,
                                              duration: const Duration(milliseconds: 300),
                                              curve: Curves.easeOut,
                                            );
                                          });
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColor.YELLOW,
                                        foregroundColor: AppColor.WHITE,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 24,
                                          vertical: 12,
                                        ),
                                      ),
                                      child: Text('booking.load_more'.tr()),
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

