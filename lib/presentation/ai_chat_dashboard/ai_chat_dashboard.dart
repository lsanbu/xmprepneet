
import '../../core/app_export.dart';
import './widgets/chat_header_widget.dart';
import './widgets/chat_message_widget.dart';
import './widgets/message_input_widget.dart';
import './widgets/typing_indicator_widget.dart';

class AiChatDashboard extends StatefulWidget {
  const AiChatDashboard({super.key});

  @override
  State<AiChatDashboard> createState() => _AiChatDashboardState();
}

class _AiChatDashboardState extends State<AiChatDashboard>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _messageController = TextEditingController();
  bool _isTyping = false;
  String _currentSubject = "Biology";

  // Mock conversation data
  final List<Map<String, dynamic>> _messages = [
    {
      "id": 1,
      "isUser": false,
      "message":
          "Hello! I'm your AI study assistant for NEET preparation. How can I help you today?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 30)),
      "avatar":
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=face",
      "isBookmarked": false,
    },
    {
      "id": 2,
      "isUser": true,
      "message": "Can you explain the process of photosynthesis in detail?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 25)),
      "isBookmarked": false,
    },
    {
      "id": 3,
      "isUser": false,
      "message":
          "Photosynthesis is the process by which plants convert light energy into chemical energy. It occurs in two main stages:\n\n1. **Light Reactions** (in thylakoids)\n2. **Calvin Cycle** (in stroma)\n\nThe overall equation is:\n6CO₂ + 6H₂O + light energy → C₆H₁₂O₆ + 6O₂",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 24)),
      "avatar":
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=face",
      "isBookmarked": true,
    },
    {
      "id": 4,
      "isUser": true,
      "message": "What are the factors affecting the rate of photosynthesis?",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 20)),
      "isBookmarked": false,
    },
    {
      "id": 5,
      "isUser": false,
      "message":
          "The main factors affecting photosynthesis rate are:\n\n• **Light intensity** - Higher intensity increases rate up to saturation point\n• **CO₂ concentration** - More CO₂ increases rate until other factors limit\n• **Temperature** - Optimal range 25-35°C for most plants\n• **Water availability** - Essential for light reactions\n• **Chlorophyll content** - More chlorophyll = better light absorption",
      "timestamp": DateTime.now().subtract(const Duration(minutes: 19)),
      "avatar":
          "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=face",
      "isBookmarked": false,
    },
  ];

  final List<String> _quickSuggestions = [
    "Explain cell division",
    "Human circulatory system",
    "Genetics and heredity",
    "Plant reproduction",
    "Ecology concepts",
    "Chemical bonding",
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final userMessage = {
      "id": _messages.length + 1,
      "isUser": true,
      "message": _messageController.text.trim(),
      "timestamp": DateTime.now(),
      "isBookmarked": false,
    };

    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate AI response
    Future.delayed(const Duration(seconds: 2), () {
      final aiResponse = {
        "id": _messages.length + 1,
        "isUser": false,
        "message":
            "That's a great question! Let me provide you with a detailed explanation...",
        "timestamp": DateTime.now(),
        "avatar":
            "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=face",
        "isBookmarked": false,
      };

      setState(() {
        _messages.add(aiResponse);
        _isTyping = false;
      });
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _onMessageLongPress(Map<String, dynamic> message) {
    if (message["isUser"] == true) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
            _buildActionTile(
              icon: 'bookmark',
              title: message["isBookmarked"] == true
                  ? "Remove Bookmark"
                  : "Bookmark",
              onTap: () {
                setState(() {
                  message["isBookmarked"] = !(message["isBookmarked"] ?? false);
                });
                Navigator.pop(context);
              },
            ),
            _buildActionTile(
              icon: 'share',
              title: "Share",
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              icon: 'content_copy',
              title: "Copy Text",
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              icon: 'quiz',
              title: "Save to Flashcards",
              onTap: () => Navigator.pop(context),
            ),
            _buildActionTile(
              icon: 'report',
              title: "Report Issue",
              onTap: () => Navigator.pop(context),
              isDestructive: true,
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildActionTile({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.lightTheme.colorScheme.error
            : AppTheme.lightTheme.colorScheme.onSurface,
        size: 24,
      ),
      title: Text(
        title,
        style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
          color: isDestructive
              ? AppTheme.lightTheme.colorScheme.error
              : AppTheme.lightTheme.colorScheme.onSurface,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  void _onSuggestionTap(String suggestion) {
    _messageController.text = suggestion;
    _sendMessage();
  }

  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    // Simulate loading previous conversations
  }

  void _showNewChatOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.lightTheme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
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
            Text(
              "Start New Chat",
              style: AppTheme.lightTheme.textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            _buildSubjectTile("Biology", "cell_biology"),
            _buildSubjectTile("Chemistry", "science"),
            _buildSubjectTile("Physics", "physics"),
            _buildSubjectTile("General Knowledge", "psychology"),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectTile(String subject, String iconName) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: iconName,
        color: AppTheme.lightTheme.colorScheme.primary,
        size: 24,
      ),
      title: Text(
        subject,
        style: AppTheme.lightTheme.textTheme.bodyLarge,
      ),
      trailing: CustomIconWidget(
        iconName: 'arrow_forward_ios',
        color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: () {
        setState(() {
          _currentSubject = subject;
          _messages.clear();
          _messages.add({
            "id": 1,
            "isUser": false,
            "message":
                "Hello! I'm ready to help you with $subject. What would you like to learn today?",
            "timestamp": DateTime.now(),
            "avatar":
                "https://images.unsplash.com/photo-1677442136019-21780ecad995?w=100&h=100&fit=crop&crop=face",
            "isBookmarked": false,
          });
        });
        Navigator.pop(context);
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Tab Bar
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
              ),
              child: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: "Chat"),
                  Tab(text: "Practice"),
                  Tab(text: "Flashcards"),
                  Tab(text: "Leaderboard"),
                  Tab(text: "Profile"),
                ],
                onTap: (index) {
                  switch (index) {
                    case 1:
                      Navigator.pushNamed(context, '/practice-questions');
                      break;
                    case 2:
                      Navigator.pushNamed(context, '/flashcards-study');
                      break;
                    case 3:
                      Navigator.pushNamed(context, '/leaderboard-rankings');
                      break;
                    case 4:
                      Navigator.pushNamed(context, '/mock-exam-interface');
                      break;
                  }
                },
              ),
            ),

            // Chat Header
            ChatHeaderWidget(
              currentSubject: _currentSubject,
              onSettingsTap: () {},
            ),

            // Chat Messages
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppTheme.lightTheme.colorScheme.primary,
                child: ListView.builder(
                  controller: _scrollController,
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  itemCount: _messages.length + (_isTyping ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _messages.length && _isTyping) {
                      return const TypingIndicatorWidget();
                    }

                    final message = _messages[index];
                    return GestureDetector(
                      onLongPress: () => _onMessageLongPress(message),
                      child: ChatMessageWidget(
                        message: message,
                        onBookmarkTap: () {
                          setState(() {
                            message["isBookmarked"] =
                                !(message["isBookmarked"] ?? false);
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),

            // Quick Suggestions
            if (_quickSuggestions.isNotEmpty)
              Container(
                height: 6.h,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _quickSuggestions.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(right: 2.w),
                      child: ActionChip(
                        label: Text(
                          _quickSuggestions[index],
                          style: AppTheme.lightTheme.textTheme.bodySmall,
                        ),
                        onPressed: () =>
                            _onSuggestionTap(_quickSuggestions[index]),
                        backgroundColor: AppTheme
                            .lightTheme.colorScheme.primaryContainer
                            .withValues(alpha: 0.1),
                        side: BorderSide(
                          color: AppTheme.lightTheme.colorScheme.primary
                              .withValues(alpha: 0.3),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Message Input
            MessageInputWidget(
              controller: _messageController,
              onSend: _sendMessage,
              onAttachment: () {},
              onVoiceInput: () {},
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showNewChatOptions,
        backgroundColor: AppTheme.lightTheme.colorScheme.secondary,
        child: CustomIconWidget(
          iconName: 'add',
          color: AppTheme.lightTheme.colorScheme.onSecondary,
          size: 24,
        ),
      ),
    );
  }
}
