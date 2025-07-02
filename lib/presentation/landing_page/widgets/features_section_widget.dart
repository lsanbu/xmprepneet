import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class FeaturesSectionWidget extends StatelessWidget {
  const FeaturesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      child: Column(
        children: [
          // Section Title
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Powered by Advanced AI Technology',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 2.h),

          FadeInDown(
            duration: const Duration(milliseconds: 600),
            delay: const Duration(milliseconds: 200),
            child: Text(
              'Experience the future of NEET preparation with our AI-powered features',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 6.h),

          // Features Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.w,
              mainAxisSpacing: 4.w,
              childAspectRatio: 0.8,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 200 * (index + 1)),
                child: _buildFeatureCard(context, _features[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, FeatureModel feature) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(26),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(26),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              feature.icon,
              color: Colors.white,
              size: 24,
            ),
          ),

          SizedBox(height: 3.h),

          // Title
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),

          SizedBox(height: 1.h),

          // Description
          Expanded(
            child: Text(
              feature.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                    height: 1.4,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  static final List<FeatureModel> _features = [
    FeatureModel(
      icon: Icons.quiz_outlined,
      title: 'Smart MCQ Practice',
      description:
          'AI-generated questions tailored to your learning gaps and difficulty level.',
    ),
    FeatureModel(
      icon: Icons.auto_stories_outlined,
      title: 'NCERT Flashcards',
      description:
          'Interactive flashcards from NCERT books with spaced repetition algorithm.',
    ),
    FeatureModel(
      icon: Icons.leaderboard_outlined,
      title: 'Competitive Leaderboard',
      description:
          'Track your progress against peers and stay motivated with rankings.',
    ),
    FeatureModel(
      icon: Icons.analytics_outlined,
      title: 'Smart Progress Tracking',
      description:
          'AI analyzes your performance like a real tutor and provides insights.',
    ),
  ];
}

class FeatureModel {
  final IconData icon;
  final String title;
  final String description;

  FeatureModel({
    required this.icon,
    required this.title,
    required this.description,
  });
}
