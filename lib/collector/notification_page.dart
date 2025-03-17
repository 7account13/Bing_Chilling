import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationPage extends StatefulWidget {
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Map<String, dynamic>> notifications = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchNotifications();
  }

  Future<void> _fetchNotifications() async {
    try {
      print("Fetching notifications from API...");
      final response = await http.get(Uri.parse('http://192.168.129.81:5000/products_with_address'));

      if (response.statusCode == 200) {
        print("Response status: 200");
        print("Response body: ${response.body}");

        final List<dynamic> notificationList = json.decode(response.body);

        setState(() {
          notifications = List<Map<String, dynamic>>.from(notificationList);
          isLoading = false;
        });

        print("Notifications loaded: ${notifications.length}");

        for (var notification in notifications) {
          print("Rendering notification: ${notification['title']}");
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load notifications. Error: ${response.statusCode}';
          isLoading = false;
        });
        print(errorMessage);
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
      print(errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.green.shade700,
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage))
          : notifications.isEmpty
          ? Center(child: Text("No notifications available"))
          : ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notification = notifications[index];

          // Handle address construction
          String address = [
            notification['address_line1'],
            notification['address_line2']
          ].where((part) => part != null && part.isNotEmpty).join(', ');

          if (address.isEmpty) {
            address = 'N/A';
          }

          // Handle pickup date
          String pickupDate = notification['pickup_date'] ?? 'N/A';

          return Card(
            elevation: 4,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(notification['title'] ?? 'No Title',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              subtitle: Text(
                  "Address: $address\n"
                      "Product: ${notification['title'] ?? 'N/A'}\n"
                      "Model: ${notification['model_name'] ?? 'N/A'}\n"
                      "Condition: ${notification['condition'] ?? 'N/A'}\n"
                      "Pickup Date: $pickupDate",
                  style: TextStyle(fontSize: 16)),
              leading: Icon(Icons.notifications_active,
                  color: Colors.green.shade700),
            ),
          );
        },
      ),
    );
  }
}
