import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/features/services/domain/entities/service_entity.dart';
import 'package:the_dunes/features/services/persentation/cubit/service_cubit.dart';
import 'package:the_dunes/features/services/persentation/widgets/service_table_widget.dart';
import 'package:the_dunes/features/services/persentation/widgets/service_form_dialog.dart';

class ServiceScreenContent extends StatefulWidget {
  const ServiceScreenContent({super.key});

  @override
  State<ServiceScreenContent> createState() => _ServiceScreenContentState();
}

class _ServiceScreenContentState extends State<ServiceScreenContent> {
  String _searchQuery = '';

  List<ServiceEntity> _filterServices(
    List<ServiceEntity> services,
    String query,
  ) {
    if (query.isEmpty) return services;
    final lowerQuery = query.toLowerCase();
    return services.where((service) {
      return service.name.toLowerCase().contains(lowerQuery) ||
          (service.description?.toLowerCase().contains(lowerQuery) ?? false);
    }).toList();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ServiceCubit>(),
        child: const ServiceFormDialog(),
      ),
    );
  }

  void _showEditDialog(ServiceEntity service) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ServiceCubit>(),
        child: ServiceFormDialog(service: service),
      ),
    );
  }

  void _showDeleteDialog(ServiceEntity service) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('common.delete_confirmation'.tr()),
        content: Text('services.delete_confirmation_message'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('common.no'.tr()),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<ServiceCubit>().deleteService(service.id);
              Navigator.of(dialogContext).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('common.yes'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceCubit, ServiceState>(
      listener: (context, state) {
        if (state is ServiceSuccess) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: state.message,
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
          final cubit = context.read<ServiceCubit>();
          final services = state is ServiceLoaded
              ? state.services
              : <ServiceEntity>[];
          final filteredServices = _filterServices(services, _searchQuery);

          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: BaseTableHeader(
                    onAdd: _showAddDialog,
                    onSearch: (query) {
                      setState(() {
                        _searchQuery = query;
                      });
                    },
                    onRefresh: () async {
                      await cubit.refreshServices();
                    },
                    hasActiveFilter: false,
                    addButtonText: 'services.add_service'.tr(),
                    searchHint: 'services.search_by_name'.tr(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  color: AppColor.WHITE,
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (state is ServiceLoading &&
                          state is! ServiceLoaded)
                        Container(
                          height: 400,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        )
                      else
                        ServiceTableWidget(
                          services: filteredServices,
                          onEdit: _showEditDialog,
                          onDelete: _showDeleteDialog,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}


