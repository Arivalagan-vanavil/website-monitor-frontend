import 'dart:async';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:web_monitor/website.dart';
import 'package:web_monitor/websiteDetailsPage.dart';
import 'package:web_monitor/website_list.dart';




class WebsiteMonitor extends StatefulWidget {
  @override
  _WebsiteMonitorState createState() => _WebsiteMonitorState();
}

class _WebsiteMonitorState extends State<WebsiteMonitor> {


  Website? selectedWebsite;


  void _showWebsiteDetailsPage(BuildContext context, Website website) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WebsiteDetailsPage(website: website)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Website Monitor')),
      ),
      body: GridView.builder(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.only(left: 10.0,right: 10.0,top: 15.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,

        ),
        itemCount: websites.length,
        itemBuilder: (context, index) {
          final website = websites[index];
          return Card(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedWebsite = website;
                });
                _showWebsiteDetailsPage(context, website);
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(website.assetImagePath), // Display asset image for each website
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}