import 'package:flutter/material.dart';
import 'package:flutter_download_manager/flutter_download_manager.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class FileDownloadProgressView extends StatelessWidget {
  FileDownloadProgressView(this.message, {super.key});
  final Message message;
  final logic = Get.find<DownloadController>();

  @override
  Widget build(BuildContext context) {
    final url = message.fileElem?.sourceUrl;
    return Obx(() => SizedBox(
          width: 38.w,
          height: 44.h,
          child: message.isFileType && null != logic.downloadTaskList[url]
              ? ValueListenableBuilder(
                  valueListenable: logic.downloadTaskList[url]!.status,
                  builder: (_, status, child) {
                    return ValueListenableBuilder(
                      valueListenable: logic.downloadTaskList[url]!.progress,
                      builder: (_, progress, child) {
                        return (status == DownloadStatus.downloading ||
                                status == DownloadStatus.paused ||
                                status == DownloadStatus.queued)
                            ? Stack(
                                alignment: Alignment.center,
                                children: [
                                  Icon(Icons.file_present_rounded, size: 38.w),
                                  SizedBox(
                                    width: 22.w,
                                    height: 22.w,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          backgroundColor: Styles.c_FFFFFF,
                                          color: Styles.c_0089FF,
                                          strokeWidth: 1.5,
                                          value: progress,
                                        ),
                                        if (status ==
                                            DownloadStatus.downloading)
                                          Icon(Icons.pause,
                                              size: 16.w, color: Colors.white),
                                        if (status == DownloadStatus.paused)
                                          Icon(Icons.arrow_downward_outlined,
                                              size: 16.w, color: Colors.white),
                                      ],
                                    ),
                                  )
                                ],
                              )
                            : const SizedBox();
                      },
                    );
                  },
                )
              : null,
        ));
  }
}
