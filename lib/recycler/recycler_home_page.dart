import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config.dart'; // Ensure BASE_URL is correctly set
import '../common/login_page.dart'; // Import login page for logout navigation

class RecyclerHomePage extends StatefulWidget {
  @override
  _RecyclerHomePageState createState() => _RecyclerHomePageState();
}

class _RecyclerHomePageState extends State<RecyclerHomePage> {
  List<Map<String, dynamic>> scrapData = [];
  List<Map<String, dynamic>> filteredData = [];
  bool isLoading = true;
  String searchQuery = "";
  String sortBy = "id"; // Default sorting

  @override
  void initState() {
    super.initState();
    fetchScrapData();
  }

  Future<void> fetchScrapData() async {
    final url = Uri.parse('$BASE_URL/retrieve_scrap');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          scrapData = List<Map<String, dynamic>>.from(jsonDecode(response.body));
          filteredData = List.from(scrapData);
          isLoading = false;
        });
      } else {
        print("Failed to fetch scrap data");
      }
    } catch (error) {
      print("Error fetching scrap data: $error");
    }
  }

  // 🔹 Logout Function
  void logout() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  // 🔹 Search Functionality
  void searchScrap(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredData = scrapData.where((item) {
        return item['product_id'].toString().contains(searchQuery) ||
            item['scrap_weight'].toString().contains(searchQuery);
      }).toList();
    });
  }

  // 🔹 Sorting Functionality
  void sortData(String key) {
    setState(() {
      sortBy = key;
      filteredData.sort((a, b) => a[key].compareTo(b[key]));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recycler Home"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout,
            tooltip: "Logout",
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchScrapData,
        child: Column(
          children: [
            // 🔹 Search Bar
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: searchScrap,
                decoration: InputDecoration(
                  labelText: "Search Scrap",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            // 🔹 Sorting Options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Sort by:"),
                  DropdownButton<String>(
                    value: sortBy,
                    items: [
                      DropdownMenuItem(value: "id", child: Text("ID")),
                      DropdownMenuItem(value: "scrap_weight", child: Text("Weight")),
                      DropdownMenuItem(value: "estimated_price", child: Text("Price")),
                    ],
                    onChanged: (value) {
                      if (value != null) sortData(value);
                    },
                  ),
                ],
              ),
            ),
            // 🔹 Scrap List
            Expanded(
              child: ListView.builder(
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  return Card(
                    elevation: 3,
                    margin: EdgeInsets.all(8),
                    child: ListTile(
                      leading: Icon(Icons.recycling, color: Colors.green),
                      title: Text("Scrap ID: ${item['id']}"),
                      subtitle: Text("Weight: ${item['scrap_weight']}g | Price: ₹${item['estimated_price']}"),
                      trailing: Text("Pickup: ${item['pick_up_date']}"),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
