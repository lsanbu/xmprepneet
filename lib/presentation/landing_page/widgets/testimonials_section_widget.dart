import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class TestimonialsSectionWidget extends StatelessWidget {
  const TestimonialsSectionWidget({super.key});

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
              'What Students & Educators Say',
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
              'Early feedback from our beta testers and education partners',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 6.h),

          // Testimonials List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _testimonials.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 200 * (index + 1)),
                child: Container(
                  margin: EdgeInsets.only(bottom: 4.h),
                  child: _buildTestimonialCard(context, _testimonials[index]),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTestimonialCard(
      BuildContext context, TestimonialModel testimonial) {
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
          // Quote
          Text(
            '"${testimonial.quote}"',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.6,
                  fontStyle: FontStyle.italic,
                  color: Theme.of(context).colorScheme.onSurface.withAlpha(204),
                ),
          ),

          SizedBox(height: 3.h),

          // Author Info
          Row(
            children: [
              // Avatar
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
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Center(
                  child: Text(
                    testimonial.name[0].toUpperCase(),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              SizedBox(width: 3.w),

              // Name and Role
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      testimonial.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      testimonial.role,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(153),
                          ),
                    ),
                  ],
                ),
              ),

              // Rating Stars
              Row(
                children: List.generate(5, (index) {
                  return Icon(
                    Icons.star,
                    size: 16,
                    color: index < testimonial.rating
                        ? Colors.amber
                        : Theme.of(context).colorScheme.outline.withAlpha(77),
                  );
                }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static final List<TestimonialModel> _testimonials = [
    TestimonialModel(
      name: 'Priya Sharma',
      role: 'NEET Aspirant, Tamil Nadu',
      quote:
          'The AI tutor explains concepts better than my coaching center. It never gets tired of my questions and adapts to my learning pace perfectly!',
      rating: 5,
    ),
    TestimonialModel(
      name: 'Dr. Rajesh Kumar',
      role: 'Biology Teacher, Chennai',
      quote:
          'As an educator, I\'m impressed by the quality of AI-generated questions. They\'re perfectly aligned with NEET patterns and help students think critically.',
      rating: 5,
    ),
    TestimonialModel(
      name: 'Arjun Patel',
      role: 'NEET Repeater, Gujarat',
      quote:
          'The personalized flashcards helped me identify my weak areas quickly. The spaced repetition feature is a game-changer for long-term retention.',
      rating: 5,
    ),
  ];
}

class TestimonialModel {
  final String name;
  final String role;
  final String quote;
  final int rating;

  TestimonialModel({
    required this.name,
    required this.role,
    required this.quote,
    required this.rating,
  });
}
