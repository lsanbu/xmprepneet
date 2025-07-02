
import '../../../core/app_export.dart';

class FlashcardWidget extends StatelessWidget {
  final Map<String, dynamic> flashcard;
  final bool isFlipped;
  final Animation<double> flipAnimation;
  final VoidCallback onFlip;

  const FlashcardWidget({
    super.key,
    required this.flashcard,
    required this.isFlipped,
    required this.flipAnimation,
    required this.onFlip,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: flipAnimation,
      builder: (context, child) {
        final isShowingFront = flipAnimation.value < 0.5;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(flipAnimation.value * 3.14159),
          child: Container(
            width: double.infinity,
            height: 60.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isShowingFront
                    ? [
                        AppTheme.lightTheme.colorScheme.primary,
                        AppTheme.lightTheme.colorScheme.primaryContainer,
                      ]
                    : [
                        AppTheme.lightTheme.colorScheme.secondary,
                        AppTheme.lightTheme.colorScheme.secondaryContainer,
                      ],
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.15),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onFlip,
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: EdgeInsets.all(6.w),
                  child: isShowingFront ? _buildFrontCard() : _buildBackCard(),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFrontCard() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface
                    .withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                flashcard['subject'] as String,
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
                  decoration: BoxDecoration(
                    color: _getDifficultyColor().withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    flashcard['difficulty'] as String,
                    style: AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: (flashcard['isFavorite'] as bool)
                      ? 'favorite'
                      : 'favorite_border',
                  color: (flashcard['isFavorite'] as bool)
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.onPrimary
                          .withValues(alpha: 0.7),
                  size: 20,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Expanded(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomIconWidget(
                  iconName: 'quiz',
                  color: AppTheme.lightTheme.colorScheme.onPrimary
                      .withValues(alpha: 0.8),
                  size: 48,
                ),
                SizedBox(height: 3.h),
                Text(
                  flashcard['question'] as String,
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'touch_app',
              color: AppTheme.lightTheme.colorScheme.onPrimary
                  .withValues(alpha: 0.7),
              size: 16,
            ),
            SizedBox(width: 2.w),
            Text(
              'Tap to reveal answer',
              style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTheme.colorScheme.onPrimary
                    .withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBackCard() {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()..rotateY(3.14159),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Answer',
                  style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              CustomIconWidget(
                iconName: 'lightbulb',
                color: AppTheme.lightTheme.colorScheme.onSecondary
                    .withValues(alpha: 0.8),
                size: 24,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: Text(
                  flashcard['answer'] as String,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSecondary,
                    fontSize: 16.sp,
                    height: 1.6,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'swipe',
                color: AppTheme.lightTheme.colorScheme.onSecondary
                    .withValues(alpha: 0.7),
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'Swipe or use buttons below',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTheme.colorScheme.onSecondary
                      .withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor() {
    switch (flashcard['difficulty'] as String) {
      case 'Easy':
        return AppTheme.lightTheme.colorScheme.tertiary;
      case 'Medium':
        return const Color(0xFFF59E0B);
      case 'Hard':
        return AppTheme.lightTheme.colorScheme.error;
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }
}
