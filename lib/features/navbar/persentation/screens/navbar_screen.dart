import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/navbar/persentation/cubit/navbar_cubit.dart';

class NavbarScreen extends StatefulWidget {
  const NavbarScreen({super.key});

  @override
  State<NavbarScreen> createState() => _NavbarScreenState();
}

class _NavbarScreenState extends State<NavbarScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<NavbarCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<NavbarCubit, NavbarState>(
        listener: (context, state) {
          if (state is NavbarSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'navbar.success',
              type: SnackbarType.success,
            );
          } else if (state is NavbarError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          body: BlocBuilder<NavbarCubit, NavbarState>(
            builder: (context, state) {
              if (state is NavbarLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('Navbar Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
