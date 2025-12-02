import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: Image.asset(
            "assets/images/app-icon.png",
            width: 100.w,
          ),
        ),
      ),
    );
  }
}
