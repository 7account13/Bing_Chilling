import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white), // Back icon with white color
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Notification", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green.shade700,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "There is no",
              style: TextStyle(fontSize: 24, color: Colors.grey.shade800),
            ),
            Text(
              "Notification",
              style: TextStyle(fontSize: 24, color: Colors.grey.shade800),
            ),
          ],
        ),
      ),
    );
  }
}