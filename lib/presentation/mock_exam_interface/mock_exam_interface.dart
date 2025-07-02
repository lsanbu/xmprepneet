import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/exam_header_widget.dart';
import './widgets/exam_navigation_widget.dart';
import './widgets/exam_results_widget.dart';
import './widgets/question_display_widget.dart';
import './widgets/question_palette_widget.dart';

class MockExamInterface extends StatefulWidget {
  const MockExamInterface({super.key});

  @override
  State<MockExamInterface> createState() => _MockExamInterfaceState();
}

class _MockExamInterfaceState extends State<MockExamInterface>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _timerAnimationController;
  late TabController _tabController;

  int _currentQuestionIndex = 0;
  final int _totalQuestions = 50;
  int _remainingTimeInSeconds = 3600; // 60 minutes
  bool _isExamActive = true;
  bool _showQuestionPalette = false;
  bool _isExamCompleted = false;
  bool _isPaused = false;

  // Mock exam data
  final List<Map<String, dynamic>> _examQuestions = [
    {
      "id": 1,
      "question": "Which of the following is the powerhouse of the cell?",
      "options": [
        "Nucleus",
        "Mitochondria",
        "Ribosome",
        "Endoplasmic Reticulum"
      ],
      "correctAnswer": 1,
      "subject": "Biology",
      "difficulty": "Easy",
      "explanation":
          "Mitochondria are known as the powerhouse of the cell because they produce ATP through cellular respiration.",
      "isAttempted": false,
      "selectedAnswer": null,
      "isMarkedForReview": false,
      "timeSpent": 0,
    },
    {
      "id": 2,
      "question": "What is the SI unit of electric current?",
      "options": ["Volt", "Ampere", "Ohm", "Watt"],
      "correctAnswer": 1,
      "subject": "Physics",
      "difficulty": "Easy",
      "explanation":
          "The SI unit of electric current is Ampere (A), named after André-Marie Ampère.",
      "isAttempted": false,
      "selectedAnswer": null,
      "isMarkedForReview": false,
      "timeSpent": 0,
    },
    {
      "id": 3,
      "question": "Which element has the chemical symbol 'Au'?",
      "options": ["Silver", "Gold", "Aluminum", "Argon"],
      "correctAnswer": 1,
      "subject": "Chemistry",
      "difficulty": "Medium",
      "explanation":
          "Gold has the chemical symbol 'Au' from the Latin word 'aurum'.",
      "isAttempted": false,
      "selectedAnswer": null,
      "isMarkedForReview": false,
      "timeSpent": 0,
    },
    {
      "id": 4,
      "question": "What is the derivative of sin(x)?",
      "options": ["cos(x)", "-cos(x)", "tan(x)", "-sin(x)"],
      "correctAnswer": 0,
      "subject": "Mathematics",
      "difficulty": "Medium",
      "explanation": "The derivative of sin(x) with respect to x is cos(x).",
      "isAttempted": false,
      "selectedAnswer": null,
      "isMarkedForReview": false,
      "timeSpent": 0,
    },
    {
      "id": 5,
      "question": "Which organ is responsible for insulin production?",
      "options": ["Liver", "Kidney", "Pancreas", "Spleen"],
      "correctAnswer": 2,
      "subject": "Biology",
      "difficulty": "Medium",
      "explanation":
          "The pancreas produces insulin through specialized cells called beta cells in the islets of Langerhans.",
      "isAttempted": false,
      "selectedAnswer": null,
      "isMarkedForReview": false,
      "timeSpent": 0,
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timerAnimationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _tabController = TabController(length: 4, vsync: this);
    _startExamTimer();
    _enterImmersiveMode();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timerAnimationController.dispose();
    _tabController.dispose();
    _exitImmersiveMode();
    super.dispose();
  }

  void _enterImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  void _exitImmersiveMode() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  void _startExamTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isExamActive && !_isPaused && mounted) {
        setState(() {
          _remainingTimeInSeconds--;
        });

        // Warning dialogs
        if (_remainingTimeInSeconds == 900) {
          // 15 minutes
          _showTimeWarning("15 minutes remaining!");
        } else if (_remainingTimeInSeconds == 300) {
          // 5 minutes
          _showTimeWarning("5 minutes remaining!");
        } else if (_remainingTimeInSeconds == 60) {
          // 1 minute
          _showTimeWarning("1 minute remaining!");
        }

        if (_remainingTimeInSeconds <= 0) {
          _autoSubmitExam();
        } else {
          _startExamTimer();
        }
      }
    });
  }

  void _showTimeWarning(String message) {
    HapticFeedback.vibrate();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.warningLight,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _autoSubmitExam() {
    setState(() {
      _isExamActive = false;
      _isExamCompleted = true;
    });
    _showSubmissionDialog(isAutoSubmit: true);
  }

  void _navigateToQuestion(int index) {
    if (index >= 0 && index < _examQuestions.length) {
      setState(() {
        _currentQuestionIndex = index;
        _showQuestionPalette = false;
      });
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _selectAnswer(int optionIndex) {
    setState(() {
      _examQuestions[_currentQuestionIndex]['selectedAnswer'] = optionIndex;
      _examQuestions[_currentQuestionIndex]['isAttempted'] = true;
    });
  }

  void _toggleMarkForReview() {
    setState(() {
      _examQuestions[_currentQuestionIndex]['isMarkedForReview'] =
          !_examQuestions[_currentQuestionIndex]['isMarkedForReview'];
    });
  }

  void _showSubmissionDialog({bool isAutoSubmit = false}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text(isAutoSubmit ? "Time's Up!" : "Submit Exam"),
        content: Text(isAutoSubmit
            ? "Your exam time has expired. The exam will be submitted automatically."
            : "Are you sure you want to submit your exam? You won't be able to make changes after submission."),
        actions: [
          if (!isAutoSubmit)
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _submitExam();
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  void _submitExam() {
    setState(() {
      _isExamActive = false;
      _isExamCompleted = true;
    });
    _exitImmersiveMode();
  }

  void _pauseExam() {
    setState(() {
      _isPaused = true;
    });
    _showPauseDialog();
  }

  void _showPauseDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Exam Paused"),
        content: const Text("Your exam is paused. Tap Resume to continue."),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _isPaused = false;
              });
              _startExamTimer();
            },
            child: const Text("Resume"),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _calculateResults() {
    int correctAnswers = 0;
    int attemptedQuestions = 0;
    Map<String, int> subjectWiseCorrect = {};
    Map<String, int> subjectWiseTotal = {};

    for (var question in _examQuestions) {
      String subject = question['subject'];
      subjectWiseTotal[subject] = (subjectWiseTotal[subject] ?? 0) + 1;

      if (question['isAttempted']) {
        attemptedQuestions++;
        if (question['selectedAnswer'] == question['correctAnswer']) {
          correctAnswers++;
          subjectWiseCorrect[subject] = (subjectWiseCorrect[subject] ?? 0) + 1;
        }
      }
    }

    double percentage = (correctAnswers / _examQuestions.length) * 100;
    int totalTimeSpent = 3600 - _remainingTimeInSeconds;

    return {
      'correctAnswers': correctAnswers,
      'totalQuestions': _examQuestions.length,
      'attemptedQuestions': attemptedQuestions,
      'percentage': percentage,
      'totalTimeSpent': totalTimeSpent,
      'subjectWiseCorrect': subjectWiseCorrect,
      'subjectWiseTotal': subjectWiseTotal,
      'percentile': 78.5, // Mock percentile
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_isExamCompleted) {
      return ExamResultsWidget(
        results: _calculateResults(),
        examQuestions: _examQuestions,
        onRetakeExam: () {
          setState(() {
            _isExamCompleted = false;
            _isExamActive = true;
            _currentQuestionIndex = 0;
            _remainingTimeInSeconds = 3600;
            // Reset all answers
            for (var question in _examQuestions) {
              question['isAttempted'] = false;
              question['selectedAnswer'] = null;
              question['isMarkedForReview'] = false;
            }
          });
          _enterImmersiveMode();
          _startExamTimer();
        },
        onBackToDashboard: () {
          Navigator.pushReplacementNamed(context, '/ai-chat-dashboard');
        },
      );
    }

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Exam Header
                ExamHeaderWidget(
                  examTitle: "NEET Mock Test 2024",
                  remainingTime: _remainingTimeInSeconds,
                  currentQuestion: _currentQuestionIndex + 1,
                  totalQuestions: _totalQuestions,
                  onPalettePressed: () {
                    setState(() {
                      _showQuestionPalette = !_showQuestionPalette;
                    });
                  },
                  onPausePressed: _pauseExam,
                ),

                // Question Display Area
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentQuestionIndex = index;
                      });
                    },
                    itemCount: _examQuestions.length,
                    itemBuilder: (context, index) {
                      return QuestionDisplayWidget(
                        question: _examQuestions[index],
                        questionNumber: index + 1,
                        onAnswerSelected: _selectAnswer,
                        onMarkForReview: _toggleMarkForReview,
                      );
                    },
                  ),
                ),

                // Navigation Controls
                ExamNavigationWidget(
                  currentIndex: _currentQuestionIndex,
                  totalQuestions: _examQuestions.length,
                  onPrevious: () {
                    if (_currentQuestionIndex > 0) {
                      _navigateToQuestion(_currentQuestionIndex - 1);
                    }
                  },
                  onNext: () {
                    if (_currentQuestionIndex < _examQuestions.length - 1) {
                      _navigateToQuestion(_currentQuestionIndex + 1);
                    }
                  },
                  onSubmit: () => _showSubmissionDialog(),
                ),
              ],
            ),

            // Question Palette Overlay
            if (_showQuestionPalette)
              QuestionPaletteWidget(
                questions: _examQuestions,
                currentIndex: _currentQuestionIndex,
                onQuestionSelected: _navigateToQuestion,
                onClose: () {
                  setState(() {
                    _showQuestionPalette = false;
                  });
                },
              ),
          ],
        ),
      ),
    );
  }
}
