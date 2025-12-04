import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Custom styled TabBar matching the unified design style
class StyledTabBar extends StatelessWidget {
  final TabController controller;
  final List<String> tabs;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Color indicatorColor;

  const StyledTabBar({
    super.key,
    required this.controller,
    required this.tabs,
    this.padding,
    this.isScrollable = false,
    this.selectedLabelColor = const Color(0xFF2563EB),
    this.unselectedLabelColor = const Color(0xFF6B7280),
    this.indicatorColor = const Color(0xFF2563EB),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        labelColor: selectedLabelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
        indicatorColor: indicatorColor,
        indicatorWeight: 3.h,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: tabs.map((text) => Tab(text: text)).toList(),
      ),
    );
  }
}

/// Tab with count badge
class TabWithCount {
  final String label;
  final int count;

  TabWithCount({required this.label, this.count = 0});
}

/// Custom styled TabBar with count badges
class StyledTabBarWithCount extends StatelessWidget {
  final TabController controller;
  final List<TabWithCount> tabs;
  final EdgeInsetsGeometry? padding;
  final bool isScrollable;
  final Color selectedLabelColor;
  final Color unselectedLabelColor;
  final Color indicatorColor;
  final Color badgeColor;

  const StyledTabBarWithCount({
    super.key,
    required this.controller,
    required this.tabs,
    this.padding,
    this.isScrollable = true,
    this.selectedLabelColor = const Color(0xFF2563EB),
    this.unselectedLabelColor = const Color(0xFF6B7280),
    this.indicatorColor = const Color(0xFF2563EB),
    this.badgeColor = const Color(0xFFEF4444),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      child: TabBar(
        controller: controller,
        isScrollable: isScrollable,
        labelColor: selectedLabelColor,
        unselectedLabelColor: unselectedLabelColor,
        labelStyle: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w600,
          fontSize: 14.sp,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'FilsonPro',
          fontWeight: FontWeight.w500,
          fontSize: 14.sp,
        ),
        indicatorColor: indicatorColor,
        indicatorWeight: 3.h,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        tabs: tabs.map((tab) {
          return Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(tab.label),
                if (tab.count > 0) ...[
                  4.horizontalSpace,
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      tab.count > 99 ? '99+' : tab.count.toString(),
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
          );
        }).toList(),
      ),
    );
  }
}
