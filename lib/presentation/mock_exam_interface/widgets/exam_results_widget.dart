import 'package:fl_chart/fl_chart.dart';

import '../../../core/app_export.dart';

class ExamResultsWidget extends StatefulWidget {
  final Map<String, dynamic> results;
  final List<Map<String, dynamic>> examQuestions;
  final VoidCallback onRetakeExam;
  final VoidCallback onBackToDashboard;

  const ExamResultsWidget({
    super.key,
    required this.results,
    required this.examQuestions,
    required this.onRetakeExam,
    required this.onBackToDashboard,
  });

  @override
  State<ExamResultsWidget> createState() => _ExamResultsWidgetState();
}

class _ExamResultsWidgetState extends State<ExamResultsWidget>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  Color _getPerformanceColor(double percentage) {
    if (percentage >= 80) return AppTheme.successLight;
    if (percentage >= 60) return AppTheme.warningLight;
    return AppTheme.errorLight;
  }

  @override
  Widget build(BuildContext context) {
    final int correctAnswers = widget.results['correctAnswers'];
    final int totalQuestions = widget.results['totalQuestions'];
    final double percentage = widget.results['percentage'];
    final int attemptedQuestions = widget.results['attemptedQuestions'];
    final int totalTimeSpent = widget.results['totalTimeSpent'];
    final double percentile = widget.results['percentile'];

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryLight, AppTheme.secondaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: widget.onBackToDashboard,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: EdgeInsets.all(2.w),
                            child: CustomIconWidget(
                              iconName: 'arrow_back',
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            'Exam Results',
                            textAlign: TextAlign.center,
                            style: AppTheme.lightTheme.textTheme.headlineSmall
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w), // Balance the back button
                      ],
                    ),
                    SizedBox(height: 3.h),
                    // Score display
                    Container(
                      padding: EdgeInsets.all(4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: AppTheme.lightTheme.textTheme.displayMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '$correctAnswers out of $totalQuestions correct',
                            style: AppTheme.lightTheme.textTheme.bodyLarge
                                ?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildQuickStat(
                                  'Attempted', '$attemptedQuestions'),
                              _buildQuickStat(
                                  'Time Spent', _formatTime(totalTimeSpent)),
                              _buildQuickStat(
                                  'Percentile', percentile.toStringAsFixed(1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Tab bar
              Container(
                color: AppTheme.lightTheme.colorScheme.surface,
                child: TabBar(
                  controller: _tabController,
                  tabs: const [
                    Tab(text: 'Overview'),
                    Tab(text: 'Analysis'),
                    Tab(text: 'Review'),
                  ],
                ),
              ),

              // Tab content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildOverviewTab(),
                    _buildAnalysisTab(),
                    _buildReviewTab(),
                  ],
                ),
              ),

              // Action buttons
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.shadowLight,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: widget.onRetakeExam,
                        style: OutlinedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: const Text('Retake Exam'),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: widget.onBackToDashboard,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 2.h),
                        ),
                        child: const Text('Back to Dashboard'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStat(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
            color: Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewTab() {
    final Map<String, int> subjectWiseCorrect =
        (widget.results['subjectWiseCorrect'] as Map<String, int>?) ?? {};
    final Map<String, int> subjectWiseTotal =
        (widget.results['subjectWiseTotal'] as Map<String, int>?) ?? {};

    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance summary
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Summary',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildPerformanceItem(
                    'Overall Score',
                    '${widget.results['percentage'].toStringAsFixed(1)}%',
                    _getPerformanceColor(widget.results['percentage']),
                  ),
                  _buildPerformanceItem(
                    'Questions Attempted',
                    '${widget.results['attemptedQuestions']} / ${widget.results['totalQuestions']}',
                    AppTheme.primaryLight,
                  ),
                  _buildPerformanceItem(
                    'Accuracy',
                    '${((widget.results['correctAnswers'] / widget.results['attemptedQuestions']) * 100).toStringAsFixed(1)}%',
                    AppTheme.successLight,
                  ),
                  _buildPerformanceItem(
                    'Time Management',
                    _formatTime(widget.results['totalTimeSpent']),
                    AppTheme.secondaryLight,
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Subject-wise performance
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subject-wise Performance',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ...subjectWiseTotal.entries.map((entry) {
                    String subject = entry.key;
                    int total = entry.value;
                    int correct = subjectWiseCorrect[subject] ?? 0;
                    double percentage = (correct / total) * 100;

                    return Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                subject,
                                style: AppTheme.lightTheme.textTheme.bodyLarge
                                    ?.copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$correct/$total (${percentage.toStringAsFixed(1)}%)',
                                style: AppTheme.lightTheme.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: _getPerformanceColor(percentage),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 1.h),
                          LinearProgressIndicator(
                            value: percentage / 100,
                            backgroundColor: AppTheme.dividerLight,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _getPerformanceColor(percentage),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(4.w),
      child: Column(
        children: [
          // Performance chart
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Performance Analysis',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    height: 40.h,
                    child: PieChart(
                      PieChartData(
                        sections: [
                          PieChartSectionData(
                            value: widget.results['correctAnswers'].toDouble(),
                            title:
                                'Correct\n${widget.results['correctAnswers']}',
                            color: AppTheme.successLight,
                            radius: 15.w,
                            titleStyle: AppTheme
                                .lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PieChartSectionData(
                            value: (widget.results['attemptedQuestions'] -
                                    widget.results['correctAnswers'])
                                .toDouble(),
                            title:
                                'Incorrect\n${widget.results['attemptedQuestions'] - widget.results['correctAnswers']}',
                            color: AppTheme.errorLight,
                            radius: 15.w,
                            titleStyle: AppTheme
                                .lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          PieChartSectionData(
                            value: (widget.results['totalQuestions'] -
                                    widget.results['attemptedQuestions'])
                                .toDouble(),
                            title:
                                'Unattempted\n${widget.results['totalQuestions'] - widget.results['attemptedQuestions']}',
                            color: AppTheme.textDisabledLight,
                            radius: 15.w,
                            titleStyle: AppTheme
                                .lightTheme.textTheme.labelMedium
                                ?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        centerSpaceRadius: 8.w,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 2.h),

          // Recommendations
          Card(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recommendations',
                    style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  _buildRecommendation(
                    'Time Management',
                    'You completed the exam in ${_formatTime(widget.results['totalTimeSpent'])}. Practice more timed tests to improve speed.',
                    CustomIconWidget(
                        iconName: 'timer',
                        color: AppTheme.warningLight,
                        size: 20),
                  ),
                  _buildRecommendation(
                    'Accuracy',
                    'Focus on understanding concepts rather than memorization to improve accuracy.',
                    CustomIconWidget(
                        iconName: 'target',
                        color: AppTheme.successLight,
                        size: 20),
                  ),
                  _buildRecommendation(
                    'Subject Focus',
                    'Review weak subjects and practice more questions in those areas.',
                    CustomIconWidget(
                        iconName: 'book',
                        color: AppTheme.primaryLight,
                        size: 20),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewTab() {
    return ListView.builder(
      padding: EdgeInsets.all(4.w),
      itemCount: widget.examQuestions.length,
      itemBuilder: (context, index) {
        final question = widget.examQuestions[index];
        final bool isCorrect =
            question['selectedAnswer'] == question['correctAnswer'];
        final bool isAttempted = question['isAttempted'] ?? false;

        return Card(
          margin: EdgeInsets.only(bottom: 2.h),
          child: Padding(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Question header
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: isAttempted
                            ? (isCorrect
                                ? AppTheme.successLight
                                : AppTheme.errorLight)
                            : AppTheme.textDisabledLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Q${index + 1}',
                        style:
                            AppTheme.lightTheme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Expanded(
                      child: Text(
                        isAttempted
                            ? (isCorrect ? 'Correct' : 'Incorrect')
                            : 'Not Attempted',
                        style:
                            AppTheme.lightTheme.textTheme.labelMedium?.copyWith(
                          color: isAttempted
                              ? (isCorrect
                                  ? AppTheme.successLight
                                  : AppTheme.errorLight)
                              : AppTheme.textDisabledLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 2.h),

                // Question text
                Text(
                  question['question'] ?? '',
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 2.h),

                // Answer details
                if (isAttempted) ...[
                  Text(
                    'Your Answer: ${String.fromCharCode(65 + (question['selectedAnswer'] as num).toInt())}. ${(question['options'] as List)[(question['selectedAnswer'] as num).toInt()]}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: isCorrect
                          ? AppTheme.successLight
                          : AppTheme.errorLight,
                    ),
                  ),
                  SizedBox(height: 1.h),
                ],

                Text(
                  'Correct Answer: ${String.fromCharCode(65 + (question['correctAnswer'] as num).toInt())}. ${(question['options'] as List)[(question['correctAnswer'] as num).toInt()]}',
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.successLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                if (question['explanation'] != null) ...[
                  SizedBox(height: 1.h),
                  Text(
                    'Explanation: ${question['explanation']}',
                    style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textMediumEmphasisLight,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPerformanceItem(String label, String value, Color color) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodyMedium,
          ),
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(String title, String description, Widget icon) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          icon,
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.lightTheme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textMediumEmphasisLight,
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
