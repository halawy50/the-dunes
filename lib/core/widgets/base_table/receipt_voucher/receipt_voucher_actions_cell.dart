import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/utils/file_download_helper.dart';
import 'package:the_dunes/features/recipt_voucher/data/models/receipt_voucher_model.dart';
import 'package:the_dunes/features/recipt_voucher/persentation/widgets/receipt_voucher_edit_dialog.dart';

class ReceiptVoucherActionsCell {
  static Widget build({
    required ReceiptVoucherModel voucher,
    required void Function(ReceiptVoucherModel, Map<String, dynamic>) onVoucherEdit,
    required void Function(ReceiptVoucherModel) onVoucherDelete,
    required bool isDeleting,
    required Future<String> Function(int) onDownloadPdf,
    required BuildContext context,
    bool canEdit = true,
    bool canDelete = true,
  }) {
    return SizedBox(
      width: canEdit || canDelete ? 80 : 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDeleting)
            const Padding(
              padding: EdgeInsets.all(4.0),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            )
          else ...[
            IconButton(
              icon: const Icon(Icons.download, size: 14),
              color: Colors.green,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
              onPressed: () async {
                try {
                  final url = await onDownloadPdf(voucher.id);
                  await FileDownloadHelper.downloadFile(url);
                  if (context.mounted) {
                    AppSnackbar.showSuccess(
                      context,
                      'receipt_voucher.pdf_downloaded'.tr(),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    AppSnackbar.showError(
                      context,
                      'receipt_voucher.pdf_download_error'.tr(),
                    );
                  }
                }
              },
              tooltip: 'receipt_voucher.download_pdf'.tr(),
            ),
            if (canEdit)
              IconButton(
                icon: const Icon(Icons.edit, size: 14),
                color: Colors.blue,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                onPressed: () async {
                  final result = await showDialog<Map<String, dynamic>>(
                    context: context,
                    builder: (context) => ReceiptVoucherEditDialog(
                      voucher: voucher,
                      onSave: (_) {},
                    ),
                  );
                  if (result != null && result.isNotEmpty) {
                    onVoucherEdit(voucher, result);
                  }
                },
                tooltip: 'common.edit'.tr(),
              ),
            if (canDelete)
              IconButton(
                icon: const Icon(Icons.delete, size: 14),
                color: Colors.red,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                onPressed: () {
                  onVoucherDelete(voucher);
                },
                tooltip: 'common.delete'.tr(),
              ),
          ],
        ],
      ),
    );
  }
}

