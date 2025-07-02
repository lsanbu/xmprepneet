import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class FaqSectionWidget extends StatefulWidget {
  const FaqSectionWidget({super.key});

  @override
  State<FaqSectionWidget> createState() => _FaqSectionWidgetState();
}

class _FaqSectionWidgetState extends State<FaqSectionWidget> {
  int _expandedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
      ),
      child: Column(
        children: [
          // Section Title
          FadeInDown(
            duration: const Duration(milliseconds: 600),
            child: Text(
              'Frequently Asked Questions',
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
              'Everything you need to know about XmPrepNEET',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 6.h),

          // FAQ List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _faqs.length,
            itemBuilder: (context, index) {
              return FadeInUp(
                duration: const Duration(milliseconds: 600),
                delay: Duration(milliseconds: 100 * (index + 1)),
                child: Container(
                  margin: EdgeInsets.only(bottom: 2.h),
                  child: _buildFaqItem(context, _faqs[index], index),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFaqItem(BuildContext context, FaqModel faq, int index) {
    final isExpanded = _expandedIndex == index;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withAlpha(26),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(
          color: isExpanded
              ? Theme.of(context).colorScheme.primary.withAlpha(77)
              : Theme.of(context).colorScheme.outline.withAlpha(26),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          title: Text(
            faq.question,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isExpanded
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.onSurface,
                ),
          ),
          trailing: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: isExpanded
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline.withAlpha(51),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              isExpanded ? Icons.remove : Icons.add,
              color: isExpanded
                  ? Colors.white
                  : Theme.of(context).colorScheme.onSurface,
              size: 18,
            ),
          ),
          onExpansionChanged: (expanded) {
            setState(() {
              _expandedIndex = expanded ? index : -1;
            });
          },
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(4.w, 0, 4.w, 4.w),
              child: Text(
                faq.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      height: 1.5,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withAlpha(179),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static final List<FaqModel> _faqs = [
    FaqModel(
      question:
          'What is Generative AI and how does it help in NEET preparation?',
      answer:
          'Generative AI is advanced artificial intelligence that can understand and generate human-like text. In XmPrepNEET, it creates personalized questions, explains concepts in simple terms, and adapts to your learning pace - just like having a personal tutor available 24/7.',
    ),
    FaqModel(
      question: 'Is XmPrepNEET free to use?',
      answer:
          'We offer a free tier with basic features including limited AI interactions and flashcards. Our premium plans provide unlimited access to all features, advanced analytics, and priority support. We believe quality education should be accessible to all.',
    ),
    FaqModel(
      question: 'How secure is my data with XmPrepNEET?',
      answer:
          'Your data security is our top priority. We use industry-standard encryption, never share your personal information with third parties, and comply with all data protection regulations. Your study progress and personal details are completely safe with us.',
    ),
    FaqModel(
      question: 'Can I use XmPrepNEET offline?',
      answer:
          'While core AI features require internet connectivity, we offer offline modes for previously downloaded flashcards and practice questions. We\'re working on expanding offline capabilities in future updates.',
    ),
    FaqModel(
      question: 'How does the AI tutor compare to human teachers?',
      answer:
          'Our AI tutor complements human teachers rather than replaces them. It\'s available 24/7, never gets tired of questions, provides instant feedback, and personalizes content to your needs. However, human teachers provide emotional support and complex problem-solving that AI currently cannot match.',
    ),
    FaqModel(
      question: 'When will the full version be available?',
      answer:
          'We\'re currently in beta testing phase with select users. The full version will be launched in early 2024. Join our waitlist to be among the first to access all features and get exclusive early-bird pricing.',
    ),
  ];
}

class FaqModel {
  final String question;
  final String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });
}
