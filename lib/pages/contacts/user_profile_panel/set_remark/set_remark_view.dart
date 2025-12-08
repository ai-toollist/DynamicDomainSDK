// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/widgets/custom_buttom.dart';
import 'package:openim/widgets/gradient_scaffold.dart';
import 'package:openim_common/openim_common.dart';

import 'set_remark_logic.dart';
import '../../../../utils/character_length_limiting_formatter.dart';

class SetFriendRemarkPage extends StatefulWidget {
  const SetFriendRemarkPage({super.key});

  @override
  State<SetFriendRemarkPage> createState() => _SetFriendRemarkPageState();
}

class _SetFriendRemarkPageState extends State<SetFriendRemarkPage> {
  final logic = Get.find<SetFriendRemarkLogic>();
  int characterCount = 0;

  @override
  void initState() {
    super.initState();
    characterCount = logic.inputCtrl.text.characters.length;
    logic.inputCtrl.addListener(_updateCharacterCount);
  }

  @override
  void dispose() {
    logic.inputCtrl.removeListener(_updateCharacterCount);
    super.dispose();
  }

  void _updateCharacterCount() {
    setState(() {
      characterCount = logic.inputCtrl.text.characters.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return GradientScaffold(
      title: StrRes.remark,
      showBackButton: true,
      scrollable: false,
      trailing: CustomButton(
        onTap: logic.save,
        title: StrRes.save,
        colorButton: Colors.white.withOpacity(.3),
        colorIcon: Colors.white,   
          ),
        body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section title
            Text(
              StrRes.setRemarkName,
              style: TextStyle(
                fontFamily: 'FilsonPro',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF6B7280),
                letterSpacing: 0.3,
              ),
            ),
            16.verticalSpace,

            // Input field
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: primaryColor.withOpacity(0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: TextField(
                controller: logic.inputCtrl,
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1F2937),
                ),
                autofocus: true,
                inputFormatters: [
                  CharacterLengthLimitingFormatter(16)
                ],
                decoration: InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  hintText: StrRes.enterRemarkName,
                  hintStyle: TextStyle(
                    fontFamily: 'FilsonPro',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF9CA3AF),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 16.h,
                    horizontal: 20.w,
                  ),
                ),
              ),
            ),

            12.verticalSpace,

            // Character count display
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$characterCount/16",
                style: TextStyle(
                  fontFamily: 'FilsonPro',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
