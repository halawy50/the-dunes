import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';

class BookingStatusDropdownCell extends StatelessWidget {
  const BookingStatusDropdownCell({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.getColor,
    this.isLoading = false,
  });

  final String? value;
  final List<String> items;
  final void Function(String?) onChanged;
  final Color Function(String) getColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    // التأكد من أن value موجود في items، وإلا نستخدم null
    final validValue = value != null && items.contains(value) ? value : null;
    final bgColor = validValue != null ? getColor(validValue) : AppColor.WHITE;
    final textColor = validValue != null ? _getTextColor(validValue) : AppColor.BLACK;
    
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: isLoading
          ? Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(textColor),
                ),
              ),
            )
          : DropdownButtonFormField<String>(
              value: validValue,
              isExpanded: true,
              menuMaxHeight: 300,
              iconSize: 20,
              icon: Container(
                alignment: Alignment.center,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: textColor,
                  size: 20,
                ),
              ),
              alignment: AlignmentDirectional.centerStart,
              style: TextStyle(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                filled: false,
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                isDense: true,
              ),
              items: items.map((item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      item,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.visible,
                      softWrap: false,
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
              selectedItemBuilder: (context) {
                return items.map((item) {
                  // selectedItemBuilder يعرض نفس النص للعنصر المحدد فقط
                  // إذا كان العنصر هو القيمة المحددة، نعرضه، وإلا نعرض نص فارغ
                  if (item == validValue && validValue != null) {
                    final itemTextColor = _getTextColor(validValue);
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        validValue,
                        style: TextStyle(
                          fontSize: 13,
                          color: itemTextColor,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.visible,
                        softWrap: false,
                      ),
                    );
                  } else {
                    // للعناصر غير المحددة، نعرض نص فارغ
                    return Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: const Text(
                        '',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColor.BLACK,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }
                }).toList();
              },
            ),
    );
  }

  Color _getTextColor(String status) {
    final statusUpper = status.toUpperCase();
    switch (statusUpper) {
      case 'YET':
        return AppColor.BLACK;
      case 'PENDING':
        return Colors.orange.shade700;
      case 'COMPLETED':
        return Colors.green.shade700;
      case 'ACCEPTED':
        return Colors.blue.shade700;
      case 'CANCELLED':
        return Colors.red.shade700;
      case 'PICKED':
        return Colors.green.shade700;
      case 'INWAY':
        return Colors.blue.shade700;
      default:
        return AppColor.BLACK;
    }
  }
}

