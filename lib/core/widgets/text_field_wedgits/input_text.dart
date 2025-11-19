import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';
import 'package:the_dunes/core/utils/file_utils.dart';
import 'package:the_dunes/core/utils/app_snackbar.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/single_select_widget.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/multi_select_widget.dart';

class InputText extends StatefulWidget {
  final SelectTypeTextField selectTypeTextField;
  final String headerHint;
  final Color headerHintColor;
  final String hint;
  final Color hintColor;
  final List<TextFieldModel> listOfTextFieldModel;
  final bool isRequired;
  final Color inputColor;
  final TextEditingController? controller;
  final Function(String)? onTextChanged;
  final Function(List<String>)? onFilesSplit;
  final VoidCallback? onSubmitted;
  final FocusNode? focusNode;

  const InputText({
    super.key,
    required this.selectTypeTextField,
    required this.headerHint,
    this.headerHintColor = AppColor.GRAY_DARK,
    this.hintColor = AppColor.GRAY_HULF,
    required this.hint,
    required this.isRequired,
    this.inputColor = AppColor.BLACK,
    this.listOfTextFieldModel = const [],
    this.controller,
    this.onTextChanged,
    this.onFilesSplit,
    this.onSubmitted,
    this.focusNode,
  });

  @override
  State<InputText> createState() => _InputTextState();
}

