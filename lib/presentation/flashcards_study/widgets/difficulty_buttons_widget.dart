import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class DifficultyButtonsWidget extends StatelessWidget {
  final Function(String) onDifficultySelected;
  final bool isAnswerVisible;

  const DifficultyButtonsWidget({
    super.key,
    required this.onDifficultySelected,
    required this.isAnswerVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isAnswerVisible ? 1.0 : 0.5,
      duration: const Duration(milliseconds: 300),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          children: [
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'info_outline',
                  color: AppTheme.lightTheme.colorScheme.onSurface
                      .withValues(alpha: 0.6),
                  size: 16,
                ),
                SizedBox(width: 2.w),
                Text(
                  'How well did you know this?',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface
                        .withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Row(
              children: [
                Expanded(
                  child: _buildDifficultyButton(
                    label: 'Again',
                    subtitle: '< 1 min',
                    color: AppTheme.lightTheme.colorScheme.error,
                    icon: 'refresh',
                    onPressed: () => onDifficultySelected('Again'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDifficultyButton(
                    label: 'Hard',
                    subtitle: '< 6 min',
                    color: const Color(0xFFF59E0B),
                    icon: 'trending_down',
                    onPressed: () => onDifficultySelected('Hard'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDifficultyButton(
                    label: 'Good',
                    subtitle: '< 10 min',
                    color: AppTheme.lightTheme.colorScheme.primary,
                    icon: 'trending_flat',
                    onPressed: () => onDifficultySelected('Good'),
                  ),
                ),
                SizedBox(width: 3.w),
                Expanded(
                  child: _buildDifficultyButton(
                    label: 'Easy',
                    subtitle: '4 days',
                    color: AppTheme.lightTheme.colorScheme.tertiary,
                    icon: 'trending_up',
                    onPressed: () => onDifficultySelected('Easy'),
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildGestureHint(
                      '←', 'Hard', AppTheme.lightTheme.colorScheme.error),
                  _buildGestureHint('↑', 'Again', const Color(0xFFF59E0B)),
                  _buildGestureHint(
                      '→', 'Easy', AppTheme.lightTheme.colorScheme.tertiary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyButton({
    required String label,
    required String subtitle,
    required Color color,
    required String icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isAnswerVisible ? onPressed : null,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Column(
            children: [
              CustomIconWidget(
                iconName: icon,
                color: color,
                size: 20,
              ),
              SizedBox(height: 1.h),
              Text(
                label,
                style: AppTheme.lightTheme.textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 0.5.h),
              Text(
                subtitle,
                style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                  color: color.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGestureHint(String gesture, String action, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            gesture,
            style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          action,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
