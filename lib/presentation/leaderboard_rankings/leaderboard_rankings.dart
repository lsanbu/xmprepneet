import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/current_user_position_widget.dart';
import './widgets/empty_leaderboard_widget.dart';
import './widgets/leaderboard_card_widget.dart';
import './widgets/leaderboard_filter_widget.dart';
import './widgets/user_search_widget.dart';

class LeaderboardRankings extends StatefulWidget {
  const LeaderboardRankings({super.key});

  @override
  State<LeaderboardRankings> createState() => _LeaderboardRankingsState();
}

class _LeaderboardRankingsState extends State<LeaderboardRankings>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  int _selectedFilterIndex = 0;
  String _selectedTimePeriod = 'weekly';
  String _selectedCategory = 'overall';
  bool _isLoading = false;
  bool _isSearching = false;
  String _searchQuery = '';

  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Mock data for leaderboard
  final List<Map<String, dynamic>> _leaderboardData = [
    {
      "rank": 1,
      "userId": "user_001",
      "name": "Arjun Sharma",
      "avatar":
          "https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2850,
      "streak": 45,
      "tier": "Diamond",
      "location": "Delhi",
      "center": "Aakash Institute",
      "isCurrentUser": false,
      "badges": ["Top Performer", "Streak Master"],
      "subjectScores": {"Physics": 95, "Chemistry": 92, "Biology": 88}
    },
    {
      "rank": 2,
      "userId": "user_002",
      "name": "Priya Patel",
      "avatar":
          "https://images.pexels.com/photos/1239291/pexels-photo-1239291.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2720,
      "streak": 38,
      "tier": "Gold",
      "location": "Mumbai",
      "center": "Allen Career Institute",
      "isCurrentUser": false,
      "badges": ["Consistent Learner"],
      "subjectScores": {"Physics": 90, "Chemistry": 94, "Biology": 89}
    },
    {
      "rank": 3,
      "userId": "user_003",
      "name": "Rahul Kumar",
      "avatar":
          "https://images.pexels.com/photos/1681010/pexels-photo-1681010.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2650,
      "streak": 32,
      "tier": "Gold",
      "location": "Bangalore",
      "center": "FIITJEE",
      "isCurrentUser": true,
      "badges": ["Rising Star"],
      "subjectScores": {"Physics": 87, "Chemistry": 91, "Biology": 93}
    },
    {
      "rank": 4,
      "userId": "user_004",
      "name": "Sneha Reddy",
      "avatar":
          "https://images.pexels.com/photos/1130626/pexels-photo-1130626.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2580,
      "streak": 28,
      "tier": "Silver",
      "location": "Hyderabad",
      "center": "Narayana",
      "isCurrentUser": false,
      "badges": ["Quick Learner"],
      "subjectScores": {"Physics": 89, "Chemistry": 86, "Biology": 92}
    },
    {
      "rank": 5,
      "userId": "user_005",
      "name": "Vikash Singh",
      "avatar":
          "https://images.pexels.com/photos/1222271/pexels-photo-1222271.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2450,
      "streak": 25,
      "tier": "Silver",
      "location": "Patna",
      "center": "Resonance",
      "isCurrentUser": false,
      "badges": ["Dedicated Student"],
      "subjectScores": {"Physics": 85, "Chemistry": 88, "Biology": 87}
    },
    {
      "rank": 6,
      "userId": "user_006",
      "name": "Ananya Gupta",
      "avatar":
          "https://images.pexels.com/photos/1036623/pexels-photo-1036623.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2380,
      "streak": 22,
      "tier": "Bronze",
      "location": "Kolkata",
      "center": "Aakash Institute",
      "isCurrentUser": false,
      "badges": ["Improving"],
      "subjectScores": {"Physics": 82, "Chemistry": 85, "Biology": 90}
    },
    {
      "rank": 7,
      "userId": "user_007",
      "name": "Karthik Nair",
      "avatar":
          "https://images.pexels.com/photos/1043471/pexels-photo-1043471.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2320,
      "streak": 19,
      "tier": "Bronze",
      "location": "Chennai",
      "center": "BYJU'S",
      "isCurrentUser": false,
      "badges": ["Newcomer"],
      "subjectScores": {"Physics": 80, "Chemistry": 83, "Biology": 86}
    },
    {
      "rank": 8,
      "userId": "user_008",
      "name": "Meera Joshi",
      "avatar":
          "https://images.pexels.com/photos/1181519/pexels-photo-1181519.jpeg?auto=compress&cs=tinysrgb&w=400",
      "points": 2250,
      "streak": 16,
      "tier": "Bronze",
      "location": "Pune",
      "center": "Allen Career Institute",
      "isCurrentUser": false,
      "badges": ["Steady Progress"],
      "subjectScores": {"Physics": 78, "Chemistry": 81, "Biology": 84}
    }
  ];

  final List<String> _tabLabels = ['Global', 'State', 'City', 'Center'];
  final List<String> _timePeriods = ['daily', 'weekly', 'monthly', 'all-time'];
  final List<String> _categories = [
    'overall',
    'physics',
    'chemistry',
    'biology'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabLabels.length, vsync: this);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _loadLeaderboardData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _animationController.dispose();
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadLeaderboardData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshLeaderboard() async {
    HapticFeedback.lightImpact();
    await _loadLeaderboardData();
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchQuery = '';
        _searchController.clear();
      }
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
    });
  }

  List<Map<String, dynamic>> _getFilteredData() {
    List<Map<String, dynamic>> filteredData = List.from(_leaderboardData);

    if (_searchQuery.isNotEmpty) {
      filteredData = filteredData.where((user) {
        final name = (user['name'] as String).toLowerCase();
        final center = (user['center'] as String).toLowerCase();
        final location = (user['location'] as String).toLowerCase();
        return name.contains(_searchQuery) ||
            center.contains(_searchQuery) ||
            location.contains(_searchQuery);
      }).toList();
    }

    return filteredData;
  }

  void _showUserProfile(Map<String, dynamic> userData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildUserProfileSheet(userData),
    );
  }

  Widget _buildUserProfileSheet(Map<String, dynamic> userData) {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 12.w,
            height: 0.5.h,
            margin: EdgeInsets.symmetric(vertical: 1.h),
            decoration: BoxDecoration(
              color: AppTheme.lightTheme.colorScheme.outline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(4.w),
              child: Column(
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.w),
                        child: CustomImageWidget(
                          imageUrl: userData['avatar'] as String,
                          width: 16.w,
                          height: 16.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              userData['name'] as String,
                              style: AppTheme.lightTheme.textTheme.titleLarge,
                            ),
                            Text(
                              'Rank #${userData['rank']}',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: AppTheme.lightTheme.colorScheme.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${userData['location']} • ${userData['center']}',
                              style: AppTheme.lightTheme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard('Points', '${userData['points']}',
                            AppTheme.lightTheme.colorScheme.primary),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildStatCard(
                            'Streak',
                            '${userData['streak']} days',
                            AppTheme.lightTheme.colorScheme.secondary),
                      ),
                      SizedBox(width: 2.w),
                      Expanded(
                        child: _buildStatCard(
                            'Tier',
                            userData['tier'] as String,
                            _getTierColor(userData['tier'] as String)),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Subject Performance',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  ..._buildSubjectScores(
                      userData['subjectScores'] as Map<String, dynamic>),
                  SizedBox(height: 3.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Achievements',
                      style: AppTheme.lightTheme.textTheme.titleMedium,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Wrap(
                    spacing: 2.w,
                    runSpacing: 1.h,
                    children: (userData['badges'] as List<String>)
                        .map(
                          (badge) => Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 3.w, vertical: 1.h),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              badge,
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: AppTheme
                                    .lightTheme.colorScheme.onPrimaryContainer,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            label,
            style: AppTheme.lightTheme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildSubjectScores(Map<String, dynamic> scores) {
    return scores.entries.map((entry) {
      final percentage = entry.value as int;
      return Padding(
        padding: EdgeInsets.only(bottom: 1.h),
        child: Row(
          children: [
            SizedBox(
              width: 20.w,
              child: Text(
                entry.key,
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            ),
            Expanded(
              child: LinearProgressIndicator(
                value: percentage / 100,
                backgroundColor: AppTheme.lightTheme.colorScheme.outline
                    .withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(
                  percentage >= 90
                      ? AppTheme.lightTheme.colorScheme.primary
                      : percentage >= 80
                          ? AppTheme.lightTheme.colorScheme.secondary
                          : AppTheme.lightTheme.colorScheme.tertiary,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Text(
              '$percentage%',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  Color _getTierColor(String tier) {
    switch (tier.toLowerCase()) {
      case 'diamond':
        return const Color(0xFF00BCD4);
      case 'gold':
        return const Color(0xFFFFD700);
      case 'silver':
        return const Color(0xFFC0C0C0);
      case 'bronze':
        return const Color(0xFFCD7F32);
      default:
        return AppTheme.lightTheme.colorScheme.outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredData = _getFilteredData();
    final currentUser = _leaderboardData.firstWhere(
      (user) => user['isCurrentUser'] == true,
      orElse: () => {},
    );

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: _isSearching
            ? null
            : Text(
                'Leaderboard',
                style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
        titleSpacing: _isSearching ? 0 : null,
        flexibleSpace: _isSearching
            ? Container(
                padding: EdgeInsets.fromLTRB(4.w, 6.h, 4.w, 1.h),
                child: UserSearchWidget(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  onClear: _toggleSearch,
                ),
              )
            : null,
        actions: [
          if (!_isSearching) ...[
            IconButton(
              onPressed: _toggleSearch,
              icon: CustomIconWidget(
                iconName: 'search',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
            IconButton(
              onPressed: () {
                // Share functionality
                HapticFeedback.lightImpact();
              },
              icon: CustomIconWidget(
                iconName: 'share',
                color: AppTheme.lightTheme.colorScheme.onSurface,
                size: 6.w,
              ),
            ),
          ],
        ],
        bottom: _isSearching
            ? null
            : PreferredSize(
                preferredSize: Size.fromHeight(12.h),
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TabBar(
                        controller: _tabController,
                        tabs: _tabLabels
                            .map((label) => Tab(text: label))
                            .toList(),
                        onTap: (index) {
                          setState(() {
                            _selectedFilterIndex = index;
                          });
                          _loadLeaderboardData();
                        },
                      ),
                    ),
                    SizedBox(height: 1.h),
                    LeaderboardFilterWidget(
                      selectedTimePeriod: _selectedTimePeriod,
                      selectedCategory: _selectedCategory,
                      timePeriods: _timePeriods,
                      categories: _categories,
                      onTimePeriodChanged: (value) {
                        setState(() {
                          _selectedTimePeriod = value;
                        });
                        _loadLeaderboardData();
                      },
                      onCategoryChanged: (value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                        _loadLeaderboardData();
                      },
                    ),
                  ],
                ),
              ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: AppTheme.lightTheme.colorScheme.primary,
              ),
            )
          : filteredData.isEmpty
              ? EmptyLeaderboardWidget(
                  onRefresh: _refreshLeaderboard,
                )
              : FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      if (currentUser.isNotEmpty && !_isSearching)
                        CurrentUserPositionWidget(
                          userData: currentUser,
                          onTap: () => _showUserProfile(currentUser),
                        ),
                      Expanded(
                        child: RefreshIndicator(
                          onRefresh: _refreshLeaderboard,
                          color: AppTheme.lightTheme.colorScheme.primary,
                          child: ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(
                                horizontal: 4.w, vertical: 2.h),
                            itemCount: filteredData.length,
                            itemBuilder: (context, index) {
                              final userData = filteredData[index];
                              return LeaderboardCardWidget(
                                userData: userData,
                                onTap: () => _showUserProfile(userData),
                                isCurrentUser:
                                    userData['isCurrentUser'] == true,
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 4,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushNamed(context, '/ai-chat-dashboard');
              break;
            case 1:
              Navigator.pushNamed(context, '/practice-questions');
              break;
            case 2:
              Navigator.pushNamed(context, '/flashcards-study');
              break;
            case 3:
              Navigator.pushNamed(context, '/mock-exam-interface');
              break;
            case 4:
              // Current screen
              break;
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'chat',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'chat',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 6.w,
            ),
            label: 'AI Chat',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'quiz',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'quiz',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 6.w,
            ),
            label: 'Practice',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'style',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'style',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 6.w,
            ),
            label: 'Flashcards',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'assignment',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.unselectedItemColor!,
              size: 6.w,
            ),
            activeIcon: CustomIconWidget(
              iconName: 'assignment',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 6.w,
            ),
            label: 'Mock Test',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'leaderboard',
              color: AppTheme
                  .lightTheme.bottomNavigationBarTheme.selectedItemColor!,
              size: 6.w,
            ),
            label: 'Leaderboard',
          ),
        ],
      ),
    );
  }
}
