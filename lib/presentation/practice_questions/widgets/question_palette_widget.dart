
import '../../../core/app_export.dart';

class QuestionPaletteWidget extends StatelessWidget {
  final int totalQuestions;
  final int currentQuestion;
  final Set<int> answeredQuestions;
  final Set<int> bookmarkedQuestions;
  final Function(int) onQuestionSelected;

  const QuestionPaletteWidget({
    super.key,
    required this.totalQuestions,
    required this.currentQuestion,
    required this.answeredQuestions,
    required this.bookmarkedQuestions,
    required this.onQuestionSelected,
  });

  Color _getQuestionColor(int index) {
    if (index == currentQuestion) {
      return AppTheme.lightTheme.colorScheme.secondary;
    } else if (answeredQuestions.contains(index)) {
      return AppTheme.lightTheme.colorScheme.tertiary;
    } else if (bookmarkedQuestions.contains(index)) {
      return AppTheme.lightTheme.colorScheme.error;
    }
    return AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.3);
  }

  Color _getQuestionTextColor(int index) {
    if (index == currentQuestion) {
      return AppTheme.lightTheme.colorScheme.onSecondary;
    } else if (answeredQuestions.contains(index)) {
      return AppTheme.lightTheme.colorScheme.surface;
    } else if (bookmarkedQuestions.contains(index)) {
      return AppTheme.lightTheme.colorScheme.surface;
    }
    return AppTheme.lightTheme.colorScheme.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle Bar
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline
                  .withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w),
            child: Row(
              children: [
                Text(
                  'Question Palette',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: CustomIconWidget(
                    iconName: 'close',
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                    size: 24,
                  ),
                ),
              ],
            ),
          ),

          // Legend
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            child: Row(
              children: [
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.secondary,
                  label: 'Current',
                ),
                SizedBox(width: 4.w),
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.tertiary,
                  label: 'Answered',
                ),
                SizedBox(width: 4.w),
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.error,
                  label: 'Bookmarked',
                ),
                SizedBox(width: 4.w),
                _buildLegendItem(
                  color: AppTheme.lightTheme.colorScheme.outline
                      .withValues(alpha: 0.3),
                  label: 'Not Visited',
                ),
              ],
            ),
          ),

          // Question Grid
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 3.w,
                  mainAxisSpacing: 2.h,
                  childAspectRatio: 1,
                ),
                itemCount: totalQuestions,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => onQuestionSelected(index),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _getQuestionColor(index),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: _getQuestionColor(index),
                          width: 2,
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                color: _getQuestionTextColor(index),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          if (bookmarkedQuestions.contains(index))
                            Positioned(
                              top: 1,
                              right: 1,
                              child: CustomIconWidget(
                                iconName: 'bookmark',
                                color: AppTheme.lightTheme.colorScheme.surface,
                                size: 12,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Statistics
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.primary
                  .withValues(alpha: 0.05),
              borderRadius:
                  const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  'Total',
                  totalQuestions.toString(),
                  AppTheme.lightTheme.colorScheme.primary,
                ),
                _buildStatItem(
                  'Answered',
                  answeredQuestions.length.toString(),
                  AppTheme.lightTheme.colorScheme.tertiary,
                ),
                _buildStatItem(
                  'Bookmarked',
                  bookmarkedQuestions.length.toString(),
                  AppTheme.lightTheme.colorScheme.error,
                ),
                _buildStatItem(
                  'Remaining',
                  (totalQuestions - answeredQuestions.length).toString(),
                  AppTheme.lightTheme.colorScheme.secondary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            fontSize: 10.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurface
                .withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }
}
