import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A reusable list item widget for contacts/friends
class ContactListItem extends StatelessWidget {
  final String name;
  final String? subtitle;
  final String? avatarUrl;
  final Widget? avatar;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const ContactListItem({
    super.key,
    required this.name,
    this.subtitle,
    this.avatarUrl,
    this.avatar,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Padding(
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                // Avatar
                avatar ??
                    Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: avatarUrl != null && avatarUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Image.network(
                                avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildDefaultAvatar(),
                              ),
                            )
                          : _buildDefaultAvatar(),
                    ),
                12.horizontalSpace,
                // Name and subtitle
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontFamily: 'FilsonPro',
                          fontWeight: FontWeight.w600,
                          fontSize: 15.sp,
                          color: const Color(0xFF374151),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (subtitle != null) ...[
                        4.verticalSpace,
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontFamily: 'FilsonPro',
                            fontWeight: FontWeight.w400,
                            fontSize: 13.sp,
                            color: const Color(0xFF9CA3AF),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                // Trailing widget
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 80.w, right: 20.w),
            color: const Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w600,
          fontSize: 18.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}

/// A reusable list item for conversations/chats
class ConversationListItem extends StatelessWidget {
  final String name;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final String? avatarUrl;
  final Widget? avatar;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final bool isPinned;
  final bool isMuted;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;

  const ConversationListItem({
    super.key,
    required this.name,
    required this.lastMessage,
    required this.time,
    this.unreadCount = 0,
    this.avatarUrl,
    this.avatar,
    this.trailing,
    this.onTap,
    this.onLongPress,
    this.isPinned = false,
    this.isMuted = false,
    this.padding,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          child: Container(
            color: isPinned ? const Color(0xFFF9FAFB) : Colors.transparent,
            padding: padding ??
                EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              children: [
                // Avatar
                avatar ??
                    Container(
                      width: 52.w,
                      height: 52.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                      child: avatarUrl != null && avatarUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(14.r),
                              child: Image.network(
                                avatarUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) =>
                                    _buildDefaultAvatar(),
                              ),
                            )
                          : _buildDefaultAvatar(),
                    ),
                12.horizontalSpace,
                // Name, message and time
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: 'FilsonPro',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15.sp,
                                      color: const Color(0xFF374151),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (isMuted) ...[
                                  6.horizontalSpace,
                                  Icon(
                                    Icons.volume_off_rounded,
                                    size: 14.w,
                                    color: const Color(0xFF9CA3AF),
                                  ),
                                ],
                              ],
                            ),
                          ),
                          Text(
                            time,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontWeight: FontWeight.w400,
                              fontSize: 12.sp,
                              color: const Color(0xFF9CA3AF),
                            ),
                          ),
                        ],
                      ),
                      6.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              lastMessage,
                              style: TextStyle(
                                fontFamily: 'FilsonPro',
                                fontWeight: FontWeight.w400,
                                fontSize: 13.sp,
                                color: const Color(0xFF9CA3AF),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (trailing != null)
                            trailing!
                          else if (unreadCount > 0) ...[
                            8.horizontalSpace,
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF4444),
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              child: Text(
                                unreadCount > 99
                                    ? '99+'
                                    : unreadCount.toString(),
                                style: TextStyle(
                                  fontFamily: 'FilsonPro',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (showDivider)
          Container(
            height: 1,
            margin: EdgeInsets.only(left: 84.w, right: 20.w),
            color: const Color(0xFFF3F4F6),
          ),
      ],
    );
  }

  Widget _buildDefaultAvatar() {
    return Center(
      child: Text(
        name.isNotEmpty ? name[0].toUpperCase() : '?',
        style: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w600,
          fontSize: 20.sp,
          color: const Color(0xFF6B7280),
        ),
      ),
    );
  }
}
