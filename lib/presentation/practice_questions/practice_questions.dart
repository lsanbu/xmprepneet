import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/answer_option_widget.dart';
import './widgets/explanation_card_widget.dart';
import './widgets/filter_bottom_sheet_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/question_card_widget.dart';
import './widgets/question_palette_widget.dart';

class PracticeQuestions extends StatefulWidget {
  const PracticeQuestions({super.key});

  @override
  State<PracticeQuestions> createState() => _PracticeQuestionsState();
}

class _PracticeQuestionsState extends State<PracticeQuestions>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _currentQuestionIndex = 0;
  int? _selectedAnswerIndex;
  bool _isAnswerSubmitted = false;
  bool _showExplanation = false;
  String _selectedSubject = 'Physics';
  final bool _isTimerEnabled = false;
  int _remainingTime = 300; // 5 minutes in seconds
  late AnimationController _timerController;
  final Set<int> _bookmarkedQuestions = {};
  final Map<int, int> _userAnswers = {};

  final List<Map<String, dynamic>> _mockQuestions = [
    {
      "id": 1,
      "subject": "Physics",
      "topic": "Mechanics",
      "difficulty": "Medium",
      "question":
          "A ball is thrown vertically upward with an initial velocity of 20 m/s. What is the maximum height reached by the ball? (g = 10 m/s²)",
      "options": ["10 m", "15 m", "20 m", "25 m"],
      "correctAnswer": 2,
      "explanation":
          "Using the equation v² = u² + 2as, where v = 0 at maximum height, u = 20 m/s, a = -g = -10 m/s². Solving: 0 = 400 - 20h, therefore h = 20 m.",
      "timeLimit": 120
    },
    {
      "id": 2,
      "subject": "Chemistry",
      "topic": "Organic Chemistry",
      "difficulty": "Hard",
      "question":
          "Which of the following compounds will show optical isomerism?",
      "options": ["CH₃-CHCl-CH₃", "CH₃-CHBr-COOH", "CH₃-CH₂-CH₃", "CH₃-CO-CH₃"],
      "correctAnswer": 1,
      "explanation":
          "CH₃-CHBr-COOH has a chiral carbon (carbon attached to 4 different groups: H, Br, CH₃, and COOH), making it optically active.",
      "timeLimit": 150
    },
    {
      "id": 3,
      "subject": "Biology",
      "topic": "Cell Biology",
      "difficulty": "Easy",
      "question": "Which organelle is known as the powerhouse of the cell?",
      "options": [
        "Nucleus",
        "Mitochondria",
        "Ribosome",
        "Endoplasmic Reticulum"
      ],
      "correctAnswer": 1,
      "explanation":
          "Mitochondria are called the powerhouse of the cell because they produce ATP (energy) through cellular respiration.",
      "timeLimit": 90
    },
    {
      "id": 4,
      "subject": "Physics",
      "topic": "Thermodynamics",
      "difficulty": "Medium",
      "question":
          "In an adiabatic process, which of the following remains constant?",
      "options": ["Temperature", "Pressure", "Volume", "Entropy"],
      "correctAnswer": 3,
      "explanation":
          "In an adiabatic process, there is no heat exchange with surroundings (Q = 0), and for a reversible adiabatic process, entropy remains constant.",
      "timeLimit": 110
    },
    {
      "id": 5,
      "subject": "Chemistry",
      "topic": "Physical Chemistry",
      "difficulty": "Hard",
      "question":
          "The pH of 0.1 M solution of weak acid (Ka = 1 × 10⁻⁵) is approximately:",
      "options": ["1", "2", "3", "5"],
      "correctAnswer": 2,
      "explanation":
          "For weak acid: pH = ½(pKa - log C) = ½(5 - log 0.1) = ½(5 + 1) = 3",
      "timeLimit": 180
    }
  ];

  final List<String> _subjects = ['Physics', 'Chemistry', 'Biology', 'All'];
  final List<String> _difficulties = ['Easy', 'Medium', 'Hard', 'All'];
  final List<String> _topics = [
    'Mechanics',
    'Thermodynamics',
    'Organic Chemistry',
    'Physical Chemistry',
    'Cell Biology',
    'All'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _timerController = AnimationController(
      duration: Duration(seconds: _remainingTime),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    if (_isTimerEnabled) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timerController.forward();
    _timerController.addListener(() {
      if (mounted) {
        setState(() {
          _remainingTime = (300 * (1 - _timerController.value)).round();
        });
        if (_remainingTime <= 0) {
          _autoSubmitAnswer();
        }
      }
    });
  }

  void _autoSubmitAnswer() {
    if (!_isAnswerSubmitted) {
      setState(() {
        _isAnswerSubmitted = true;
        _showExplanation = true;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _selectAnswer(int index) {
    if (!_isAnswerSubmitted) {
      setState(() {
        _selectedAnswerIndex = index;
      });
      HapticFeedback.selectionClick();
    }
  }

  void _submitAnswer() {
    if (_selectedAnswerIndex != null && !_isAnswerSubmitted) {
      setState(() {
        _isAnswerSubmitted = true;
        _showExplanation = true;
        _userAnswers[_currentQuestionIndex] = _selectedAnswerIndex!;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _mockQuestions.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentQuestionIndex = index;
      _selectedAnswerIndex = _userAnswers[index];
      _isAnswerSubmitted = _userAnswers.containsKey(index);
      _showExplanation = _isAnswerSubmitted;
    });

    if (_isTimerEnabled) {
      _timerController.reset();
      _remainingTime = 300;
      _startTimer();
    }
  }

  void _toggleBookmark() {
    setState(() {
      if (_bookmarkedQuestions.contains(_currentQuestionIndex)) {
        _bookmarkedQuestions.remove(_currentQuestionIndex);
      } else {
        _bookmarkedQuestions.add(_currentQuestionIndex);
      }
    });
    HapticFeedback.lightImpact();
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        selectedSubject: _selectedSubject,
        subjects: _subjects,
        difficulties: _difficulties,
        topics: _topics,
        onFiltersApplied: (subject, difficulty, topic) {
          setState(() {
            _selectedSubject = subject;
          });
        },
      ),
    );
  }

  void _showQuestionPalette() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuestionPaletteWidget(
        totalQuestions: _mockQuestions.length,
        currentQuestion: _currentQuestionIndex,
        answeredQuestions: _userAnswers.keys.toSet(),
        bookmarkedQuestions: _bookmarkedQuestions,
        onQuestionSelected: (index) {
          _pageController.animateToPage(
            index,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
          Navigator.pop(context);
        },
      ),
    );
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: AppTheme.lightTheme.colorScheme.onSurface,
            size: 24,
          ),
        ),
        title: Text(
          'Practice Questions',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        actions: [
          if (_isTimerEnabled)
            Container(
              margin: EdgeInsets.only(right: 4.w),
              padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
              decoration: BoxDecoration(
                color: _remainingTime <= 60
                    ? AppTheme.lightTheme.colorScheme.error
                        .withValues(alpha: 0.1)
                    : AppTheme.lightTheme.colorScheme.primary
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _formatTime(_remainingTime),
                style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                  color: _remainingTime <= 60
                      ? AppTheme.lightTheme.colorScheme.error
                      : AppTheme.lightTheme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          IconButton(
            onPressed: _toggleBookmark,
            icon: CustomIconWidget(
              iconName: _bookmarkedQuestions.contains(_currentQuestionIndex)
                  ? 'bookmark'
                  : 'bookmark_border',
              color: _bookmarkedQuestions.contains(_currentQuestionIndex)
                  ? AppTheme.lightTheme.colorScheme.tertiary
                  : AppTheme.lightTheme.colorScheme.onSurface,
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Subject Selector and Filter Header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.primary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        CustomIconWidget(
                          iconName: 'science',
                          color: AppTheme.lightTheme.colorScheme.primary,
                          size: 20,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          _selectedSubject,
                          style: AppTheme.lightTheme.textTheme.titleMedium
                              ?.copyWith(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 3.w),
                GestureDetector(
                  onTap: _showFilterBottomSheet,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.secondary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.secondary
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'tune',
                      color: AppTheme.lightTheme.colorScheme.secondary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Progress Indicator
          ProgressIndicatorWidget(
            currentQuestion: _currentQuestionIndex + 1,
            totalQuestions: _mockQuestions.length,
          ),

          // Question Content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              itemCount: _mockQuestions.length,
              itemBuilder: (context, index) {
                final question = _mockQuestions[index];
                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(4.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question Card
                        QuestionCardWidget(
                          question: question["question"] as String,
                          subject: question["subject"] as String,
                          topic: question["topic"] as String,
                          difficulty: question["difficulty"] as String,
                        ),

                        SizedBox(height: 3.h),

                        // Answer Options
                        ...List.generate(
                          (question["options"] as List).length,
                          (optionIndex) => Padding(
                            padding: EdgeInsets.only(bottom: 2.h),
                            child: AnswerOptionWidget(
                              option: (question["options"] as List)[optionIndex]
                                  as String,
                              optionIndex: optionIndex,
                              isSelected: _selectedAnswerIndex == optionIndex,
                              isCorrect: _isAnswerSubmitted &&
                                  optionIndex ==
                                      (question["correctAnswer"] as int),
                              isWrong: _isAnswerSubmitted &&
                                  _selectedAnswerIndex == optionIndex &&
                                  optionIndex !=
                                      (question["correctAnswer"] as int),
                              onTap: () => _selectAnswer(optionIndex),
                            ),
                          ),
                        ),

                        SizedBox(height: 3.h),

                        // Submit Button
                        if (!_isAnswerSubmitted && _selectedAnswerIndex != null)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitAnswer,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    AppTheme.lightTheme.colorScheme.primary,
                                foregroundColor:
                                    AppTheme.lightTheme.colorScheme.onPrimary,
                                padding: EdgeInsets.symmetric(vertical: 2.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Submit Answer',
                                style: AppTheme.lightTheme.textTheme.titleMedium
                                    ?.copyWith(
                                  color:
                                      AppTheme.lightTheme.colorScheme.onPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                        // Explanation Card
                        if (_showExplanation)
                          ExplanationCardWidget(
                            explanation: question["explanation"] as String,
                            isCorrect: _selectedAnswerIndex ==
                                (question["correctAnswer"] as int),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // Bottom Navigation Controls
          Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow,
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Previous Button
                Expanded(
                  child: OutlinedButton(
                    onPressed:
                        _currentQuestionIndex > 0 ? _previousQuestion : null,
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomIconWidget(
                          iconName: 'arrow_back',
                          color: _currentQuestionIndex > 0
                              ? AppTheme.lightTheme.colorScheme.primary
                              : AppTheme.lightTheme.colorScheme.onSurface
                                  .withValues(alpha: 0.4),
                          size: 18,
                        ),
                        SizedBox(width: 2.w),
                        Text('Previous'),
                      ],
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Question Palette Button
                GestureDetector(
                  onTap: _showQuestionPalette,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    decoration: BoxDecoration(
                      color: AppTheme.lightTheme.colorScheme.tertiary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.lightTheme.colorScheme.tertiary,
                      ),
                    ),
                    child: CustomIconWidget(
                      iconName: 'grid_view',
                      color: AppTheme.lightTheme.colorScheme.tertiary,
                      size: 20,
                    ),
                  ),
                ),

                SizedBox(width: 3.w),

                // Next Button
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentQuestionIndex < _mockQuestions.length - 1
                        ? _nextQuestion
                        : null,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 1.5.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next'),
                        SizedBox(width: 2.w),
                        CustomIconWidget(
                          iconName: 'arrow_forward',
                          color:
                              _currentQuestionIndex < _mockQuestions.length - 1
                                  ? AppTheme.lightTheme.colorScheme.onPrimary
                                  : AppTheme.lightTheme.colorScheme.onSurface
                                      .withValues(alpha: 0.4),
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
