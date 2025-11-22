import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_dropdown_helpers.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';
import 'package:the_dunes/features/booking/persentation/cubit/new_booking_cubit.dart';
import 'package:the_dunes/features/booking/persentation/models/new_booking_row.dart';

class NewBookDropdownsLocationAgent {
  static Widget buildLocationDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit,
  ) {
    // Get locations directly from cubit - no need for BlocBuilder here
    // since locations are loaded once on init and don't change
    final locations = cubit.locations;
    if (locations.isEmpty) {
      return Text(
        'booking.loading'.tr(),
        style: const TextStyle(fontSize: 13, color: AppColor.GRAY_HULF),
      );
    }
    
    final locationIds = locations.map((l) => l.id).toList();
    
    // Add "Global" option (id = -1) as a special option
    const int globalLocationId = -1;
    final allLocationIds = [globalLocationId, ...locationIds];
    
    // Handle current value - check if it's Global or a regular location
    int? currentValue;
    if (row.location?.id == globalLocationId || 
        (row.location?.name.toLowerCase().trim() == 'global')) {
      currentValue = globalLocationId;
      // Set a special location object for Global
      if (row.location?.id != globalLocationId) {
        row.location = LocationModel(id: globalLocationId, name: 'Global');
      }
    } else {
      currentValue = row.location?.id;
    }
    
    // Ensure current value exists in items list
    if (currentValue != null && !allLocationIds.contains(currentValue)) {
      row.location = null;
      currentValue = null;
    }
    
    return BaseTableDropdownHelpers.modelDropdown<int>(
      value: currentValue,
      items: allLocationIds,
      hint: 'booking.location',
      onChanged: (value) async {
        if (value != null) {
          // Handle Global location (id = -1)
          if (value == globalLocationId) {
            row.location = LocationModel(id: globalLocationId, name: 'Global');
          } else {
            final selectedLocation = locations.firstWhere(
              (l) => l.id == value,
              orElse: () => locations.first,
            );
            row.location = selectedLocation;
          }
          
          // Only clear the serviceAgent selections, but keep the service rows
          // This ensures the sub-rows remain visible with their adult/child/kid counts
          for (var service in row.services) {
            service.serviceAgent = null; // Clear selection only
            // Keep adult, child, kid counts - user might have entered them already
          }
          
          // Check if selected location is "Global" or "General"
          final isGlobalLocation = value == globalLocationId || 
                                   row.location?.name.toLowerCase().trim() == 'global';
          final isGeneralLocation = row.location?.name.toLowerCase().trim() == 'general';
          
          // Fetch services automatically if both agent and location are selected
          if (row.location != null && row.agent != null && 
              (isGlobalLocation || isGeneralLocation)) {
            print('[LocationDropdown] ℹ️ Global/General location selected - fetching global services for agent: ${row.agent!.id}');
            // For "Global" or "General" location, fetch services that don't have a location
            cubit.getServicesForAgentOnly(row.agent!.id);
          } else if (row.location != null && row.agent != null) {
            print('[LocationDropdown] 🔄 Fetching new services for agent: ${row.agent!.id}, location: ${row.location!.id}');
            // Trigger service fetch - this will show loading and update cache
            // The service dropdown will update automatically via BlocBuilder
            cubit.getServicesForAgentAndLocation(
              row.agent!.id,
              row.location!.id,
            );
          }
          
          // Always update row to trigger UI rebuild
          cubit.updateBookingRow(index, row);
        } else {
          row.location = null;
          // Only clear selections when location is cleared
          for (var service in row.services) {
            service.serviceAgent = null;
          }
          cubit.updateBookingRow(index, row);
        }
      },
      getDisplayText: (id) {
        // Handle Global location (id = -1)
        if (id == globalLocationId) {
          return 'booking.global'.tr();
        }
        try {
          final location = locations.firstWhere((l) => l.id == id);
          return location.name;
        } catch (e) {
          return '';
        }
      },
    );
  }

  static Widget buildAgentDropdown(
    BuildContext context,
    NewBookingRow row,
    int index,
    NewBookingCubit cubit, {
    bool hasError = false,
  }) {
    // Get agents directly from cubit - no need for BlocBuilder here
    // since agents are loaded once on init and don't change
    final agents = cubit.agents;
    if (agents.isEmpty) {
      return Text(
        'booking.loading'.tr(),
        style: const TextStyle(fontSize: 13, color: AppColor.GRAY_HULF),
      );
    }
    
    final agentIds = agents.map((a) => a.id).toList();
    final currentValue = row.agent?.id;
    
    // Ensure current value exists in items list
    if (currentValue != null && !agentIds.contains(currentValue)) {
      row.agent = null;
    }
    
    return BaseTableDropdownHelpers.modelDropdown<int>(
      value: row.agent?.id,
      items: agentIds,
      hint: 'booking.agent_name',
      hasError: hasError,
      onChanged: (value) async {
        if (value != null) {
          final selectedAgent = agents.firstWhere(
            (a) => a.id == value,
            orElse: () => agents.first,
          );
          row.agent = selectedAgent;
          
          // Only clear the serviceAgent selections, but keep the service rows
          // This ensures the sub-rows remain visible with their adult/child/kid counts
          for (var service in row.services) {
            service.serviceAgent = null; // Clear selection only
            // Keep adult, child, kid counts - user might have entered them already
          }
          
          // Fetch services automatically if both agent and location are selected
          // This will trigger loading state and update cache
          if (row.location != null && row.agent != null) {
            final isGeneralLocation = row.location!.name.toLowerCase().trim() == 'general';
            if (isGeneralLocation) {
              print('[AgentDropdown] 🔄 Fetching services without location for agent: ${row.agent!.id}');
              // For "General" location, fetch services that don't have a location
              cubit.getServicesForAgentOnly(row.agent!.id);
            } else {
              print('[AgentDropdown] 🔄 Fetching new services for agent: ${row.agent!.id}, location: ${row.location!.id}');
              // Trigger service fetch - this will show loading and update cache
              // The service dropdown will update automatically via BlocBuilder
              cubit.getServicesForAgentAndLocation(
                row.agent!.id,
                row.location!.id,
              );
            }
          } else if (row.agent != null && row.location == null) {
            print('[AgentDropdown] 🔄 Agent selected without location - fetching services without location for agent: ${row.agent!.id}');
            // If agent is selected but no location, fetch services without location
            cubit.getServicesForAgentOnly(row.agent!.id);
          }
          
          // Always update row to trigger UI rebuild
          cubit.updateBookingRow(index, row);
        } else {
          row.agent = null;
          // Only clear selections when agent is cleared
          for (var service in row.services) {
            service.serviceAgent = null;
          }
          cubit.updateBookingRow(index, row);
        }
      },
      getDisplayText: (id) {
        try {
          final agent = agents.firstWhere((a) => a.id == id);
          return agent.name;
        } catch (e) {
          return '';
        }
      },
    );
  }
}


