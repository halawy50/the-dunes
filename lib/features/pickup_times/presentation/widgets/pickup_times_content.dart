import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';
import 'package:the_dunes/features/pickup_times/domain/entities/vehicle_group_simple_entity.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';
import 'package:the_dunes/features/pickup_times/presentation/models/pickup_table_item.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_times_table_widget.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/assign_vehicle_dialog.dart';

class PickupTimesContent extends StatefulWidget {
  const PickupTimesContent({super.key});

  @override
  State<PickupTimesContent> createState() => _PickupTimesContentState();
}

class _PickupTimesContentState extends State<PickupTimesContent> {
  final ScrollController _scrollController = ScrollController();
  String _searchQuery = '';
  List<VehicleGroupSimpleEntity> _groups = [];
  VehicleGroupSimpleEntity? _selectedGroup;
  bool _isLoadingGroups = false;

  @override
  void initState() {
    super.initState();
    _loadGroups();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadGroups() async {
    if (!mounted) return;
    setState(() => _isLoadingGroups = true);
    try {
      final cubit = context.read<PickupTimesCubit>();
      final groups = await cubit.getVehicleGroups();
      if (mounted) {
        setState(() {
          _groups = groups;
          _isLoadingGroups = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingGroups = false);
      }
    }
  }

  Future<void> _handleAddToSelectedGroup() async {
    if (_selectedGroup == null) return;
    
    final cubit = context.read<PickupTimesCubit>();
    final state = cubit.state;
    
    if (state is! PickupTimesLoaded) return;
    
    final selectedIds = state.selectedItemIds;
    if (selectedIds.isEmpty) return;

    final allItems = _getAllItems(state);
    
    final selectedItems = allItems.where((item) {
      final itemId = item.type == 'booking'
          ? 'booking_${item.booking!.id}'
          : 'voucher_${item.voucher!.id}';
      return selectedIds.contains(itemId);
    }).toList();

    // تخزين بيانات الحجوزات المحددة واسم ورقم العربية
    final bookingIds = selectedItems
        .where((item) => item.type == 'booking')
        .map((item) => item.booking!.id)
        .toList();
    final voucherIds = selectedItems
        .where((item) => item.type == 'voucher')
        .map((item) => item.voucher!.id)
        .toList();

    if (bookingIds.isEmpty && voucherIds.isEmpty) {
      return;
    }

    // التحقق من أن carNumber موجود
    if (_selectedGroup!.carNumber == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('pickup_times.car_number_required'.tr()),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // إزالة العناصر المحددة من مجموعاتها القديمة أولاً
    if (bookingIds.isNotEmpty || voucherIds.isNotEmpty) {
      await cubit.removeAssignment(
        bookingIds: bookingIds.isNotEmpty ? bookingIds : null,
        voucherIds: voucherIds.isNotEmpty ? voucherIds : null,
      );
    }

    // ثم إضافة العناصر للمجموعة المحددة وتحديث بيانات السائق
    await cubit.updateAssignment(
      pickupGroupId: _selectedGroup!.pickupGroupId,
      carNumber: _selectedGroup!.carNumber,
      driver: _selectedGroup!.driver,
      addBookingIds: bookingIds.isNotEmpty ? bookingIds : null,
      addVoucherIds: voucherIds.isNotEmpty ? voucherIds : null,
    );
    
    if (mounted) {
      await _loadGroups();
      setState(() {
        _selectedGroup = null;
      });
    }
  }

  List<PickupTableItem> _getAllItems(PickupTimesLoaded state) {
    final cubit = context.read<PickupTimesCubit>();
    final recentlyAddedIds = cubit.recentlyAddedItemIds;
    final items = <PickupTableItem>[];
    
    // إضافة العناصر من المجموعات أولاً (مرتبة حسب المجموعة)
    for (final group in state.pickupTimes.vehicleGroups) {
      final groupItems = <PickupTableItem>[];
      final recentlyAddedInGroup = <PickupTableItem>[];
      
      // جمع جميع عناصر المجموعة
      for (final booking in group.bookings) {
        final item = PickupTableItem(
          type: 'booking',
          booking: booking,
          pickupGroupId: group.pickupGroupId,
          carNumber: group.carNumber,
          driver: group.driver,
        );
        final itemId = 'booking_${booking.id}';
        if (recentlyAddedIds.contains(itemId)) {
          recentlyAddedInGroup.add(item);
        } else {
          groupItems.add(item);
        }
      }
      for (final voucher in group.vouchers) {
        final item = PickupTableItem(
          type: 'voucher',
          voucher: voucher,
          pickupGroupId: group.pickupGroupId,
          carNumber: group.carNumber,
          driver: group.driver,
        );
        final itemId = 'voucher_${voucher.id}';
        if (recentlyAddedIds.contains(itemId)) {
          recentlyAddedInGroup.add(item);
        } else {
          groupItems.add(item);
        }
      }
      
      // إضافة العناصر المضافة حديثاً أولاً، ثم العناصر الأخرى
      items.addAll(recentlyAddedInGroup);
      items.addAll(groupItems);
    }
    
    // إضافة العناصر غير المخصصة في النهاية
    for (final booking in state.pickupTimes.unassigned.bookings) {
      items.add(PickupTableItem(type: 'booking', booking: booking));
    }
    for (final voucher in state.pickupTimes.unassigned.vouchers) {
      items.add(PickupTableItem(type: 'voucher', voucher: voucher));
    }
    
    return items;
  }

  List<PickupTableItem> _getFilteredItems(List<PickupTableItem> items) {
    if (_searchQuery.isEmpty) return items;
    return items.where((item) {
      final query = _searchQuery.toLowerCase();
      return item.guestName.toLowerCase().contains(query) ||
          item.phoneNumber.toLowerCase().contains(query);
    }).toList();
  }

  void _handleItemSelect(PickupTableItem item, bool isSelected) {
    final itemId = item.type == 'booking'
        ? 'booking_${item.booking!.id}'
        : 'voucher_${item.voucher!.id}';
    context.read<PickupTimesCubit>().toggleItemSelection(itemId);
  }

  void _handleItemStatusUpdate(PickupTableItem item, String newStatus, String statusType) {
    final cubit = context.read<PickupTimesCubit>();
    if (item.booking != null) {
      // Use the new pickup-time endpoint for booking status updates
      cubit.updateStatusFromPickupTime(
        id: item.booking!.id,
        type: 'booking',
        status: newStatus,
        statusType: statusType,
      );
    } else if (item.voucher != null) {
      // Use the new pickup-time endpoint for voucher status updates
      cubit.updateStatusFromPickupTime(
        id: item.voucher!.id,
        type: 'voucher',
        status: newStatus,
        statusType: statusType,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PickupTimesCubit, PickupTimesState>(
      listener: (context, state) {
        if (state is PickupTimesSuccess && mounted) {
          _loadGroups();
        }
      },
      child: BlocBuilder<PickupTimesCubit, PickupTimesState>(
        builder: (context, state) {
        if (state is PickupTimesLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is PickupTimesError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(state.message),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<PickupTimesCubit>().loadPickupTimes();
                  },
                  child: Text('pickup_times.refresh'.tr()),
                ),
              ],
            ),
          );
        }

        if (state is! PickupTimesLoaded) {
          return Center(child: Text('pickup_times.loading'.tr()));
        }

        final allItems = _getAllItems(state);
        final filteredItems = _getFilteredItems(allItems);
        final totalPages = (filteredItems.length / state.pageSize).ceil();
        final startIndex = (state.currentPage - 1) * state.pageSize;
        final endIndex = startIndex + state.pageSize;
        final paginatedItems = filteredItems.sublist(
          startIndex.clamp(0, filteredItems.length),
          endIndex.clamp(0, filteredItems.length),
        );

        // Get selected items from cubit state
        final selectedItemsFromState = paginatedItems.where((item) {
          final itemId = item.type == 'booking'
              ? 'booking_${item.booking!.id}'
              : 'voucher_${item.voucher!.id}';
          return state.selectedItemIds.contains(itemId);
        }).toList();

        return SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              Container(
                color: AppColor.WHITE,
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: BaseTableHeader(
                  onSearch: (query) {
                    setState(() => _searchQuery = query);
                  },
                  onRefresh: () {
                    context.read<PickupTimesCubit>().loadPickupTimes();
                    _loadGroups();
                  },
                  searchHint: 'pickup_times.search'.tr(),
                  hasActiveFilter: false,
                ),
              ),
              Container(
                color: AppColor.WHITE,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    if (state.selectedItemIds.isNotEmpty) ...[
                      Text(
                        '${state.selectedItemIds.length} ${'pickup_times.items_selected'.tr()}',
                      ),
                      const Spacer(),
                      if (_groups.isNotEmpty) ...[
                        SizedBox(
                          width: 250,
                          child: _isLoadingGroups
                              ? const Center(child: CircularProgressIndicator())
                              : DropdownButton<VehicleGroupSimpleEntity>(
                                  value: _selectedGroup,
                                  isExpanded: true,
                                  hint: Text('pickup_times.select_group'.tr()),
                                  items: _groups.map((group) {
                                    final displayText = group.carNumber != null
                                        ? '${'pickup_times.car_number'.tr()}: ${group.carNumber}'
                                        : '';
                                    final driverText = group.driver != null &&
                                            group.driver!.isNotEmpty
                                        ? '${'pickup_times.driver'.tr()}: ${group.driver}'
                                        : '';
                                    final itemsText =
                                        '${'pickup_times.total_items'.tr()}: ${group.totalItems}';
                                    final fullText = [displayText, driverText, itemsText]
                                        .where((t) => t.isNotEmpty)
                                        .join(' - ');
                                    return DropdownMenuItem<VehicleGroupSimpleEntity>(
                                      value: group,
                                      child: Text(fullText),
                                    );
                                  }).toList(),
                                  onChanged: (group) {
                                    setState(() {
                                      _selectedGroup = group;
                                    });
                                  },
                                ),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: _selectedGroup == null
                              ? null
                              : () => _handleAddToSelectedGroup(),
                          icon: const Icon(Icons.add),
                          label: Text('pickup_times.add_to_group'.tr()),
                        ),
                        const SizedBox(width: 8),
                      ],
                      if (state.selectedItemIds.isNotEmpty) ...[
                        OutlinedButton.icon(
                          onPressed: () {
                            context.read<PickupTimesCubit>().clearSelection();
                            setState(() {
                              _selectedGroup = null;
                            });
                          },
                          icon: const Icon(Icons.clear),
                          label: Text('common.clear'.tr()),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton.icon(
                          onPressed: () {
                            final cubit = context.read<PickupTimesCubit>();
                            showDialog(
                              context: context,
                              builder: (dialogContext) => BlocProvider.value(
                                value: cubit,
                                child: const AssignVehicleDialog(),
                              ),
                            );
                          },
                          icon: const Icon(Icons.add),
                          label: Text('pickup_times.create_group'.tr()),
                        ),
                      ],
                    ] else
                      const Spacer(),
                  ],
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: PickupTimesTableWidget(
                    items: paginatedItems,
                    selectedItems: selectedItemsFromState,
                    onItemSelect: _handleItemSelect,
                    onItemStatusUpdate: _handleItemStatusUpdate,
                    allItems: filteredItems,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: BaseTablePagination(
                  currentPage: state.currentPage,
                  totalPages: totalPages > 0 ? totalPages : 1,
                  onPrevious: () {
                    if (state.currentPage > 1) {
                      context.read<PickupTimesCubit>().setPage(state.currentPage - 1);
                    }
                  },
                  onNext: () {
                    if (state.currentPage < totalPages) {
                      context.read<PickupTimesCubit>().setPage(state.currentPage + 1);
                    }
                  },
                  onPageTap: (page) {
                    context.read<PickupTimesCubit>().setPage(page);
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


