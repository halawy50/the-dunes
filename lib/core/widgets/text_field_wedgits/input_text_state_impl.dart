import 'package:flutter/material.dart';
import 'package:the_dunes/core/utils/constants/app_colors.dart';
import 'package:the_dunes/core/utils/constants/select_type_text_field.dart';
import 'package:the_dunes/core/utils/model/text_field_model.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_split_handler.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_build_helper.dart';
import 'package:the_dunes/core/widgets/text_field_wedgits/input_text_state_init.dart';

class InputTextStateImpl extends StatefulWidget {
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

  const InputTextStateImpl({
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
  State<InputTextStateImpl> createState() => _InputTextStateImplState();
}

class _InputTextStateImplState extends State<InputTextStateImpl> {
  late TextEditingController _textController;
  TextFieldModel? _selectedSingleValue;
  List<TextFieldModel> _selectedMultiValues = [];
  bool _isHovered = false;
  bool _obscurePassword = true;
  late InputTextSplitHandler _splitHandler;

  @override
  void initState() {
    super.initState();
    _textController = widget.controller ?? TextEditingController();
    _splitHandler = InputTextSplitHandler(context: context, textController: _textController, onFilesSplit: widget.onFilesSplit);
    InputTextStateInit.initialize(context: context, widget: widget, textController: _textController, onTextChanged: _onTextChanged, splitHandler: _splitHandler);
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
    InputTextStateInit.handleTextChanged(textController: _textController, onTextChanged: widget.onTextChanged, selectTypeTextField: widget.selectTypeTextField, splitHandler: _splitHandler);
  }

  @override
  Widget build(BuildContext context) {
    return InputTextBuildHelper.buildWidget(
      widget: widget,
      textController: _textController,
      splitHandler: _splitHandler,
      isHovered: _isHovered,
      obscurePassword: _obscurePassword,
      selectedSingleValue: _selectedSingleValue,
      selectedMultiValues: _selectedMultiValues,
      setHovered: (value) => setState(() => _isHovered = value),
      toggleObscurePassword: () => setState(() => _obscurePassword = !_obscurePassword),
      setSelectedSingleValue: (value) => setState(() => _selectedSingleValue = value),
      setSelectedMultiValues: (values) => setState(() => _selectedMultiValues = values),
    );
  }
}
