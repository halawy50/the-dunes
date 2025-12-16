import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/dependency_injection/injection_container.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_cubit.dart';
import 'package:the_dunes/features/pickup_times/presentation/cubit/pickup_times_state.dart';
import 'package:the_dunes/features/pickup_times/presentation/widgets/pickup_times_content.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/cubit/receipt_voucher_cubit.dart';
import 'package:the_dunes/features/booking/persentation/cubit/booking_cubit.dart';

class PickupTimesScreen extends StatefulWidget {
  const PickupTimesScreen({super.key});

  @override
  State<PickupTimesScreen> createState() => _PickupTimesScreenState();
}

class _PickupTimesScreenState extends State<PickupTimesScreen> {
  StreamSubscription<ReceiptVoucherState>? _receiptVoucherSubscription;
  StreamSubscription<BookingState>? _bookingSubscription;

  @override
  void initState() {
    super.initState();
    // We'll set up subscriptions after the cubit is created in build()
  }

  @override
  void dispose() {
    _receiptVoucherSubscription?.cancel();
    _bookingSubscription?.cancel();
    super.dispose();
  }

  void _setupSubscriptions(PickupTimesCubit pickupTimesCubit) {
    // Cancel existing subscriptions
    _receiptVoucherSubscription?.cancel();
    _bookingSubscription?.cancel();
    
    // Get shared singleton cubits from dependency injection
    final receiptVoucherCubit = di<ReceiptVoucherCubit>();
    final bookingCubit = di<BookingCubit>();
    
    // Listen to receipt voucher state changes
    _receiptVoucherSubscription = receiptVoucherCubit.stream.listen((state) {
      if (state is ReceiptVoucherSuccess && state.timestamp != DateTime(0)) {
        pickupTimesCubit.loadPickupTimes();
      }
    });
    
    // Listen to booking state changes
    _bookingSubscription = bookingCubit.stream.listen((state) {
      if (state is BookingSuccess) {
        pickupTimesCubit.loadPickupTimes();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = di<PickupTimesCubit>();
        cubit.loadPickupTimes();
        // Set up subscriptions after cubit is created
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _setupSubscriptions(cubit);
        });
        return cubit;
      },
      child: BlocListener<PickupTimesCubit, PickupTimesState>(
        listener: (context, state) {
          if (state is PickupTimesSuccess) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.success,
            );
          } else if (state is PickupTimesError) {
            AppSnackbar.showTranslated(
              context: context,
              translationKey: state.message,
              type: SnackbarType.error,
            );
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.GRAY_F6F6F6,
          body: BlocBuilder<PickupTimesCubit, PickupTimesState>(
            builder: (context, state) {
              if (state is PickupTimesLoading) {
                return Container(
                  color: AppColor.GRAY_F6F6F6,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }

              if (state is PickupTimesError) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.message,
                          style: const TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () {
                            context.read<PickupTimesCubit>().loadPickupTimes();
                          },
                          icon: const Icon(Icons.refresh),
                          label: Text('pickup_times.refresh'.tr()),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is PickupTimesInitial) {
                return Center(
                  child: Text('pickup_times.loading'.tr()),
                );
              }

              return const PickupTimesContent();
            },
          ),
        ),
      ),
    );
  }
}

