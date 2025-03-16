import 'package:flutter/material.dart';
import '/user/sell_page.dart';
import '/user/buy_page.dart';
import '/common/login_page.dart';

class UserHomePage extends StatelessWidget {
  const UserHomePage({Key? key}) : super(key: key);

  void _logout(BuildContext context) {
    // Perform logout logic here (e.g., clear session, navigate to login page)
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("E-Waste Recycling"),
        backgroundColor: Colors.green.shade700,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SellPage()),
                      );
                    },
                    child: Text("Sell E-Waste"),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BuyPage()),
                      );
                    },
                    child: Text("Buy Recycled Items"),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Why Recycle E-Waste?",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "E-waste contains valuable materials like gold, silver, and copper, but also harmful chemicals like lead and mercury. Recycling helps recover these materials while preventing environmental pollution.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            Text(
              "Benefits of E-Waste Recycling",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ListTile(
              leading: Icon(Icons.eco, color: Colors.green),
              title: Text("Reduces pollution and landfill waste"),
            ),
            ListTile(
              leading: Icon(Icons.loop, color: Colors.blue),
              title: Text("Saves valuable raw materials"),
            ),
            ListTile(
              leading: Icon(Icons.local_hospital, color: Colors.red),
              title: Text("Prevents harmful health effects"),
            ),
            ListTile(
              leading: Icon(Icons.business, color: Colors.orange),
              title: Text("Creates job opportunities in the recycling industry"),
            ),
          ],
        ),
      ),
    );
  }
}
