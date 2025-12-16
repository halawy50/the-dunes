import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_load_more_button.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';
import 'package:the_dunes/features/hotels/domain/entities/hotel_entity.dart';
import 'package:the_dunes/features/hotels/persentation/cubit/hotel_cubit.dart';
import 'package:the_dunes/features/hotels/persentation/widgets/hotel_table_widget.dart';
import 'package:the_dunes/features/hotels/persentation/widgets/add_hotel_dialog.dart';

class HotelScreenContent extends StatefulWidget {
  const HotelScreenContent({super.key});

  @override
  State<HotelScreenContent> createState() => _HotelScreenContentState();
}

class _HotelScreenContentState extends State<HotelScreenContent> {
  final ScrollController _scrollController = ScrollController();
  int _previousPage = 1;
  String _searchQuery = '';

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List<HotelEntity> _filterHotels(
    List<HotelEntity> hotels,
    String query,
  ) {
    if (query.isEmpty) return hotels;
    final lowerQuery = query.toLowerCase();
    return hotels.where((hotel) {
      return hotel.name.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<HotelCubit>(),
        child: const AddHotelDialog(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HotelCubit, HotelState>(
      listener: (context, state) {
        final cubit = context.read<HotelCubit>();
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

        if (state is HotelSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.success,
          );
        } else if (state is HotelError) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
            type: SnackbarType.error,
          );
        }
      },
      child: BlocBuilder<HotelCubit, HotelState>(
        builder: (context, state) {
          final cubit = context.read<HotelCubit>();
          final hotels = state is HotelLoaded ? state.hotels : <HotelEntity>[];
          final filteredHotels = _filterHotels(hotels, _searchQuery);
          final currentPage = cubit.currentPage;
          final totalPages = cubit.totalPages;

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
                    onAdd: _showAddDialog,
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onRefresh: () async {
                      await cubit.refreshHotels();
                    },
                    hasActiveFilter: false,
                    addButtonText: 'hotels.add_new'.tr(),
                    searchHint: 'hotels.search_by_name'.tr(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state is HotelLoading && state is! HotelLoaded)
                        Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      else
                        HotelTableWidget(
                          hotels: filteredHotels,
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                BlocBuilder<HotelCubit, HotelState>(
                  builder: (context, state) {
                    final hasMore = currentPage < totalPages;
                    final isLoading = state is HotelLoading && state is! HotelLoaded;
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
                      if (currentPage > 1) {
                        await cubit.loadHotels(page: currentPage - 1);
                      }
                    },
                    onNext: () async {
                      if (currentPage < totalPages) {
                        await cubit.loadHotels(page: currentPage + 1);
                      }
                    },
                    onPageTap: (page) async {
                      await cubit.loadHotels(page: page);
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

