import 'package:flutter/material.dart';
import 'notification_list_page.dart';

class RecyclerHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
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
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.white),
            onPressed: () {
              // Navigate to the notification page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotificationListPage()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated icon
            AnimatedContainer(
              duration: Duration(seconds: 2),
              curve: Curves.easeInOut,
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.recycling,
                size: 100,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 20),
            // Centered text
            Text(
              "Recycle Your E-Waste",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            SizedBox(height: 10),
            // Additional content below the title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Join us in making the world a better place by recycling your e-waste responsibly. Every small step counts!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Animated button with hover effect
            RecyclingHoverButton(),
          ],
        ),
      ),
    );
  }
}

class RecyclingHoverButton extends StatefulWidget {
  @override
  _RecyclingHoverButtonState createState() => _RecyclingHoverButtonState();
}

class _RecyclingHoverButtonState extends State<RecyclingHoverButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Start Recycling",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            if (_isHovered)
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Icon(
                  Icons.arrow_forward,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}