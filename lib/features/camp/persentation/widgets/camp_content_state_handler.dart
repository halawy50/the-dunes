import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/camp/domain/entities/camp_data_entity.dart';
import 'package:the_dunes/features/camp/persentation/cubit/camp_cubit.dart';

class CampContentStateHandler {
  static Widget buildWidget(
    CampState state,
    CampDataEntity? lastLoadedData,
    Widget Function(CampDataEntity) buildContent,
  ) {
    if (state is CampLoading) {
      if (lastLoadedData != null) {
        return buildContent(lastLoadedData);
      }
      return Container(
        color: AppColor.WHITE,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (state is CampLoaded) {
      return buildContent(state.data);
    }

    if (state is CampUpdatingBookingStatus) {
      if (lastLoadedData != null) {
        return buildContent(lastLoadedData);
      }
      return Container(
        color: AppColor.WHITE,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }

    if (state is CampError) {
      if (lastLoadedData != null) {
        return buildContent(lastLoadedData);
      }
      return Container(
        color: AppColor.WHITE,
        alignment: Alignment.center,
        child: Text('camp.error_loading'.tr()),
      );
    }

    return Container(
      color: AppColor.WHITE,
      alignment: Alignment.center,
      child: Text('camp.error_loading'.tr()),
    );
  }
}

