import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';
import 'package:the_dunes/features/camp/persentation/widgets/camp_content_builder.dart';

class CampScreen extends StatefulWidget {
  const CampScreen({super.key});

  @override
  State<CampScreen> createState() => _CampScreenState();
}

class _CampScreenState extends State<CampScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<CampCubit>();
        cubit.loadCampData();
        return cubit;
      },
      child: BlocListener<CampCubit, CampState>(
        listener: (context, state) {
          if (state is CampSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.success,
            );
          } else if (state is CampError) {
            final errorMessage = state.message.replaceAll('ApiException: ', '');
            if (errorMessage.isNotEmpty) {
              AppSnackbar.show(
                context: context,
                message: errorMessage,
                type: SnackbarType.error,
              );
            }
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.WHITE,
          body: CampContentBuilder(
            scrollController: _scrollController,
          ),
        ),
      ),
    );
  }
}
