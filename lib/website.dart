import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Website {
  final String id;
  final String url;
  final String assetImagePath;
  bool isOnline;
  IconData? iconData;
  DateTime lastStatusChange = DateTime.now();
  int httpStatusCode;
  Duration responseTime;

  Website({
    required this.id,
    required this.url,
    required this.assetImagePath,
    this.isOnline = false,
    required this.httpStatusCode,
    required this.responseTime,
  }) {
    iconData = isOnline ? Icons.check : Icons.close;
  }

  String getUptime() {
    if (isOnline) {
      final duration = DateTime.now().difference(lastStatusChange);
      return '${duration.inMinutes} minute(s)';
    } else {
      return 'N/A';
    }
  }

  String getDowntime() {
    if (!isOnline) {
      final duration = DateTime.now().difference(lastStatusChange);
      return '${duration.inMinutes} minute(s)';
    } else {
      return 'N/A';
    }
  }

  String getHttpStatusCode() {
    return httpStatusCode.toString();
  }

  String getResponseTime() {
    final String responseTimeString = responseTime.inMilliseconds.toString();
    final int indexOfDot = responseTimeString.indexOf('.');
    final int milliseconds = int.parse(responseTimeString.substring(indexOfDot + 1));
    return '${responseTime.inSeconds}s ${milliseconds}ms';
  }
}

void startMonitoring(Website website, Function(Website) callback) {
  debugPrint('startMonitoring:$startMonitoring');
  Timer.periodic(Duration(seconds: 30), (_) {
    debugPrint('Timer:$Timer');

      checkWebsiteStatus(website).then((status) {
        callback(website);
      });

  });
}


Future<void> checkWebsiteStatus(Website website) async {
  try {
    final stopwatch = Stopwatch()..start();
    final response = await http.get(Uri.parse(website.url));
    stopwatch.stop();
    website.httpStatusCode = response.statusCode;
    website.responseTime = stopwatch.elapsed;
    website.isOnline = response.statusCode == 200;
  } catch (e) {
    log('Error fetching ${website.url}: $e');
    website.isOnline = false;
  }
}