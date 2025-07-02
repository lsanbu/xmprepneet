import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class DemoSectionWidget extends StatefulWidget {
  const DemoSectionWidget({super.key});

  @override
  State<DemoSectionWidget> createState() => _DemoSectionWidgetState();
}

class _DemoSectionWidgetState extends State<DemoSectionWidget> {
  final TextEditingController _questionController = TextEditingController();
  final OpenAIClient _openAIClient = OpenAIClient(OpenAIService().dio);
  String _response = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

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
              'Experience AI-Powered Learning',
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
              'Ask any NEET Biology question and see how our AI tutor responds',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color:
                        Theme.of(context).colorScheme.onSurface.withAlpha(179),
                  ),
              textAlign: TextAlign.center,
            ),
          ),

          SizedBox(height: 4.h),

          // Demo Container
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 400),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(maxWidth: 90.w),
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow.withAlpha(26),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: Theme.of(context).colorScheme.outline.withAlpha(51),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Input Section
                  Text(
                    'Try asking: "Explain photosynthesis process"',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withAlpha(153),
                          fontStyle: FontStyle.italic,
                        ),
                  ),

                  SizedBox(height: 2.h),

                  CustomTextFieldWidget(
                    controller: _questionController,
                    hintText: 'Ask any NEET Biology question...',
                    maxLines: 3,
                  ),

                  SizedBox(height: 2.h),

                  // Action Button
                  Center(
                    child: CustomButtonWidget(
                      text: _isLoading ? 'Getting Answer...' : 'Ask AI Tutor',
                      onPressed: _isLoading ? null : _askAITutor,
                      isPrimary: true,
                      isLoading: _isLoading,
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // Response Section
                  if (_response.isNotEmpty) ...[
                    Divider(
                      color:
                          Theme.of(context).colorScheme.outline.withAlpha(77),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Icon(
                            Icons.smart_toy,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          'AI Tutor Response:',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color:
                            Theme.of(context).colorScheme.primary.withAlpha(13),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withAlpha(51),
                        ),
                      ),
                      child: Text(
                        _response,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              height: 1.5,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),

          SizedBox(height: 4.h),

          // Demo Features
          FadeInUp(
            duration: const Duration(milliseconds: 800),
            delay: const Duration(milliseconds: 600),
            child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 4.w,
              runSpacing: 2.h,
              children: [
                _buildDemoFeature(context, '⚡ Instant Responses'),
                _buildDemoFeature(context, '🎯 Contextual Answers'),
                _buildDemoFeature(context, '📖 NCERT Based'),
                _buildDemoFeature(context, '🧠 Adaptive Learning'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDemoFeature(BuildContext context, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withAlpha(26),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withAlpha(77),
        ),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Future<void> _askAITutor() async {
    if (_questionController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please enter a question first',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _response = '';
    });

    try {
      final messages = [
        Message(
          role: 'system',
          content:
              'You are an expert NEET Biology tutor. Provide clear, concise, and accurate answers to biology questions. Keep responses under 200 words and focus on key concepts that are important for NEET preparation.',
        ),
        Message(
          role: 'user',
          content: _questionController.text.trim(),
        ),
      ];

      final completion = await _openAIClient.createChatCompletion(
        messages: messages,
        model: 'gpt-4o-mini',
        options: {
          'temperature': 0.7,
          'max_tokens': 300,
        },
      );

      setState(() {
        _response = completion.text;
      });
    } catch (e) {
      setState(() {
        _response =
            'Sorry, I encountered an error while processing your question. Please try again or check your internet connection.';
      });

      Fluttertoast.showToast(
        msg: 'Error: ${e.toString()}',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
