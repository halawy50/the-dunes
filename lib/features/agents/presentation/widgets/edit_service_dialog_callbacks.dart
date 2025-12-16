import 'package:the_dunes/features/agents/presentation/widgets/edit_service_dialog_state.dart';
import 'package:the_dunes/features/booking/data/models/location_model.dart';

class EditServiceDialogCallbacks {
  final EditServiceDialogState Function() getState;
  final void Function(EditServiceDialogState) setState;

  EditServiceDialogCallbacks({
    required this.getState,
    required this.setState,
  });

  void onGlobalChanged(bool isGlobal) {
    setState(getState().copyWith(isGlobal: isGlobal));
  }

  void onLocationChanged(LocationModel? location) {
    setState(getState().copyWith(selectedLocation: location));
  }
}

