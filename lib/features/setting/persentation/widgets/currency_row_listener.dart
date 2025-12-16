import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/features/setting/persentation/cubit/setting_cubit.dart';

class CurrencyRowListener extends StatelessWidget {
  final bool isSaving;
  final Function(SettingLoaded)? onUpdateComplete;
  final VoidCallback onError;
  final Widget child;

  const CurrencyRowListener({
    super.key,
    required this.isSaving,
    required this.onUpdateComplete,
    required this.onError,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingCubit, SettingState>(
      listenWhen: (previous, current) {
        return isSaving && (current is SettingLoaded || current is SettingError);
      },
      listener: (context, state) {
        if (state is SettingLoaded && isSaving) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'setting.update_success',
            type: SnackbarType.success,
          );
          onUpdateComplete?.call(state);
        } else if (state is SettingError && isSaving) {
          onError();
        }
      },
      child: child,
    );
  }
}

