import 'package:flutter/material.dart';
import 'notification_page.dart';
import 'collector_product_page.dart';
import 'sell_scrap_page.dart';
import '/common/login_page.dart'; // Ensure you have a login page

class CollectorHomePage extends StatefulWidget {
  @override
  _CollectorHomePageState createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends State<CollectorHomePage> {
  // Logout function without SharedPreferences
  void logout() {
    // Navigate to Login Page and clear all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false, // Removes all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: logout, // Call logout function
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 40),
            _buildWelcomeSection(),
            _buildActionButtons(context),
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

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildElevatedButton("Sell a By-Product", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CollectorProductPage()),
                );
              }),
              _buildElevatedButton("Pickups", () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationPage()),
                );
              }),
            ],
          ),
          SizedBox(height: 16),
          _buildElevatedButton("Sell Scrap", () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SellScrapPage()),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildElevatedButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green.shade700,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}
