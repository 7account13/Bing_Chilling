import 'package:flutter/material.dart';

class NotificationListPage extends StatefulWidget {
  @override
  _NotificationListPageState createState() => _NotificationListPageState();
}

class _NotificationListPageState extends State<NotificationListPage> {
  List<String> notifications = [
    "New e-waste collection drive announced!",
    "Reminder: Submit your e-waste report by Friday.",
    "Your recent e-waste submission has been processed.",
  ];

  void _deleteNotification(int index) {
    setState(() {
      notifications.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("The message has been deleted successfully.")),
    );
  }

  void _saveNotification(int index) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("The message has been saved successfully.")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              title: Text(notifications[index]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.save, color: Colors.green),
                    onPressed: () => _saveNotification(index),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteNotification(index),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}