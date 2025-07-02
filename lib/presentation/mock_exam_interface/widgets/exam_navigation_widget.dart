import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamNavigationWidget extends StatelessWidget {
  final int currentIndex;
  final int totalQuestions;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onSubmit;

  const ExamNavigationWidget({
    super.key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onPrevious,
    required this.onNext,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    bool isFirstQuestion = currentIndex == 0;
    bool isLastQuestion = currentIndex == totalQuestions - 1;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Previous button
            Expanded(
              child: ElevatedButton(
                onPressed: isFirstQuestion ? null : onPrevious,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isFirstQuestion
                      ? AppTheme.textDisabledLight
                      : AppTheme.lightTheme.colorScheme.surface,
                  foregroundColor: isFirstQuestion
                      ? AppTheme.textDisabledLight
                      : AppTheme.primaryLight,
                  elevation: 0,
                  side: BorderSide(
                    color: isFirstQuestion
                        ? AppTheme.textDisabledLight
                        : AppTheme.primaryLight,
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomIconWidget(
                      iconName: 'arrow_back',
                      color: isFirstQuestion
                          ? AppTheme.textDisabledLight
                          : AppTheme.primaryLight,
                      size: 18,
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      'Previous',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(width: 4.w),

            // Next/Submit button
            Expanded(
              flex: isLastQuestion ? 2 : 1,
              child: ElevatedButton(
                onPressed: isLastQuestion ? onSubmit : onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isLastQuestion
                      ? AppTheme.successLight
                      : AppTheme.primaryLight,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      isLastQuestion ? 'Submit Exam' : 'Next',
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    CustomIconWidget(
                      iconName: isLastQuestion ? 'send' : 'arrow_forward',
                      color: Colors.white,
                      size: 18,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