class _InputTextState extends State<InputText> {
  late TextEditingController _textController;
  TextFieldModel? _selectedSingleValue;
  List<TextFieldModel> _selectedMultiValues = [];
  bool _isProcessingSplit = false;
  bool _isHovered = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState(); 
    _textController = widget.controller ?? TextEditingController();
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    if (widget.controller == null) { 
      _textController.dispose();
    } else {
      _textController.removeListener(_onTextChanged);
    }
    super.dispose();
  }

  void _onTextChanged() {
    if (kDebugMode) {
      print('[InputText] Text changed: ${_textController.text.length} characters');
    }
    widget.onTextChanged?.call(_textController.text);
    
    if (widget.selectTypeTextField == SelectTypeTextField.TEXT) {
      _checkAndSplitText();
    }
  }

  Future<void> _checkAndSplitText() async {
    if (_isProcessingSplit) {
      if (kDebugMode) print('[InputText] ⏳ Text splitting already in progress, skipping...');
      return;
    }
    
    final text = _textController.text;
    final lines = text.split('\n');
    
    if (kDebugMode) {
      print('[InputText] Checking text for splitting...');
      print('[InputText] Total lines: ${lines.length}');
    }
    
    if (lines.length > 150) {
      if (kDebugMode) {
        print('[InputText] ✅ Text exceeds 150 lines, starting file split process...');
        print('[InputText] Lines count: ${lines.length}');
      }
      setState(() => _isProcessingSplit = true);
      try {
        final fileName = 'input_text_${DateTime.now().millisecondsSinceEpoch}';
        if (kDebugMode) print('[InputText] Creating files with base name: $fileName');
        
        final filePaths = await FileUtils.splitTextToFiles(text, fileName);
        
        if (kDebugMode) {
          print('[InputText] ✅ Text split successfully');
          print('[InputText] Files created: ${filePaths.length}');
          for (var i = 0; i < filePaths.length; i++) {
            print('[InputText]   File ${i + 1}: ${filePaths[i]}');
          }
        }
        
        widget.onFilesSplit?.call(filePaths);
        if (mounted) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'file.text_split_success',
            type: SnackbarType.success,
            namedArgs: {'count': filePaths.length.toString()},
            duration: Duration(seconds: 3),
          );
        }
      } catch (e) {
        if (kDebugMode) {
          print('[InputText] ❌ Error splitting text: $e');
          print('[InputText] Error type: ${e.runtimeType}');
        }
        if (mounted) {
          AppSnackbar.showTranslated(
            context: context,
            translationKey: 'file.text_split_error',
            type: SnackbarType.error,
            namedArgs: {'error': e.toString()},
            duration: Duration(seconds: 3),
          );
        }
      } finally {
        setState(() => _isProcessingSplit = false);
        if (kDebugMode) print('[InputText] File split process completed');
      }
    } else {
      if (kDebugMode) print('[InputText] ℹ️  Text within limit (${lines.length} <= 150), no split needed');
    }
  }

  Widget _buildInputWidget() {
    switch (widget.selectTypeTextField) {
      case SelectTypeTextField.LIST_SINGLE_SELECT:
        return SingleSelectWidget(
          hint: widget.hint,
          hintColor: widget.hintColor,
          inputColor: widget.inputColor,
          options: widget.listOfTextFieldModel,
          selectedValue: _selectedSingleValue,
          onChanged: (value) {
            setState(() => _selectedSingleValue = value);
          },
        );

      case SelectTypeTextField.LIST_MULTI_SELECT:
        return MultiSelectWidget(
          hint: widget.hint,
          hintColor: widget.hintColor,
          inputColor: widget.inputColor,
          options: widget.listOfTextFieldModel,
          selectedValues: _selectedMultiValues,
          onChanged: (values) {
            setState(() => _selectedMultiValues = values);
          },
        );

      case SelectTypeTextField.TEXT:
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: TextField(
            controller: _textController,
            cursorColor: AppColor.WHITE,
            style: TextStyle(color: widget.inputColor),
            maxLines: null,
            minLines: 5,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _isHovered ? AppColor.GRAY_WHITE : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _isHovered ? AppColor.GRAY_WHITE : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.WHITE),
                borderRadius: BorderRadius.circular(5),
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              suffixIcon: _isProcessingSplit
                  ? Padding(
                      padding: EdgeInsets.all(12),
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  : null,
            ),
          ),
        );

      default:
        final isPassword = widget.selectTypeTextField == SelectTypeTextField.PASSWORD;
        final isEmail = widget.selectTypeTextField == SelectTypeTextField.EMAIL;
        return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: TextField(
            controller: _textController,
            focusNode: widget.focusNode,
            cursorColor: AppColor.WHITE,
            style: TextStyle(color: widget.inputColor),
            keyboardType: _getKeyboardType(),
            obscureText: isPassword ? _obscurePassword : false,
            autofillHints: isEmail 
                ? [AutofillHints.email]
                : isPassword 
                    ? [AutofillHints.password]
                    : null,
            textInputAction: isEmail 
                ? TextInputAction.next
                : isPassword 
                    ? TextInputAction.done
                    : TextInputAction.next,
            onSubmitted: (_) => widget.onSubmitted?.call(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _isHovered ? AppColor.GRAY_WHITE : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: _isHovered ? AppColor.GRAY_WHITE : Colors.grey,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColor.WHITE),
                borderRadius: BorderRadius.circular(5),
              ),
              hintText: widget.hint,
              hintStyle: TextStyle(
                color: widget.hintColor,
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
              suffixIcon: isPassword
                  ? IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
                        color: widget.inputColor,
                        size: 20,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    )
                  : null,
            ),
          ),
        );
    }
  }

  TextInputType _getKeyboardType() {
    switch (widget.selectTypeTextField) {
      case SelectTypeTextField.EMAIL:
        return TextInputType.emailAddress;
      case SelectTypeTextField.NUMBER:
      case SelectTypeTextField.PHONE_NUMBER:
        return TextInputType.number;
      default:
        return TextInputType.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5,
      children: [
        Row(
          spacing: 5,
          children: [
            Text(
              widget.headerHint,
              style: TextStyle(color: widget.headerHintColor),
            ),
            if (widget.isRequired)
              Text(
                "*",
                style: TextStyle(color: AppColor.RED),
              ),
          ],
        ),
        _buildInputWidget(),
      ],
    );
  }
}
