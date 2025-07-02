import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LeaderboardCardWidget extends StatelessWidget {
  final Map<String, dynamic> userData;
  final VoidCallback onTap;
  final bool isCurrentUser;

  const LeaderboardCardWidget({
    super.key,
    required this.userData,
    required this.onTap,
    this.isCurrentUser = false,
  });

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

  Widget _buildRankBadge(int rank) {
    Color badgeColor;
    Widget? icon;

    if (rank == 1) {
      badgeColor = const Color(0xFFFFD700);
      icon = CustomIconWidget(
        iconName: 'emoji_events',
        color: Colors.white,
        size: 4.w,
      );
    } else if (rank == 2) {
      badgeColor = const Color(0xFFC0C0C0);
      icon = CustomIconWidget(
        iconName: 'emoji_events',
        color: Colors.white,
        size: 4.w,
      );
    } else if (rank == 3) {
      badgeColor = const Color(0xFFCD7F32);
      icon = CustomIconWidget(
        iconName: 'emoji_events',
        color: Colors.white,
        size: 4.w,
      );
    } else {
      badgeColor = AppTheme.lightTheme.colorScheme.primary;
    }

    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: badgeColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: badgeColor.withValues(alpha: 0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: icon ??
            Text(
              '$rank',
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
      ),
    );
  }

  Widget _buildTierBadge(String tier) {
    final tierColor = _getTierColor(tier);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 0.5.h),
      decoration: BoxDecoration(
        color: tierColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tierColor, width: 1),
      ),
      child: Text(
        tier,
        style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
          color: tierColor,
          fontWeight: FontWeight.w600,
          fontSize: 10.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rank = userData['rank'] as int;
    final name = userData['name'] as String;
    final avatar = userData['avatar'] as String;
    final points = userData['points'] as int;
    final streak = userData['streak'] as int;
    final tier = userData['tier'] as String;
    final location = userData['location'] as String;
    final center = userData['center'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            HapticFeedback.lightImpact();
            onTap();
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? AppTheme.lightTheme.colorScheme.primaryContainer
                      .withValues(alpha: 0.3)
                  : AppTheme.lightTheme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: isCurrentUser
                  ? Border.all(
                      color: AppTheme.lightTheme.colorScheme.primary,
                      width: 2,
                    )
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.lightTheme.colorScheme.shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                _buildRankBadge(rank),
                SizedBox(width: 4.w),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: CustomImageWidget(
                        imageUrl: avatar,
                        width: 12.w,
                        height: 12.w,
                        fit: BoxFit.cover,
                      ),
                    ),
                    if (isCurrentUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 4.w,
                          height: 4.w,
                          decoration: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.lightTheme.colorScheme.surface,
                              width: 1,
                            ),
                          ),
                          child: CustomIconWidget(
                            iconName: 'person',
                            color: Colors.white,
                            size: 2.w,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: AppTheme.lightTheme.textTheme.titleMedium
                                  ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isCurrentUser
                                    ? AppTheme.lightTheme.colorScheme.primary
                                    : null,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          _buildTierBadge(tier),
                        ],
                      ),
                      SizedBox(height: 0.5.h),
                      Text(
                        '$location • $center',
                        style:
                            AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 1.h),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'stars',
                                  color:
                                      AppTheme.lightTheme.colorScheme.primary,
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$points',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color:
                                        AppTheme.lightTheme.colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 2.w),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 2.w, vertical: 0.5.h),
                            decoration: BoxDecoration(
                              color: AppTheme
                                  .lightTheme.colorScheme.secondaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CustomIconWidget(
                                  iconName: 'local_fire_department',
                                  color:
                                      AppTheme.lightTheme.colorScheme.secondary,
                                  size: 3.w,
                                ),
                                SizedBox(width: 1.w),
                                Text(
                                  '$streak',
                                  style: AppTheme.lightTheme.textTheme.bodySmall
                                      ?.copyWith(
                                    color: AppTheme
                                        .lightTheme.colorScheme.secondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 2.w),
                CustomIconWidget(
                  iconName: 'chevron_right',
                  color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  size: 5.w,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
