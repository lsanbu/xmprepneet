import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AnswerOptionWidget extends StatelessWidget {
  final String option;
  final int optionIndex;
  final bool isSelected;
  final bool isCorrect;
  final bool isWrong;
  final VoidCallback onTap;

  const AnswerOptionWidget({
    super.key,
    required this.option,
    required this.optionIndex,
    required this.isSelected,
    required this.isCorrect,
    required this.isWrong,
    required this.onTap,
  });

  String _getOptionLabel() {
    switch (optionIndex) {
      case 0:
        return 'A';
      case 1:
        return 'B';
      case 2:
        return 'C';
      case 3:
        return 'D';
      default:
        return '';
    }
  }

  Color _getBackgroundColor() {
    if (isCorrect) {
      return AppTheme.lightTheme.colorScheme.tertiary.withValues(alpha: 0.1);
    } else if (isWrong) {
      return AppTheme.lightTheme.colorScheme.error.withValues(alpha: 0.1);
    } else if (isSelected) {
      return AppTheme.lightTheme.colorScheme.primary.withValues(alpha: 0.1);
    }
    return AppTheme.lightTheme.colorScheme.surface;
  }

  Color _getBorderColor() {
    if (isCorrect) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (isWrong) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (isSelected) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
    return AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3);
  }

  Color _getTextColor() {
    if (isCorrect) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (isWrong) {
      return AppTheme.lightTheme.colorScheme.error;
    } else if (isSelected) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
    return AppTheme.lightTheme.colorScheme.onSurface;
  }

  Widget _getStatusIcon() {
    if (isCorrect) {
      return CustomIconWidget(
        iconName: 'check_circle',
        color: AppTheme.lightTheme.colorScheme.tertiary,
        size: 20,
      );
    } else if (isWrong) {
      return CustomIconWidget(
        iconName: 'cancel',
        color: AppTheme.lightTheme.colorScheme.error,
        size: 20,
      );
    } else if (isSelected) {
      return CustomIconWidget(
        iconName: 'radio_button_checked',
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 20,
      );
    }
    return CustomIconWidget(
      iconName: 'radio_button_unchecked',
      color: AppTheme.lightTheme.colorScheme.outline,
      size: 20,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: _getBackgroundColor(),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _getBorderColor(),
            width: isSelected || isCorrect || isWrong ? 2 : 1,
          ),
          boxShadow: isSelected || isCorrect || isWrong
              ? [
                  BoxShadow(
                    color: _getBorderColor().withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            // Option Label
            Container(
              width: 8.w,
              height: 8.w,
              decoration: BoxDecoration(
                color: _getTextColor().withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _getTextColor(),
                  width: 1,
                ),
              ),
              child: Center(
                child: Text(
                  _getOptionLabel(),
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: _getTextColor(),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Option Text
            Expanded(
              child: Text(
                option,
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  color: _getTextColor(),
                  fontWeight: isSelected || isCorrect || isWrong
                      ? FontWeight.w500
                      : FontWeight.w400,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(width: 3.w),

            // Status Icon
            _getStatusIcon(),
          ],
        ),
      ),
    );
  }
}
