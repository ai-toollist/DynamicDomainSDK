import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class ForgetPasswordTextButton extends StatelessWidget {
  final ValueChanged<bool> onRememberChanged;
  final bool remember;

  const ForgetPasswordTextButton(
      {super.key, required this.onRememberChanged, required this.remember});

  void _toggleRemember([bool? value]) {
    onRememberChanged.call(value ?? !remember);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: _toggleRemember,
            behavior: HitTestBehavior.opaque,
            child: Row(
              children: [
                Checkbox(
                  value: remember,
                  onChanged: _toggleRemember,
                  fillColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.blue;
                      }
                      return Colors.transparent;
                    },
                  ),
                  checkColor: Colors.white,
                  side: const BorderSide(
                    color: Color(0xFFE5E7EB),
                    width: 1.5,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Text(
                  StrRes.rememberPassword,
                  style: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF6B7280), // 一般灰（tailwind slate-500）
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => AppNavigator.startResetPassword(),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 8.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: Colors.transparent,
              overlayColor: MaterialStateColor.resolveWith(
                (states) => const Color(0xFF60A5FA).withOpacity(0.05),
              ),
            ),
            child: Text(
              StrRes.forgotPasswordQuestion,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF60A5FA),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
