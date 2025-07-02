import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class HeroSectionWidget extends StatelessWidget {
  const HeroSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(26),
            Theme.of(context).colorScheme.secondary.withAlpha(26),
            Theme.of(context).scaffoldBackgroundColor,
          ],
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 4.w,
          vertical: 8.h,
        ),
        child: Column(
          children: [
            // App Logo/Icon
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondary,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withAlpha(77),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.psychology,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),

            SizedBox(height: 4.h),

            // Main Headline
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: Text(
                'Crack NEET Smarter with AI',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 2.h),

            // Subheadline
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 400),
              child: Text(
                'Your personalized NEET companion powered by Generative AI.\nPractice, revise, and improve — all in one place.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(179),
                      height: 1.5,
                    ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 4.h),

            // CTA Buttons
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 600),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButtonWidget(
                    text: 'Join Waitlist',
                    onPressed: () {
                      // Scroll to footer section
                      _scrollToFooter(context);
                    },
                    isPrimary: true,
                  ),
                  SizedBox(width: 4.w),
                  CustomButtonWidget(
                    text: 'Try Demo',
                    onPressed: () {
                      // Scroll to demo section
                      _scrollToDemo(context);
                    },
                    isPrimary: false,
                  ),
                ],
              ),
            ),

            SizedBox(height: 6.h),

            // Features Preview
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 800),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 4.w,
                runSpacing: 2.h,
                children: [
                  _buildFeatureChip(context, '🧠 Smart MCQs'),
                  _buildFeatureChip(context, '📚 NCERT Flashcards'),
                  _buildFeatureChip(context, '🏆 Leaderboard'),
                  _buildFeatureChip(context, '📊 Progress Tracking'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureChip(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(77),
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void _scrollToFooter(BuildContext context) {
    // Implement scroll to footer logic
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  void _scrollToDemo(BuildContext context) {
    // Implement scroll to demo logic
    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }
}
