import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/notibifaction/persentation/cubit/notification_cubit.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = sl<NotificationCubit>();
        cubit.init();
        return cubit;
      },
      child: BlocListener<NotificationCubit, NotificationState>(
        listener: (context, state) {
          if (state is NotificationSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: 'notification.success',
              type: SnackbarType.success,
            );
          } else if (state is NotificationError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('notification.title'.tr()),
            backgroundColor: AppColor.BLACK_0,
          ),
          body: BlocBuilder<NotificationCubit, NotificationState>(
            builder: (context, state) {
              if (state is NotificationLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const Center(
                child: Text('Notification Screen'),
              );
            },
          ),
        ),
      ),
    );
  }
}
