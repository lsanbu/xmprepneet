import 'package:animate_do/animate_do.dart';

import '../../../core/app_export.dart';

class FooterSectionWidget extends StatefulWidget {
  const FooterSectionWidget({super.key});

  @override
  State<FooterSectionWidget> createState() => _FooterSectionWidgetState();
}

class _FooterSectionWidgetState extends State<FooterSectionWidget> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).scaffoldBackgroundColor,
            Theme.of(context).colorScheme.primary.withAlpha(13),
          ],
        ),
      ),
      child: Column(
        children: [
          // Waitlist Section
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 8.h),
            child: Column(
              children: [
                // Waitlist Title
                FadeInDown(
                  duration: const Duration(milliseconds: 600),
                  child: Text(
                    'Join the Waitlist',
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
                    'Be the first to experience the future of NEET preparation.\nGet early access and exclusive benefits.',
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

                // Waitlist Form
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 400),
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 90.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context)
                              .colorScheme
                              .shadow
                              .withAlpha(26),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name Field
                        CustomTextFieldWidget(
                          controller: _nameController,
                          hintText: 'Your Name',
                          prefixIcon: Icons.person_outline,
                        ),

                        SizedBox(height: 2.h),

                        // Email Field
                        CustomTextFieldWidget(
                          controller: _emailController,
                          hintText: 'Your Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),

                        SizedBox(height: 3.h),

                        // Submit Button
                        CustomButtonWidget(
                          text: _isSubmitting ? 'Joining...' : 'Join Waitlist',
                          onPressed: _isSubmitting ? null : _submitWaitlist,
                          isPrimary: true,
                          isLoading: _isSubmitting,
                        ),

                        SizedBox(height: 2.h),

                        // Benefits
                        Text(
                          '✨ Early access • 🎯 Exclusive content • 💰 Special pricing',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withAlpha(153),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Footer Content
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(8),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outline.withAlpha(51),
                ),
              ),
            ),
            child: Column(
              children: [
                // Social Links
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 600),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildSocialButton(
                        context,
                        Icons.web,
                        'Website',
                        'https://xmprepneet.com',
                      ),
                      SizedBox(width: 4.w),
                      _buildSocialButton(
                        context,
                        Icons.email,
                        'Email',
                        'mailto:support@xmprepneet.com',
                      ),
                      SizedBox(width: 4.w),
                      _buildSocialButton(
                        context,
                        Icons.phone,
                        'WhatsApp',
                        'https://wa.me/+919876543210',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 4.h),

                // Footer Text
                FadeInUp(
                  duration: const Duration(milliseconds: 800),
                  delay: const Duration(milliseconds: 800),
                  child: Column(
                    children: [
                      Text(
                        'Built in India. Designed with ❤️ for NEET Aspirants.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.w500,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 1.h),
                      Text(
                        '© 2024 XmPrepNEET. All rights reserved.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withAlpha(153),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context,
    IconData icon,
    String label,
    String url,
  ) {
    return InkWell(
      onTap: () => _launchUrl(url),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withAlpha(77),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(width: 1.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitWaitlist() async {
    if (_nameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty) {
      Fluttertoast.showToast(
        msg: 'Please fill in all fields',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    // Basic email validation
    if (!_emailController.text.contains('@')) {
      Fluttertoast.showToast(
        msg: 'Please enter a valid email address',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Simulate API call for waitlist submission
      await Future.delayed(const Duration(seconds: 2));

      // Show success message
      Fluttertoast.showToast(
        msg: 'Welcome to the waitlist! Check your email for confirmation.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );

      // Clear form
      _nameController.clear();
      _emailController.clear();
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'Something went wrong. Please try again.',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Fluttertoast.showToast(
        msg: 'Could not launch $url',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
  }
}
