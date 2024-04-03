import 'dart:async';
import 'dart:core';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mongo_dart/mongo_dart.dart' as mongo;
import 'package:web_monitor/website.dart';

class WebsiteDetailsPage extends StatefulWidget {
  final Website website;

  const WebsiteDetailsPage({super.key, required this.website});

  @override
  State<WebsiteDetailsPage> createState() => _WebsiteDetailsPageState();
}

class _WebsiteDetailsPageState extends State<WebsiteDetailsPage> {
   late Timer timer;

  @override
  void initState() {
    super.initState();
    startMonitoring(widget.website, (website) {
      setState(() {
        website.iconData = website.isOnline ? Icons.check : Icons.close;
      });
    });
    timer = Timer.periodic(const Duration(seconds: 30), (timer) async {
      await sendDataToServer(widget.website);
    });


    // Call sendDataToServer when the page is initialized
    sendDataToServer(widget.website);
  }


  @override
  Widget build(BuildContext context) {
    IconData iconData = widget.website.iconData ?? Icons.close; // Use null check operator
    Color iconColor = widget.website.isOnline ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Website Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(widget.website.assetImagePath),
            Row(
              children: [
                Icon(iconData, color: iconColor, size: 50.0),
                const SizedBox(width: 10.0),
                Text(
                  widget.website.url,
                  style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Response Time:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.website.getResponseTime()),
            const SizedBox(height: 20),
            const Text(
              'Uptime:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.website.getUptime()),
            const SizedBox(height: 20),
            const Text(
              'Downtime:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.website.getDowntime()),
            const SizedBox(height: 20),
            const Text(
              'HTTP Status Code:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(widget.website.getHttpStatusCode()),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }


   Future<void> sendDataToServer(Website website) async {
     try {
       // Define the URL of the backend API endpoint
       const url = 'http://192.168.29.115:4000/websites';

       // Create a Dio instance
       final dio = Dio();

       final jsonData = {
         'url': website.url,
         'isOnline': website.isOnline,
         'httpStatusCode': website.httpStatusCode,
         'responseTime': website.responseTime.inMilliseconds,
       };


       final response = await dio.post(
         url,
         data: jsonData,
         options: Options(
           contentType: Headers.jsonContentType,
         ),
       );

       debugPrint("response $response");
       // Check if the request was successful
       if (response.statusCode == 200) {
         print('Data sent successfully');
       } else {
         print('Failed to send data: ${response.statusCode}');
       }
     } catch (error) {
       print('Error sending data: $error');
     }
   }
}
