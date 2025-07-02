import 'package:flutter/material.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/ai_chat_dashboard/ai_chat_dashboard.dart';
import '../presentation/flashcards_study/flashcards_study.dart';
import '../presentation/leaderboard_rankings/leaderboard_rankings.dart';
import '../presentation/practice_questions/practice_questions.dart';
import '../presentation/mock_exam_interface/mock_exam_interface.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String loginScreen = '/login-screen';
  static const String aiChatDashboard = '/ai-chat-dashboard';
  static const String flashcardsStudy = '/flashcards-study';
  static const String leaderboardRankings = '/leaderboard-rankings';
  static const String practiceQuestions = '/practice-questions';
  static const String mockExamInterface = '/mock-exam-interface';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const LoginScreen(),
    loginScreen: (context) => const LoginScreen(),
    aiChatDashboard: (context) => const AiChatDashboard(),
    flashcardsStudy: (context) => const FlashcardsStudy(),
    leaderboardRankings: (context) => const LeaderboardRankings(),
    practiceQuestions: (context) => const PracticeQuestions(),
    mockExamInterface: (context) => const MockExamInterface(),
    // TODO: Add your other routes here
  };
}
