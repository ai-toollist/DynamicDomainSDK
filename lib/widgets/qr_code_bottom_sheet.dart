// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:ionicons/ionicons.dart';
import 'package:openim/widgets/custom_buttom.dart';
import 'package:openim_common/openim_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeBottomSheet extends StatefulWidget {
  final String title;
  final String name;
  final String? avatarUrl;
  final String qrData;
  final bool isGroup;
  final int? memberCount;
  final String? description;
  final String? hintText;

  const QRCodeBottomSheet({
    super.key,
    this.title = 'QR Code',
    required this.name,
    this.avatarUrl,
    required this.qrData,
    this.isGroup = false,
    this.memberCount,
    this.description,
    this.hintText,
  });

  @override
  State<QRCodeBottomSheet> createState() => _QRCodeBottomSheetState();
}

class _QRCodeBottomSheetState extends State<QRCodeBottomSheet> {
  final GlobalKey _qrKey = GlobalKey();
  bool _isSaving = false;

  Future<void> _saveQRCode() async {
    if (_isSaving) return;
    
    setState(() => _isSaving = true);
    
    try {
      // Request permission
      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) {
          final photosStatus = await Permission.photos.request();
          if (!photosStatus.isGranted) {
            IMViews.showToast(StrRes.permissionDenied);
            return;
          }
        }
      }

      // Capture QR widget as image
      final boundary = _qrKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;
      if (boundary == null) {
        IMViews.showToast(StrRes.saveFailed);
        return;
      }

      final image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      
      if (byteData == null) {
        IMViews.showToast(StrRes.saveFailed);
        return;
      }

      final pngBytes = byteData.buffer.asUint8List();
      
      // Save to gallery
      final result = await ImageGallerySaverPlus.saveImage(
        pngBytes,
        quality: 100,
        name: 'qr_${widget.name}_${DateTime.now().millisecondsSinceEpoch}',
      );

      if (result['isSuccess'] == true) {
        IMViews.showToast(StrRes.saveSuccessfully);
      } else {
        IMViews.showToast(StrRes.saveFailed);
      }
    } catch (e) {
      Logger.print('Save QR code error: $e');
      IMViews.showToast(StrRes.saveFailed);
    } finally {
      setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: BackdropFilter(
            filter: ui.ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32.r),
              topRight: Radius.circular(32.r),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF9CA3AF).withOpacity(0.08),
                offset: const Offset(0, -3),
                blurRadius: 12,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // QR Code Section - wrapped with RepaintBoundary for capture
              RepaintBoundary(
                key: _qrKey,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF9CA3AF).withOpacity(0.06),
                        offset: const Offset(0, 2),
                        blurRadius: 6.r,
                      ),
                    ],
                    border: Border.all(
                      color: const Color(0xFFF3F4F6),
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.w),
                    child: Column(
                      children: [
                        // Avatar and Name
                        Row(
                          children: [
                            AvatarView(
                              isGroup: widget.isGroup,
                              url: widget.avatarUrl,
                              text: widget.name,
                              width: 50.w,
                              height: 50.h,
                              textStyle: TextStyle(
                                fontFamily: 'FilsonPro',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              isCircle: true,
                            ),
                            12.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(
                                      fontFamily: 'FilsonPro',
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF374151),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  if (widget.memberCount != null) ...[
                                    4.verticalSpace,
                                    Text(
                                      '${widget.memberCount} ${StrRes.members}',
                                      style: TextStyle(
                                        fontFamily: 'FilsonPro',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF6B7280),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            CustomButton(
                              icon: Ionicons.download_outline,
                              onTap: _isSaving ? null : _saveQRCode,
                              color: Theme.of(context).primaryColor,
                            )
                          ],
                        ),
                        20.verticalSpace,
                        // QR Description
                        if (widget.description != null) ...[
                          Text(
                            widget.description!,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF374151),
                            ),
                          ),
                          16.verticalSpace,
                        ],
                        // QR Code
                        Center(
                          child: Container(
                            width: 180.w,
                            height: 180.w,
                            padding: EdgeInsets.all(16.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  offset: const Offset(1, 1),
                                  blurRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.white.withOpacity(0.9),
                                  offset: const Offset(-0.5, -0.5),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: QrImageView(
                              data: widget.qrData,
                              size: 150.w,
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                        if (widget.hintText != null) ...[
                          16.verticalSpace,
                          Text(
                            widget.hintText!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'FilsonPro',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: 30.h),
            ],
          ),
        ),
      ],
    );
  }
}
