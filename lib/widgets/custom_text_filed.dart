import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/theme.dart';

class CustomTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final IconData? prefixIcon;
  final Widget? prefix;
  final IconData? suffixIcon;
  final Widget? suffix;
  final VoidCallback? onSuffixTap;
  final int? maxLines;
  final int? maxLength;
  final bool enabled;
  final bool readOnly;
  final Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;
  final bool showCounter;

  const CustomTextField({
    Key? key,
    this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.prefixIcon,
    this.prefix,
    this.suffixIcon,
    this.suffix,
    this.onSuffixTap,
    this.maxLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.onChanged,
    this.onTap,
    this.initialValue,
    this.inputFormatters,
    this.showCounter = false,
  }) : super(key: key);

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isFocused = false;
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTheme.textTheme.titleSmall?.copyWith(
              color: _isFocused ? AppTheme.primary : AppTheme.textPrimary,
            ),
          ),
          SizedBox(height: AppTheme.marginSM),
        ],
        Focus(
          onFocusChange: (hasFocus) {
            setState(() => _isFocused = hasFocus);
          },
          child: TextFormField(
            controller: widget.controller,
            initialValue: widget.initialValue,
            validator: widget.validator,
            keyboardType: widget.keyboardType,
            textInputAction: widget.textInputAction,
            obscureText: widget.obscureText && _obscureText,
            maxLines: widget.obscureText ? 1 : widget.maxLines,
            maxLength: widget.maxLength,
            enabled: widget.enabled,
            readOnly: widget.readOnly,
            onChanged: widget.onChanged,
            onTap: widget.onTap,
            inputFormatters: widget.inputFormatters,
            style: AppTheme.textTheme.bodyLarge?.copyWith(
              color: widget.enabled ? AppTheme.textPrimary : AppTheme.textTertiary,
            ),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textTertiary,
              ),
              prefixIcon: widget.prefix ??
                  (widget.prefixIcon != null
                      ? Icon(
                          widget.prefixIcon,
                          color: _isFocused ? AppTheme.primary : AppTheme.textSecondary,
                          size: AppTheme.iconSM,
                        )
                      : null),
              suffixIcon: widget.suffix ?? _buildSuffixIcon(),
              filled: true,
              fillColor: widget.enabled ? AppTheme.backgroundCard : AppTheme.backgroundAlt,
              counterText: widget.showCounter ? null : '',
              border: _buildBorder(AppTheme.borderLight),
              enabledBorder: _buildBorder(AppTheme.borderLight),
              focusedBorder: _buildBorder(AppTheme.primary, width: 2),
              errorBorder: _buildBorder(AppTheme.error),
              focusedErrorBorder: _buildBorder(AppTheme.error, width: 2),
              disabledBorder: _buildBorder(AppTheme.borderLight),
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.paddingLG,
                vertical: widget.maxLines != null && widget.maxLines! > 1
                    ? AppTheme.paddingLG
                    : AppTheme.paddingLG,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          color: _isFocused ? AppTheme.primary : AppTheme.textSecondary,
          size: AppTheme.iconSM,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: _isFocused ? AppTheme.primary : AppTheme.textSecondary,
          size: AppTheme.iconSM,
        ),
        onPressed: widget.onSuffixTap,
      );
    }

    return null;
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppTheme.radiusSM),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}