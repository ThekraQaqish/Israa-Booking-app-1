import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:isra_fields_booking/core/constants/app_constants.dart';
import 'package:isra_fields_booking/core/theme/app_colors.dart';
import 'package:isra_fields_booking/core/theme/app_text_styles.dart';
import 'package:isra_fields_booking/core/utils/validators.dart';

class StudentIdTextField extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onFieldSubmitted;
  final bool enabled;
  final FocusNode? focusNode;

  const StudentIdTextField({
    super.key,
    required this.controller,
    this.validator,
    this.onChanged,
    this.onFieldSubmitted,
    this.enabled = true,
    this.focusNode,
  });

  @override
  State<StudentIdTextField> createState() => _StudentIdTextFieldState();
}

class _StudentIdTextFieldState extends State<StudentIdTextField>
    with SingleTickerProviderStateMixin {
  late FocusNode _focusNode;
  bool _isFocused = false;
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  void _handleChanged(String value) {
    if (_errorText != null) {
      setState(() => _errorText = null);
    }
    widget.onChanged?.call(value);
    setState(() {});
  }

  void _validate() {
    final validator = widget.validator ?? AppValidators.validateStudentId;
    setState(() {
      _errorText = validator(widget.controller.text);
    });
  }

  @override
  void dispose() {
    if (widget.focusNode == null) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentLength = widget.controller.text.length;
    final isComplete = currentLength == AppConstants.studentIdLength;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Label Row ─────────────────────────────────────────────────────
        Row(
          children: [
            const Icon(
              Icons.badge_outlined,
              size: 18.0,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 4),
            Text(
              'Student ID',
              style: AppTextStyles.labelLarge.copyWith(
                color: _errorText != null
                    ? AppColors.error
                    : _isFocused
                        ? AppColors.primary
                        : AppColors.textSecondary,
              ),
            ),
            const Spacer(),
            // ── Digit counter ──────────────────────────────────────────────
            Text(
              '$currentLength / ${AppConstants.studentIdLength}',
              style: AppTextStyles.labelSmall.copyWith(
                color: isComplete
                    ? AppColors.success
                    : _errorText != null
                        ? AppColors.error
                        : AppColors.textHint,
                fontWeight: isComplete ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // ── Input Field ───────────────────────────────────────────────────
        TextFormField(
          controller: widget.controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          style: AppTextStyles.input.copyWith(
            letterSpacing: 3.0,
            fontWeight: FontWeight.w600,
          ),
          maxLength: AppConstants.studentIdLength,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(AppConstants.studentIdLength),
          ],
          decoration: InputDecoration(
            hintText: '_ _ _ _ _ _ _ _ _ _',
            hintStyle: AppTextStyles.inputHint.copyWith(letterSpacing: 3.0),
            counterText: '',
            prefixIcon: const Icon(
              Icons.dialpad_rounded,
              color: AppColors.primary,
              size: 24.0,
            ),
            suffixIcon: widget.controller.text.isNotEmpty
                ? isComplete
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.success,
                      )
                    : IconButton(
                        icon: const Icon(
                          Icons.clear_rounded,
                          color: AppColors.textHint,
                        ),
                        onPressed: () {
                          widget.controller.clear();
                          setState(() => _errorText = null);
                          widget.onChanged?.call('');
                        },
                      )
                : null,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: _errorText != null
                    ? AppColors.inputErrorBorder
                    : isComplete
                        ? AppColors.success
                        : AppColors.inputBorder,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(
                color: _errorText != null
                    ? AppColors.inputErrorBorder
                    : AppColors.inputFocusedBorder,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.inputErrorBorder,
                width: 1.5,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: const BorderSide(
                color: AppColors.inputErrorBorder,
                width: 2,
              ),
            ),
            filled: true,
            fillColor: widget.enabled
                ? AppColors.inputFill
                : AppColors.surfaceVariant,
            errorText: null,
          ),
          onChanged: _handleChanged,
          onFieldSubmitted: (_) {
            _validate();
            widget.onFieldSubmitted?.call();
          },
          validator: (_) => _errorText,
        ),

        // ── Error Message ─────────────────────────────────────────────────
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: _errorText != null
              ? Padding(
                  key: const ValueKey('error'),
                  padding: const EdgeInsets.only(top: 4, left: 4),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline,
                          size: 14, color: AppColors.error),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          _errorText!,
                          style: AppTextStyles.inputError,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('no-error')),
        ),
      ],
    );
  }

  void validate() => _validate();
}