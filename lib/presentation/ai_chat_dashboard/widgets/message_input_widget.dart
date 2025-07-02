
import '../../../core/app_export.dart';

class MessageInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final VoidCallback onAttachment;
  final VoidCallback onVoiceInput;

  const MessageInputWidget({
    super.key,
    required this.controller,
    required this.onSend,
    required this.onAttachment,
    required this.onVoiceInput,
  });

  @override
  State<MessageInputWidget> createState() => _MessageInputWidgetState();
}

class _MessageInputWidgetState extends State<MessageInputWidget> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    final hasText = widget.controller.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() {
        _hasText = hasText;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: AppTheme.lightTheme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color:
                AppTheme.lightTheme.colorScheme.outline.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppTheme.lightTheme.colorScheme.shadow.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Attachment Button
            Container(
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                onPressed: widget.onAttachment,
                icon: CustomIconWidget(
                  iconName: 'attach_file',
                  color: AppTheme.lightTheme.colorScheme.primary,
                  size: 20,
                ),
                padding: EdgeInsets.all(2.w),
                constraints: BoxConstraints(
                  minWidth: 10.w,
                  minHeight: 5.h,
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Text Input Field
            Expanded(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: 5.h,
                  maxHeight: 15.h,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.lightTheme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppTheme.lightTheme.colorScheme.outline
                        .withValues(alpha: 0.3),
                  ),
                ),
                child: TextField(
                  controller: widget.controller,
                  maxLines: null,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: "Ask me anything about NEET...",
                    hintStyle:
                        AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 1.5.h,
                    ),
                  ),
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  onSubmitted: (_) {
                    if (_hasText) {
                      widget.onSend();
                    }
                  },
                ),
              ),
            ),

            SizedBox(width: 2.w),

            // Voice Input / Send Button
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _hasText
                  ? Container(
                      key: const ValueKey('send'),
                      decoration: BoxDecoration(
                        color: AppTheme.lightTheme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onSend,
                        icon: CustomIconWidget(
                          iconName: 'send',
                          color: AppTheme.lightTheme.colorScheme.onPrimary,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(2.w),
                        constraints: BoxConstraints(
                          minWidth: 10.w,
                          minHeight: 5.h,
                        ),
                      ),
                    )
                  : Container(
                      key: const ValueKey('voice'),
                      decoration: BoxDecoration(
                        color: AppTheme
                            .lightTheme.colorScheme.secondaryContainer
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: IconButton(
                        onPressed: widget.onVoiceInput,
                        icon: CustomIconWidget(
                          iconName: 'mic',
                          color: AppTheme.lightTheme.colorScheme.secondary,
                          size: 20,
                        ),
                        padding: EdgeInsets.all(2.w),
                        constraints: BoxConstraints(
                          minWidth: 10.w,
                          minHeight: 5.h,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
