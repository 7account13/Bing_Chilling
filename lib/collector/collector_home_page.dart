import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'notification_page.dart';
import 'collector_product_page.dart';
import 'sell_scrap_page.dart';
import '/common/login_page.dart';
import '/config.dart';

class CollectorHomePage extends StatefulWidget {
  @override
  _CollectorHomePageState createState() => _CollectorHomePageState();
}

class _CollectorHomePageState extends State<CollectorHomePage> {
  Map<DateTime, int> pickupCounts = {};
  Map<DateTime, int> scrapCounts = {};

  @override
  void initState() {
    super.initState();
    fetchPickups();
    fetchScrapDetails();
  }

  Future<void> fetchPickups() async {
    final response = await http.get(Uri.parse('$BASE_URL/products_with_address'));
    if (response.statusCode == 200) {
      List<dynamic> pickups = json.decode(response.body);
      Map<DateTime, int> tempPickupCounts = {};

      for (var pickup in pickups) {
        DateTime date = DateTime.parse(pickup['pickup_date']).toLocal();
        tempPickupCounts[DateTime(date.year, date.month, date.day)] =
            (tempPickupCounts[DateTime(date.year, date.month, date.day)] ?? 0) + 1;
      }

      setState(() {
        pickupCounts = tempPickupCounts;
      });
    }
  }

  Future<void> fetchScrapDetails() async {
    final response = await http.get(Uri.parse('$BASE_URL/retrieve_scrap'));
    if (response.statusCode == 200) {
      List<dynamic> scraps = json.decode(response.body);
      Map<DateTime, int> tempScrapCounts = {};

      for (var scrap in scraps) {
        DateTime date = DateTime.parse(scrap['send_date']).toLocal();
        tempScrapCounts[DateTime(date.year, date.month, date.day)] =
            (tempScrapCounts[DateTime(date.year, date.month, date.day)] ?? 0) + 1;
      }

      setState(() {
        scrapCounts = tempScrapCounts;
      });
    } else {
      print("Failed to load scrap data: ${response.statusCode}");
    }
  }

  Color getColorForDensity(int pickupCount, int scrapCount) {
    if (pickupCount > 0 && scrapCount > 0) {
      return Colors.purple; // Both pickups & scrap on same day
    } else if (pickupCount > 0) {
      return Colors.green; // Pickups
    } else if (scrapCount > 0) {
      return Colors.red; // Scrap
    } else {
      return Colors.transparent;
    }
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Bing Chilling",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
              icon: Icon(Icons.notifications, color: Colors.white),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()))),
          IconButton(icon: Icon(Icons.logout, color: Colors.white), onPressed: logout),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 15),

          // Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CollectorProductPage())),
                child: Text("Sell By-Product"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SellScrapPage())),
                child: Text("Sell Scrap"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage())),
                child: Text("Pickups"),
              ),
            ],
          ),

          SizedBox(height: 15),

          // Calendar
          Expanded(
            child: TableCalendar(
              firstDay: DateTime(2020),
              lastDay: DateTime(2030),
              focusedDay: DateTime.now(),
              calendarFormat: CalendarFormat.month,
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(color: Colors.blue.shade200, shape: BoxShape.circle),
                selectedDecoration: BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(weekendStyle: TextStyle(color: Colors.red)),
              headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, date, _) {
                  DateTime normalizedDate = DateTime(date.year, date.month, date.day);
                  int pickupCount = pickupCounts[normalizedDate] ?? 0;
                  int scrapCount = scrapCounts[normalizedDate] ?? 0;
                  Color bgColor = getColorForDensity(pickupCount, scrapCount);

                  return Container(
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${date.day}',
                      style: TextStyle(
                          color: (pickupCount > 0 || scrapCount > 0) ? Colors.white : Colors.black),
                    ),
                  );
                },
              ),
            ),
          ),

          SizedBox(height: 10),

          // Legend
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.circle, color: Colors.green, size: 14),
                SizedBox(width: 5),
                Text("Pickups"),
                SizedBox(width: 20),
                Icon(Icons.circle, color: Colors.red, size: 14),
                SizedBox(width: 5),
                Text("Scrap Sending"),
                SizedBox(width: 20),
                Icon(Icons.circle, color: Colors.purple, size: 14),
                SizedBox(width: 5),
                Text("Both"),
              ],
            ),
          ),

          SizedBox(height: 10),
        ],
      ),
    );
  }
}
