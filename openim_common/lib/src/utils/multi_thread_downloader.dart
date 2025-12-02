import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../openim_common.dart';

class MultiThreadDownloader {
  final Dio dio = Dio();
  final String url;
  final int threads; // Number of threads
  final String fileName;

  MultiThreadDownloader({required this.url, this.threads = 4, required this.fileName}) {
    _lastReceived = List<int>.filled(threads, 0); // Initialize list for tracking progress
  }

  double _downloadedBytes = 0; // Total bytes downloaded
  String? _realUrl;
  ValueChanged? _onProgress;
  late int _fileSize; // Total file size

  List<int> _lastReceived = []; // Store last received bytes for each thread

  Future<String?> start({ValueChanged? onProgress}) async {
    _onProgress = onProgress;
    try {
      // Step 1: Get the file size after handling redirection
      _fileSize = await _getFileSize() ?? 0;
      if (_fileSize == 0) {
        Logger.print('Unable to retrieve file size, trying single thread download');
        return await _fallbackDownload();
      }
      Logger.print('File size: $_fileSize bytes');

      // Step 2: Create local file path
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      // Check if file already exists
      if (File(filePath).existsSync()) {
        Logger.print('File already exists: $filePath');
        return filePath;
      }

      // Step 3: Calculate the byte range for each thread
      final chunkSize = (_fileSize / threads).ceil(); // Size of each chunk

      List<Future<File>> futures = [];

      // Step 4: Download chunks concurrently
      for (int i = 0; i < threads; i++) {
        final start = i * chunkSize;
        final end = (i == threads - 1) ? _fileSize - 1 : (start + chunkSize - 1);

        futures.add(_downloadChunk(start, end, i, filePath));
      }

      // Wait for all threads to finish downloading
      await Future.wait(futures);

      Logger.print('All chunks downloaded, file path: $filePath');
      final path = await mergeChunks(filePath); // Merge chunks into a single file

      return path;
    } catch (e) {
      Logger.print('Multi-thread download failed: $e, trying fallback');
      return await _fallbackDownload();
    }
  }

  // Fallback to single thread download when multi-thread fails
  Future<String?> _fallbackDownload() async {
    try {
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String filePath = '${appDocDir.path}/$fileName';

      // Check if file already exists
      if (File(filePath).existsSync()) {
        Logger.print('File already exists: $filePath');
        return filePath;
      }

      Logger.print('Starting fallback single-thread download');
      await dio.download(
        url,
        filePath,
        onReceiveProgress: (received, total) {
          if (total > 0) {
            final progress = received / total;
            Logger.print('Fallback download progress: ${(progress * 100).toStringAsFixed(2)}%');
            _onProgress?.call(progress);
          }
        },
      );

      Logger.print('Fallback download completed: $filePath');
      return filePath;
    } catch (e) {
      Logger.print('Fallback download failed: $e');
      return null;
    }
  }

  // Get the file size, including handling redirection
  Future<int?> _getFileSize() async {
    try {
      _realUrl = await fetchRedirectedUrl(url: url);

      final response = await dio.head(
        _realUrl!,
      );

      // Get file size from headers
      final contentLength = response.headers.value(Headers.contentLengthHeader);
      return contentLength != null ? int.tryParse(contentLength) : null;
    } catch (e) {
      Logger.print('Failed to get file size: $e');
      return null;
    }
  }

  // Download a chunk of the file
  Future<File> _downloadChunk(int start, int end, int threadIndex, String filePath) async {
    // Create a temporary file to store the chunk
    String tempFilePath = '$filePath.part$threadIndex';

    Logger.print('Thread $threadIndex downloading range: $start-$end');

    // Make a request with Range header to download the specific byte range
    try {
      final response = await dio.download(
        _realUrl!,
        tempFilePath,
        options: Options(
          headers: {
            'Range': 'bytes=$start-$end',
          },
        ),
        onReceiveProgress: (received, total) {
          final p = received / total.toDouble();
          Logger.print(
              'Thread $threadIndex download progress: ${(p * 100).toStringAsFixed(2)}%, received: $received, total: $total');
          _updateProgress(received, threadIndex);
        },
      );
      Logger.print('Thread $threadIndex download completed: ${response.statusCode}');
      return File(tempFilePath);
    } catch (e) {
      Logger.print('Thread $threadIndex download failed: $e');
      rethrow;
    }
  }

  // Update overall download progress
  void _updateProgress(int receivedBytes, int threadIndex) {
    int newBytes = receivedBytes - _lastReceived[threadIndex];
    _lastReceived[threadIndex] = receivedBytes;

    // Accumulate the number of bytes received
    _downloadedBytes += newBytes;

    // Calculate overall progress percentage and clamp to [0.0, 1.0]
    double progress = (_downloadedBytes / _fileSize).clamp(0.0, 1.0);

    // Print or display download progress
    Logger.print(
      'Total download progress: ${(progress * 100).toStringAsFixed(2)}%, received: $_downloadedBytes / $_fileSize',
    );

    _onProgress?.call(progress);
  }

  // Merge chunks into a single file
  Future<String> mergeChunks(String filePath) async {
    // Open target file for merging
    File file = File(filePath);
    IOSink fileSink = file.openWrite();

    try {
      // Read each chunk file and write to the target file
      for (int i = 0; i < threads; i++) {
        File chunkFile = File('$filePath.part$i');
        List<int> chunkBytes = await chunkFile.readAsBytes();
        fileSink.add(chunkBytes);
        await chunkFile.delete(); // Delete temporary chunk file after merging
      }
    } finally {
      await fileSink.close();
    }

    Logger.print('File merge completed: $filePath');
    return filePath;
  }

  Future<String> fetchRedirectedUrl({required String url}) async {
    try {
      final myRequest = await HttpClient().getUrl(Uri.parse(url));
      myRequest.followRedirects = false;
      final myResponse = await myRequest.close();
      final location = myResponse.headers.value(HttpHeaders.locationHeader);
      return location ?? url; // Return original URL if no redirect
    } catch (e) {
      Logger.print('Failed to fetch redirected URL: $e');
      return url; // Return original URL on error
    }
  }
}
