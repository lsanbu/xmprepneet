import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExplanationCardWidget extends StatefulWidget {
  final String explanation;
  final bool isCorrect;

  const ExplanationCardWidget({
    super.key,
    required this.explanation,
    required this.isCorrect,
  });

  @override
  State<ExplanationCardWidget> createState() => _ExplanationCardWidgetState();
}

class _ExplanationCardWidgetState extends State<ExplanationCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _slideAnimation = Tween<double>(
      begin: 0.3,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _slideAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 3.h),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: widget.isCorrect
                    ? AppTheme.lightTheme.colorScheme.tertiary
                        .withValues(alpha: 0.05)
                    : AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: widget.isCorrect
                      ? AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.3)
                      : AppTheme.lightTheme.colorScheme.error
                          .withValues(alpha: 0.3),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: widget.isCorrect
                        ? AppTheme.lightTheme.colorScheme.tertiary
                            .withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.error
                            .withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with Result
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: widget.isCorrect
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: CustomIconWidget(
                          iconName: widget.isCorrect ? 'check' : 'close',
                          color: AppTheme.lightTheme.colorScheme.surface,
                          size: 16,
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Text(
                        widget.isCorrect
                            ? 'Correct Answer!'
                            : 'Incorrect Answer',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: widget.isCorrect
                              ? AppTheme.lightTheme.colorScheme.tertiary
                              : AppTheme.lightTheme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (widget.isCorrect)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 3.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.tertiary
                                .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+1 Point',
                            style: AppTheme.lightTheme.textTheme.labelSmall
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.tertiary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: 3.h),

                  // Explanation Header
                  Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'lightbulb',
                        color: AppTheme.lightTheme.colorScheme.secondary,
                        size: 20,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Explanation',
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 2.h),

                  // Explanation Text
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.outline
                            .withValues(alpha: 0.2),
                      ),
                    ),
                    child: Text(
                      widget.explanation,
                      style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                        height: 1.5,
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                      ),
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Add to notes functionality
                          },
                          icon: CustomIconWidget(
                            iconName: 'note_add',
                            color: AppTheme.lightTheme.colorScheme.primary,
                            size: 18,
                          ),
                          label: Text('Add to Notes'),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 3.w),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // Share explanation functionality
                          },
                          icon: CustomIconWidget(
                            iconName: 'share',
                            color: AppTheme.lightTheme.colorScheme.secondary,
                            size: 18,
                          ),
                          label: Text('Share'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor:
                                AppTheme.lightTheme.colorScheme.secondary,
                            side: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.secondary,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 1.5.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
