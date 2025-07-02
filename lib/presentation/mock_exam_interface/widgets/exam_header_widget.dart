import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class ExamHeaderWidget extends StatelessWidget {
  final String examTitle;
  final int remainingTime;
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onPalettePressed;
  final VoidCallback onPausePressed;

  const ExamHeaderWidget({
    super.key,
    required this.examTitle,
    required this.remainingTime,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onPalettePressed,
    required this.onPausePressed,
  });

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getTimerColor() {
    if (remainingTime <= 300) {
      // 5 minutes
      return AppTheme.errorLight;
    } else if (remainingTime <= 900) {
      // 15 minutes
      return AppTheme.warningLight;
    }
    return AppTheme.successLight;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: AppTheme.shadowLight,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top row with title and controls
          Row(
            children: [
              Expanded(
                child: Text(
                  examTitle,
                  style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textHighEmphasisLight,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 2.w),
              // Pause button
              InkWell(
                onTap: onPausePressed,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'pause',
                    color: AppTheme.textMediumEmphasisLight,
                    size: 20,
                  ),
                ),
              ),
              SizedBox(width: 1.w),
              // Question palette button
              InkWell(
                onTap: onPalettePressed,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: EdgeInsets.all(2.w),
                  child: CustomIconWidget(
                    iconName: 'grid_view',
                    color: AppTheme.primaryLight,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 1.h),

          // Bottom row with timer and question counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Timer
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: _getTimerColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _getTimerColor(),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomIconWidget(
                      iconName: 'timer',
                      color: _getTimerColor(),
                      size: 16,
                    ),
                    SizedBox(width: 1.w),
                    Text(
                      _formatTime(remainingTime),
                      style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                        color: _getTimerColor(),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Question counter
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.primaryLight,
                    width: 1,
                  ),
                ),
                child: Text(
                  'Question $currentQuestion of $totalQuestions',
                  style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
