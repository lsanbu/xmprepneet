
import '../../../core/app_export.dart';

class LeaderboardFilterWidget extends StatelessWidget {
  final String selectedTimePeriod;
  final String selectedCategory;
  final List<String> timePeriods;
  final List<String> categories;
  final ValueChanged<String> onTimePeriodChanged;
  final ValueChanged<String> onCategoryChanged;

  const LeaderboardFilterWidget({
    super.key,
    required this.selectedTimePeriod,
    required this.selectedCategory,
    required this.timePeriods,
    required this.categories,
    required this.onTimePeriodChanged,
    required this.onCategoryChanged,
  });

  String _capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    Color? selectedColor,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        onTap();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
              : AppTheme.lightTheme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppTheme.lightTheme.colorScheme.primary)
                : AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.5),
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: (selectedColor ??
                            AppTheme.lightTheme.colorScheme.primary)
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : AppTheme.lightTheme.colorScheme.onSurface,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CustomIconWidget(
                iconName: 'schedule',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Time Period',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: timePeriods.map((period) {
                final isSelected = selectedTimePeriod == period;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: _buildFilterChip(
                    label: _capitalizeFirst(period),
                    isSelected: isSelected,
                    onTap: () => onTimePeriodChanged(period),
                    selectedColor: AppTheme.lightTheme.colorScheme.primary,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            children: [
              CustomIconWidget(
                iconName: 'category',
                color: AppTheme.lightTheme.colorScheme.secondary,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Category',
                style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.lightTheme.colorScheme.secondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((category) {
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: EdgeInsets.only(right: 2.w),
                  child: _buildFilterChip(
                    label: _capitalizeFirst(category),
                    isSelected: isSelected,
                    onTap: () => onCategoryChanged(category),
                    selectedColor: AppTheme.lightTheme.colorScheme.secondary,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
