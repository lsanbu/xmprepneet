
import '../../../core/app_export.dart';

class QuestionPaletteWidget extends StatelessWidget {
  final List<Map<String, dynamic>> questions;
  final int currentIndex;
  final Function(int) onQuestionSelected;
  final VoidCallback onClose;

  const QuestionPaletteWidget({
    super.key,
    required this.questions,
    required this.currentIndex,
    required this.onQuestionSelected,
    required this.onClose,
  });

  Color _getQuestionStatusColor(Map<String, dynamic> question) {
    if (question['isMarkedForReview'] == true) {
      return AppTheme.warningLight;
    } else if (question['isAttempted'] == true) {
      return AppTheme.successLight;
    } else {
      return AppTheme.textDisabledLight;
    }
  }

  String _getStatusLabel(Map<String, dynamic> question) {
    if (question['isMarkedForReview'] == true) {
      return 'Marked for Review';
    } else if (question['isAttempted'] == true) {
      return 'Attempted';
    } else {
      return 'Not Attempted';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          width: 90.w,
          height: 80.h,
          margin: EdgeInsets.symmetric(horizontal: 5.w),
          decoration: BoxDecoration(
            color: AppTheme.lightTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.primaryLight,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Question Palette',
                        style:
                            AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: onClose,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(1.w),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Legend
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Legend:',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        _buildLegendItem(
                          color: AppTheme.successLight,
                          label: 'Attempted',
                        ),
                        SizedBox(width: 4.w),
                        _buildLegendItem(
                          color: AppTheme.warningLight,
                          label: 'Marked',
                        ),
                        SizedBox(width: 4.w),
                        _buildLegendItem(
                          color: AppTheme.textDisabledLight,
                          label: 'Not Attempted',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Question grid
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      crossAxisSpacing: 2.w,
                      mainAxisSpacing: 2.w,
                      childAspectRatio: 1,
                    ),
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      final isCurrentQuestion = index == currentIndex;
                      final statusColor = _getQuestionStatusColor(question);

                      return InkWell(
                        onTap: () => onQuestionSelected(index),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isCurrentQuestion
                                ? AppTheme.primaryLight
                                : statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isCurrentQuestion
                                  ? AppTheme.primaryLight
                                  : statusColor,
                              width: isCurrentQuestion ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '${index + 1}',
                              style: AppTheme.lightTheme.textTheme.labelLarge
                                  ?.copyWith(
                                color: isCurrentQuestion
                                    ? Colors.white
                                    : statusColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Summary
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    bottomRight: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Summary',
                      style: AppTheme.lightTheme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSummaryItem(
                          'Attempted',
                          questions
                              .where((q) => q['isAttempted'] == true)
                              .length
                              .toString(),
                          AppTheme.successLight,
                        ),
                        _buildSummaryItem(
                          'Marked',
                          questions
                              .where((q) => q['isMarkedForReview'] == true)
                              .length
                              .toString(),
                          AppTheme.warningLight,
                        ),
                        _buildSummaryItem(
                          'Remaining',
                          questions
                              .where((q) => q['isAttempted'] != true)
                              .length
                              .toString(),
                          AppTheme.textDisabledLight,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 4.w,
          height: 4.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 1.w),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String count, Color color) {
    return Column(
      children: [
        Text(
          count,
          style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
            color: AppTheme.textMediumEmphasisLight,
          ),
        ),
      ],
    );
  }
}
