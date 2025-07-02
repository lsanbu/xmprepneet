import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/difficulty_buttons_widget.dart';
import './widgets/flashcard_widget.dart';
import './widgets/progress_indicator_widget.dart';
import './widgets/session_complete_widget.dart';
import './widgets/study_header_widget.dart';

class FlashcardsStudy extends StatefulWidget {
  const FlashcardsStudy({super.key});

  @override
  State<FlashcardsStudy> createState() => _FlashcardsStudyState();
}

class _FlashcardsStudyState extends State<FlashcardsStudy>
    with TickerProviderStateMixin {
  late AnimationController _flipController;
  late AnimationController _swipeController;
  late Animation<double> _flipAnimation;
  late Animation<Offset> _swipeAnimation;

  bool _isFlipped = false;
  int _currentCardIndex = 0;
  bool _isSessionComplete = false;
  int _correctAnswers = 0;
  int _totalAnswered = 0;

  // Mock flashcard data
  final List<Map<String, dynamic>> _flashcards = [
    {
      "id": 1,
      "question": "What is the powerhouse of the cell?",
      "answer":
          "Mitochondria - responsible for cellular respiration and ATP production",
      "subject": "Biology",
      "difficulty": "Easy",
      "isFavorite": false,
    },
    {
      "id": 2,
      "question": "What is the chemical formula for glucose?",
      "answer":
          "C₆H₁₂O₆ - a simple sugar that serves as the primary source of energy for cells",
      "subject": "Chemistry",
      "difficulty": "Medium",
      "isFavorite": true,
    },
    {
      "id": 3,
      "question": "What is Newton's second law of motion?",
      "answer":
          "F = ma - Force equals mass times acceleration. This fundamental law describes the relationship between force, mass, and acceleration.",
      "subject": "Physics",
      "difficulty": "Medium",
      "isFavorite": false,
    },
    {
      "id": 4,
      "question": "What is the process of photosynthesis?",
      "answer":
          "6CO₂ + 6H₂O + light energy → C₆H₁₂O₆ + 6O₂ - Plants convert carbon dioxide and water into glucose using sunlight",
      "subject": "Biology",
      "difficulty": "Hard",
      "isFavorite": false,
    },
    {
      "id": 5,
      "question": "What is the atomic number of carbon?",
      "answer":
          "6 - Carbon has 6 protons in its nucleus, making it the basis for all organic compounds",
      "subject": "Chemistry",
      "difficulty": "Easy",
      "isFavorite": true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _swipeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _flipAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _flipController,
      curve: Curves.easeInOut,
    ));

    _swipeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(
      parent: _swipeController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _flipController.dispose();
    _swipeController.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (!_isFlipped) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() {
      _isFlipped = !_isFlipped;
    });
    HapticFeedback.lightImpact();
  }

  void _handleDifficulty(String difficulty) {
    HapticFeedback.mediumImpact();

    if (difficulty == 'Easy') {
      _correctAnswers++;
    }
    _totalAnswered++;

    _swipeController.forward().then((_) {
      _swipeController.reset();
      _nextCard();
    });
  }

  void _nextCard() {
    if (_currentCardIndex < _flashcards.length - 1) {
      setState(() {
        _currentCardIndex++;
        _isFlipped = false;
      });
      _flipController.reset();
    } else {
      setState(() {
        _isSessionComplete = true;
      });
    }
  }

  void _restartSession() {
    setState(() {
      _currentCardIndex = 0;
      _isFlipped = false;
      _isSessionComplete = false;
      _correctAnswers = 0;
      _totalAnswered = 0;
    });
    _flipController.reset();
    _swipeController.reset();
  }

  void _toggleFavorite() {
    setState(() {
      _flashcards[_currentCardIndex]['isFavorite'] =
          !(_flashcards[_currentCardIndex]['isFavorite'] as bool);
    });
    HapticFeedback.lightImpact();
  }

  void _showCardOptions() {
    HapticFeedback.heavyImpact();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: AppTheme.lightTheme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.all(4.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.outline,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: AppTheme.lightTheme.colorScheme.primary,
                size: 24,
              ),
              title: Text(
                'Edit Card',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Edit functionality would be implemented here
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: _flashcards[_currentCardIndex]['isFavorite'] as bool
                    ? 'favorite'
                    : 'favorite_border',
                color: _flashcards[_currentCardIndex]['isFavorite'] as bool
                    ? AppTheme.lightTheme.colorScheme.error
                    : AppTheme.lightTheme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text(
                _flashcards[_currentCardIndex]['isFavorite'] as bool
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _toggleFavorite();
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'report',
                color: AppTheme.lightTheme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Report Error',
                style: AppTheme.lightTheme.textTheme.bodyLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                // Report functionality would be implemented here
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: _isSessionComplete
            ? SessionCompleteWidget(
                totalCards: _flashcards.length,
                correctAnswers: _correctAnswers,
                totalAnswered: _totalAnswered,
                onRestart: _restartSession,
                onBackToMenu: () => Navigator.pop(context),
              )
            : Column(
                children: [
                  StudyHeaderWidget(
                    deckName: "NEET Biology Essentials",
                    remainingCards: _flashcards.length - _currentCardIndex,
                    totalCards: _flashcards.length,
                    onSettingsPressed: () {
                      // Settings functionality would be implemented here
                    },
                    onBackPressed: () => Navigator.pop(context),
                  ),
                  SizedBox(height: 2.h),
                  ProgressIndicatorWidget(
                    currentIndex: _currentCardIndex,
                    totalCards: _flashcards.length,
                  ),
                  SizedBox(height: 3.h),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: GestureDetector(
                        onTap: _flipCard,
                        onLongPress: _showCardOptions,
                        onPanEnd: (details) {
                          if (details.velocity.pixelsPerSecond.dx > 500) {
                            _handleDifficulty('Easy');
                          } else if (details.velocity.pixelsPerSecond.dx <
                              -500) {
                            _handleDifficulty('Hard');
                          } else if (details.velocity.pixelsPerSecond.dy <
                              -500) {
                            _handleDifficulty('Again');
                          }
                        },
                        child: AnimatedBuilder(
                          animation: _swipeAnimation,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: _swipeAnimation.value,
                              child: FlashcardWidget(
                                flashcard: _flashcards[_currentCardIndex],
                                isFlipped: _isFlipped,
                                flipAnimation: _flipAnimation,
                                onFlip: _flipCard,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  DifficultyButtonsWidget(
                    onDifficultySelected: _handleDifficulty,
                    isAnswerVisible: _isFlipped,
                  ),
                  SizedBox(height: 3.h),
                ],
              ),
      ),
    );
  }
}
