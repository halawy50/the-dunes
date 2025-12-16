import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_header.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_load_more_button.dart';
import 'package:the_dunes/core/widgets/base_table/base_table_pagination.dart';
import 'package:the_dunes/features/employees/domain/entities/employee_entity.dart';
import 'package:the_dunes/features/employees/persentation/cubit/employee_cubit.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_table_section.dart';
import 'package:the_dunes/features/employees/persentation/widgets/employee_horizontal_scroll_indicator.dart';

class EmployeeContentBody extends StatelessWidget {
  const EmployeeContentBody({
    super.key,
    required this.filteredEmployees,
    required this.state,
    required this.currentPage,
    required this.totalPages,
    required this.horizontalScrollController,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onSearchChanged,
  });

  final List<EmployeeEntity> filteredEmployees;
  final EmployeeState state;
  final int currentPage;
  final int totalPages;
  final ScrollController horizontalScrollController;
  final void Function(double, double) onDragStart;
  final void Function(double) onDragUpdate;
  final void Function(String) onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: AppColor.WHITE,
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: BaseTableHeader(
            onAdd: () => context.push('/employees/new'),
            onSearch: onSearchChanged,
            onRefresh: () async {
              final cubit = context.read<EmployeeCubit>();
              await cubit.refreshEmployees();
            },
            hasActiveFilter: false,
            addButtonText: 'employees.new_employee'.tr(),
            searchHint: 'employees.search_by_name'.tr(),
          ),
        ),
        SingleChildScrollView(
          controller: horizontalScrollController,
          physics: const ClampingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          child: Container(
            color: AppColor.WHITE,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is EmployeeLoading && state is! EmployeeLoaded)
                    Container(
                      height: 400,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  else
                    EmployeeTableSection(
                      filteredEmployees: filteredEmployees,
                      state: state,
                    ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        BlocBuilder<EmployeeCubit, EmployeeState>(
          builder: (context, state) {
            final hasMore = currentPage < totalPages;
            final isLoading = state is EmployeeLoading && state is! EmployeeLoaded;
            return BaseTableLoadMoreButton(
              hasMore: hasMore,
              isLoading: isLoading,
              onLoadMore: () => context.read<EmployeeCubit>().loadMore(),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: BaseTablePagination(
            currentPage: currentPage,
            totalPages: totalPages,
            onPrevious: () => context.read<EmployeeCubit>().goToPreviousPage(),
            onNext: () => context.read<EmployeeCubit>().goToNextPage(),
            onPageTap: (page) => context.read<EmployeeCubit>().goToPage(page),
          ),
        ),
        EmployeeHorizontalScrollIndicator(
          scrollController: horizontalScrollController,
          onDragStart: onDragStart,
          onDragUpdate: onDragUpdate,
        ),
      ],
    );
  }
}

