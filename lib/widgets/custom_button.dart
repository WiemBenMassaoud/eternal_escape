
import 'package:flutter/material.dart';
import '../utils/theme.dart';

enum ButtonVariant { primary, secondary, outline, text, gradient, danger }
enum ButtonSize { small, medium, large }

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final ButtonSize size;
  final IconData? icon;
  final bool iconAtEnd;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double? height;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.icon,
    this.iconAtEnd = false,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final buttonHeight = height ?? _getHeight();
    final buttonWidth = isFullWidth ? double.infinity : width;

    return SizedBox(
      height: buttonHeight,
      width: buttonWidth,
      child: variant == ButtonVariant.gradient
          ? _buildGradientButton()
          : _buildStandardButton(),
    );
  }

  Widget _buildGradientButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: BorderRadius.circular(AppTheme.radiusSM),
        boxShadow: onPressed != null && !isLoading ? AppTheme.shadowCard : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          ),
          padding: _getPadding(),
        ),
        child: _buildButtonContent(),
      ),
    );
  }

  Widget _buildStandardButton() {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: _getBackgroundColor(),
        foregroundColor: _getForegroundColor(),
        disabledBackgroundColor: AppTheme.borderLight,
        disabledForegroundColor: AppTheme.textTertiary,
        elevation: _getElevation(),
        shadowColor: AppTheme.primary.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.radiusSM),
          side: variant == ButtonVariant.outline
              ? BorderSide(color: _getBorderColor(), width: 2)
              : BorderSide.none,
        ),
        padding: _getPadding(),
      ),
      child: _buildButtonContent(),
    );
  }

  Widget _buildButtonContent() {
    if (isLoading) {
      return SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            variant == ButtonVariant.outline || variant == ButtonVariant.text
                ? AppTheme.primary
                : Colors.white,
          ),
        ),
      );
    }

    final List<Widget> children = [];

    if (icon != null && !iconAtEnd) {
      children.add(Icon(icon, size: _getIconSize()));
      children.add(SizedBox(width: AppTheme.marginSM));
    }

    children.add(
      Text(
        text,
        style: _getTextStyle(),
        textAlign: TextAlign.center,
      ),
    );

    if (icon != null && iconAtEnd) {
      children.add(SizedBox(width: AppTheme.marginSM));
      children.add(Icon(icon, size: _getIconSize()));
    }

    return Row(
      mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: children,
    );
  }

  double _getHeight() {
    switch (size) {
      case ButtonSize.small:
        return AppTheme.buttonHeightSM;
      case ButtonSize.medium:
        return AppTheme.buttonHeightMD;
      case ButtonSize.large:
        return AppTheme.buttonHeightLG;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case ButtonSize.small:
        return EdgeInsets.symmetric(horizontal: AppTheme.paddingLG);
      case ButtonSize.medium:
        return EdgeInsets.symmetric(horizontal: AppTheme.paddingXXL);
      case ButtonSize.large:
        return EdgeInsets.symmetric(horizontal: AppTheme.paddingXXXL);
    }
  }

  double _getIconSize() {
    switch (size) {
      case ButtonSize.small:
        return AppTheme.iconXS;
      case ButtonSize.medium:
        return AppTheme.iconSM;
      case ButtonSize.large:
        return AppTheme.iconMD;
    }
  }

  double _getElevation() {
    if (variant == ButtonVariant.outline || variant == ButtonVariant.text) {
      return 0;
    }
    return 2;
  }

  TextStyle _getTextStyle() {
    TextStyle? baseStyle;
    switch (size) {
      case ButtonSize.small:
        baseStyle = AppTheme.textTheme.labelLarge;
        break;
      case ButtonSize.medium:
        baseStyle = AppTheme.textTheme.titleMedium;
        break;
      case ButtonSize.large:
        baseStyle = AppTheme.textTheme.titleLarge;
        break;
    }

    return baseStyle!.copyWith(
      color: _getForegroundColor(),
      fontWeight: FontWeight.w700,
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppTheme.primary;
      case ButtonVariant.secondary:
        return AppTheme.backgroundAlt;
      case ButtonVariant.danger:
        return AppTheme.error;
      case ButtonVariant.outline:
      case ButtonVariant.text:
        return Colors.transparent;
      case ButtonVariant.gradient:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.gradient:
      case ButtonVariant.danger:
        return Colors.white;
      case ButtonVariant.secondary:
        return AppTheme.textPrimary;
      case ButtonVariant.outline:
        return AppTheme.primary;
      case ButtonVariant.text:
        return AppTheme.textSecondary;
    }
  }

  Color _getBorderColor() {
    switch (variant) {
      case ButtonVariant.outline:
        return AppTheme.primary;
      case ButtonVariant.danger:
        return AppTheme.error;
      default:
        return Colors.transparent;
    }
  }
}