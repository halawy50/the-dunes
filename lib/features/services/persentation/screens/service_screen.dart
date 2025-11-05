import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/services/persentation/cubit/service_cubit.dart';

class ServiceScreen extends StatefulWidget {
  const ServiceScreen({super.key});

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

class _ServiceScreenState extends State<ServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<ServiceCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<ServiceCubit, ServiceState>(
        listener: (context, state) {
          if (state is ServiceSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'service.success',
              type: SnackbarType.success,
            );
          } else if (state is ServiceError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            if (state is ServiceLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            return const Padding(
              padding: EdgeInsets.all(24.0),
              child: Center(
                child: Text('Service Screen'),
              ),
            );
          },
        ),
      ),
    );
  }
}
