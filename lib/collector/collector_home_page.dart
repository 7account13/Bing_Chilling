import 'package:flutter/material.dart';
import 'notification_page.dart';

class CollectorHomePage extends StatelessWidget {
  final List<Map<String, String>> notifications = [
    {"title": "Pickup Scheduled", "message": "Your pickup is confirmed for March 20th."},
    {"title": "Eco Points Earned", "message": "You've earned 50 Eco Points!"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.recycling, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Bing Chilling",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            _buildWelcomeSection(),
            _buildEwasteSection(),
            _buildNotificationSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.green.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 3,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.eco,
              size: 80,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 20),
          Text(
            "Welcome!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          Text(
            "Turn your e-waste into treasure",
            style: TextStyle(fontSize: 18, color: Colors.grey.shade800),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEwasteSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Domestic e-waste",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            "Individual customers can now easily schedule a pickup or drop-off and earn cash. Your journey to a greener planet starts here.",
            style: TextStyle(fontSize: 16, color: Colors.grey.shade800),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSection() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Notifications",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          SizedBox(height: 16),
          ...notifications.map((notification) => Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Text(notification['title']!,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(notification['message']!,
                  style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.notifications_active,
                  color: Colors.green.shade700),
            ),
          )),
        ],
      ),
    );
  }
}