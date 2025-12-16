import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/services/persentation/cubit/service_cubit.dart';
import 'package:the_dunes/features/services/persentation/widgets/service_screen_content.dart';

class ServiceScreen extends StatelessWidget {
  const ServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<ServiceCubit>();
        cubit.loadServices();
        return cubit;
      },
      child: const ServiceScreenContent(),
    );
  }
}
