
import '../../../core/app_export.dart';

class QuestionDisplayWidget extends StatelessWidget {
  final Map<String, dynamic> question;
  final int questionNumber;
  final Function(int) onAnswerSelected;
  final VoidCallback onMarkForReview;

  const QuestionDisplayWidget({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.onAnswerSelected,
    required this.onMarkForReview,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> options = (question['options'] as List).cast<String>();
    final int? selectedAnswer = question['selectedAnswer'];
    final bool isMarkedForReview = question['isMarkedForReview'] ?? false;

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Question header with subject and difficulty
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: AppTheme.secondaryLight.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  question['subject'] ?? 'General',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: AppTheme.secondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              SizedBox(width: 2.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                decoration: BoxDecoration(
                  color: _getDifficultyColor().withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  question['difficulty'] ?? 'Medium',
                  style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                    color: _getDifficultyColor(),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 2.h),

          // Question text
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppTheme.dividerLight,
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Q$questionNumber.',
                  style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryLight,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  question['question'] ?? '',
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    height: 1.5,
                    color: AppTheme.textHighEmphasisLight,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 3.h),

          // Options
          Text(
            'Choose the correct answer:',
            style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
              color: AppTheme.textMediumEmphasisLight,
              fontWeight: FontWeight.w500,
            ),
          ),

          SizedBox(height: 2.h),

          ...options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            bool isSelected = selectedAnswer == index;

            return Container(
              margin: EdgeInsets.only(bottom: 2.h),
              child: InkWell(
                onTap: () => onAnswerSelected(index),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.primaryLight.withValues(alpha: 0.1)
                        : AppTheme.lightTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.primaryLight
                          : AppTheme.dividerLight,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Option indicator
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected
                              ? AppTheme.primaryLight
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.dividerLight,
                            width: 2,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            String.fromCharCode(65 + index), // A, B, C, D
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppTheme.textMediumEmphasisLight,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(width: 3.w),

                      // Option text
                      Expanded(
                        child: Text(
                          option,
                          style: AppTheme.lightTheme.textTheme.bodyMedium
                              ?.copyWith(
                            color: isSelected
                                ? AppTheme.primaryLight
                                : AppTheme.textHighEmphasisLight,
                            fontWeight:
                                isSelected ? FontWeight.w500 : FontWeight.w400,
                          ),
                        ),
                      ),

                      // Selection indicator
                      if (isSelected)
                        CustomIconWidget(
                          iconName: 'check_circle',
                          color: AppTheme.primaryLight,
                          size: 20,
                        ),
                    ],
                  ),
                ),
              ),
            );
          }),

          SizedBox(height: 2.h),

          // Mark for review checkbox
          InkWell(
            onTap: onMarkForReview,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              padding: EdgeInsets.all(3.w),
              child: Row(
                children: [
                  Container(
                    width: 6.w,
                    height: 6.w,
                    decoration: BoxDecoration(
                      color: isMarkedForReview
                          ? AppTheme.warningLight
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: isMarkedForReview
                            ? AppTheme.warningLight
                            : AppTheme.dividerLight,
                        width: 2,
                      ),
                    ),
                    child: isMarkedForReview
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: Colors.white,
                            size: 14,
                          )
                        : null,
                  ),
                  SizedBox(width: 3.w),
                  Text(
                    'Mark for Review',
                    style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (question['difficulty']?.toLowerCase()) {
      case 'easy':
        return AppTheme.successLight;
      case 'medium':
        return AppTheme.warningLight;
      case 'hard':
        return AppTheme.errorLight;
      default:
        return AppTheme.warningLight;
    }
  }
}
