import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_cell.dart';
import 'package:the_dunes/features/booking/data/models/service_agent_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_service.dart';

class NewBookServiceDropdowns {
  static Widget buildServiceDropdown(
    BuildContext context,
    NewBookingService service,
    int serviceIndex,
    NewBookingRow row,
    int rowIndex,
    NewBookingCubit cubit,
  ) {
    return _ServiceDropdownStateful(
      key: ValueKey('service_dropdown_${rowIndex}_${serviceIndex}_${row.agent?.id ?? 'null'}_${row.location?.id ?? 'null'}'),
      service: service,
      serviceIndex: serviceIndex,
      row: row,
      rowIndex: rowIndex,
      cubit: cubit,
    );
  }
}

class _ServiceDropdownStateful extends StatefulWidget {
  final NewBookingService service;
  final int serviceIndex;
  final NewBookingRow row;
  final int rowIndex;
  final NewBookingCubit cubit;

  const _ServiceDropdownStateful({
    super.key,
    required this.service,
    required this.serviceIndex,
    required this.row,
    required this.rowIndex,
    required this.cubit,
  });

  @override
  State<_ServiceDropdownStateful> createState() => _ServiceDropdownStatefulState();
}

class _ServiceDropdownStatefulState extends State<_ServiceDropdownStateful> {
  @override
  Widget build(BuildContext context) {
    // Use BlocBuilder to rebuild whenever state changes (including when services are cached)
    return BlocBuilder<NewBookingCubit, NewBookingState>(
      // Remove buildWhen to ensure real-time updates
      builder: (context, state) {
        final newAgentId = widget.row.agent?.id;
        final newLocationId = widget.row.location?.id;
        
        // Always show dropdown, but disable it if agent not selected
        if (newAgentId == null) {
          return BaseTableDropdownCell<ServiceAgentModel>(
            value: null,
            items: [],
            hint: 'booking.select_agent',
            displayText: (item) => item.serviceName ?? 'booking.service'.tr(),
            onChanged: (_) {},
          );
        }

        // Check if location is "Global", "General" or null (services without location)
        final row = widget.row;
        final isGlobalLocation = row.location?.id == -1 || 
                                 row.location?.name.toLowerCase().trim() == 'global';
        final isGeneralLocation = row.location?.name.toLowerCase().trim() == 'general';
        final shouldGetServicesWithoutLocation = isGlobalLocation || 
                                                  isGeneralLocation || 
                                                  (newLocationId == null && row.location == null);

        // Check if we're currently loading services for this agent/location
        final isLoadingServices = state is NewBookingServicesLoading &&
            state.agentId == newAgentId &&
            ((shouldGetServicesWithoutLocation && state.locationId == null) ||
             (!shouldGetServicesWithoutLocation && state.locationId == newLocationId));
        
        // Always get fresh services from cache - this ensures we have latest data
        final services = widget.cubit.getServicesFromCache(newAgentId, shouldGetServicesWithoutLocation ? null : newLocationId);
        
        // If no services in cache and not already loading, trigger a fetch
        if (services.isEmpty && !isLoadingServices && state is! NewBookingLoading) {
          if (shouldGetServicesWithoutLocation) {
            widget.cubit.getServicesForAgentOnly(newAgentId);
          } else if (newLocationId != null) {
            widget.cubit.getServicesForAgentAndLocation(newAgentId, newLocationId);
          }
        }
        
        // Show loading indicator if services are being fetched
        // But keep the dropdown visible - just show loading text
        if (isLoadingServices) {
          return Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              border: Border.all(color: Colors.amber),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'booking.loading_services'.tr(),
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        
        // Find the selected service by ID
        ServiceAgentModel? selectedService;
        if (widget.service.serviceAgent != null && services.isNotEmpty) {
          try {
            selectedService = services.firstWhere(
              (s) => s.id == widget.service.serviceAgent!.id,
            );
          } catch (e) {
            // Service not found in new list - clear selection
            widget.service.serviceAgent = null;
            selectedService = null;
          }
        }

        // Clear service selection immediately if it doesn't exist in new services list
        // This ensures old data is removed when agent/location changes
        if (widget.service.serviceAgent != null && services.isNotEmpty) {
          final serviceExists = services.any(
            (s) => s.id == widget.service.serviceAgent!.id,
          );
          if (!serviceExists) {
            widget.service.serviceAgent = null;
            selectedService = null;
          }
        } else if (widget.service.serviceAgent != null && services.isEmpty) {
          widget.service.serviceAgent = null;
          selectedService = null;
        }

        // Filter out services that are already selected in other sub-rows of the same row
        // But keep the currently selected service in the list (if any)
        final currentlySelectedServiceId = widget.service.serviceAgent?.id;
        final selectedServiceIds = widget.row.services
            .where((s) => s.serviceAgent != null && s.serviceAgent!.id != currentlySelectedServiceId)
            .map((s) => s.serviceAgent!.id)
            .toSet();
        
        final availableServices = services.where((service) {
          // Include service if it's not selected in other sub-rows, or if it's the currently selected service
          return !selectedServiceIds.contains(service.id) || service.id == currentlySelectedServiceId;
        }).toList();

        return BaseTableDropdownCell<ServiceAgentModel>(
          key: ValueKey('service_dropdown_cell_${widget.rowIndex}_${widget.serviceIndex}_${newAgentId}_${newLocationId}_${availableServices.length}_${selectedServiceIds.length}'),
          value: selectedService,
          items: availableServices, // Filtered services (excluding already selected ones)
          hint: availableServices.isEmpty ? 'booking.no_services_available' : 'booking.select_service',
          displayText: (item) => item.serviceName ?? 'booking.service'.tr(),
          onChanged: (selectedService) {
            if (selectedService != null) {
              widget.service.serviceAgent = selectedService;
              widget.service.calculateTotal();
              widget.row.calculateTotals();
              widget.cubit.updateBookingRow(widget.rowIndex, widget.row);
            }
          },
        );
      },
    );
  }
}

// Removed _ServiceDropdownWidget - now using direct state management


