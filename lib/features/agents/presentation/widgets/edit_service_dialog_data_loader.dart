import 'package:the_dunes/features/agents/domain/entities/service_agent_entity.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_logic.dart';
import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogDataLoader {
  static Future<EditServiceDialogState> loadInitialState(
    ServiceAgentEntity service,
  ) async {
    final locations = await EditServiceDialogLogic.loadLocations();
    LocationModel? initialLocation;
    if (service.locationId != null && locations.isNotEmpty) {
      try {
        initialLocation = locations.firstWhere(
          (loc) => loc.id == service.locationId,
        );
      } catch (e) {
        initialLocation = null;
      }
    }
    return EditServiceDialogState(
      locations: locations,
      isGlobal: service.isGlobal,
      selectedLocation: initialLocation,
      isLoading: false,
    );
  }
}

