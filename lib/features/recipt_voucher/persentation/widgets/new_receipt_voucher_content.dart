import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/new_receipt_voucher_form.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/new_receipt_voucher_preview.dart';

class NewReceiptVoucherContent extends StatefulWidget {
  const NewReceiptVoucherContent({super.key});

  @override
  State<NewReceiptVoucherContent> createState() => _NewReceiptVoucherContentState();
}

class _NewReceiptVoucherContentState extends State<NewReceiptVoucherContent> {
  final ScrollController _formScrollController = ScrollController();
  final ScrollController _previewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _formScrollController.addListener(_syncScroll);
  }

  @override
  void dispose() {
    _formScrollController.removeListener(_syncScroll);
    _formScrollController.dispose();
    _previewScrollController.dispose();
    super.dispose();
  }

  bool _isSyncing = false;

  void _syncScroll() {
    if (_isSyncing) return;
    if (_formScrollController.hasClients && _previewScrollController.hasClients) {
      final formOffset = _formScrollController.offset;
      final formMaxScroll = _formScrollController.position.maxScrollExtent;
      final previewMaxScroll = _previewScrollController.position.maxScrollExtent;
      
      if (formMaxScroll > 0 && previewMaxScroll > 0) {
        final ratio = formOffset / formMaxScroll;
        final targetOffset = ratio * previewMaxScroll;
        if ((_previewScrollController.offset - targetOffset).abs() > 1) {
          _isSyncing = true;
          _previewScrollController.jumpTo(targetOffset.clamp(0.0, previewMaxScroll));
          _isSyncing = false;
        }
      } else if (formMaxScroll == 0 && previewMaxScroll > 0) {
        // If form doesn't scroll, keep preview at top
        if (_previewScrollController.offset > 0) {
          _isSyncing = true;
          _previewScrollController.jumpTo(0);
          _isSyncing = false;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 768;
        final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;
        
        final horizontalPadding = isMobile ? 12.0 : isTablet ? 16.0 : 20.0;
        final verticalPadding = isMobile ? 12.0 : isTablet ? 16.0 : 20.0;
        final contentPadding = isMobile ? 12.0 : isTablet ? 16.0 : 24.0;
        final spacing = isMobile ? 16.0 : 20.0;

        if (isMobile) {
          return Container(
            color: AppColor.WHITE,
            padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding,
              vertical: verticalPadding,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: AppColor.WHITE,
                  padding: EdgeInsets.all(contentPadding),
                  child: const NewReceiptVoucherPreview(),
                ),
                SizedBox(height: spacing),
                Container(
                  padding: EdgeInsets.all(contentPadding),
                  child: const NewReceiptVoucherForm(),
                ),
              ],
            ),
          );
        }

        return Container(
          color: AppColor.WHITE,
          padding: EdgeInsets.all(horizontalPadding),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: SingleChildScrollView(
                  controller: _formScrollController,
                  child: Container(
                    padding: EdgeInsets.all(contentPadding),
                    child: const NewReceiptVoucherForm(),
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                flex: 3,
                child: SingleChildScrollView(
                  controller: _previewScrollController,
                  child: Container(
                    color: AppColor.WHITE,
                    padding: EdgeInsets.all(contentPadding),
                    child: const NewReceiptVoucherPreview(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

