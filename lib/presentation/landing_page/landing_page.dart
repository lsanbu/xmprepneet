import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/demo_section_widget.dart';
import './widgets/faq_section_widget.dart';
import './widgets/features_section_widget.dart';
import './widgets/footer_section_widget.dart';
import './widgets/hero_section_widget.dart';
import './widgets/testimonials_section_widget.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            // Hero Section
            FadeInDown(
              duration: const Duration(milliseconds: 800),
              child: const HeroSectionWidget(),
            ),

            // Features Section
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 200),
              child: const FeaturesSectionWidget(),
            ),

            // Demo Section
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 400),
              child: const DemoSectionWidget(),
            ),

            // Testimonials Section
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 600),
              child: const TestimonialsSectionWidget(),
            ),

            // FAQ Section
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 800),
              child: const FaqSectionWidget(),
            ),

            // Footer Section
            FadeInUp(
              duration: const Duration(milliseconds: 800),
              delay: const Duration(milliseconds: 1000),
              child: const FooterSectionWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
