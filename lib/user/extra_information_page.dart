import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'address_details_page.dart'; // Correct import for AddressDetailsPage
import 'user_home_page.dart'; // Correct import for UserHomePage

class ExtraInformationPage extends StatefulWidget {
  final String productType;
  final String condition;
  final String modelName;
  final String manufacturingYear;

  // Constructor to accept parameters
  ExtraInformationPage({
    required this.productType,
    required this.condition,
    required this.modelName,
    required this.manufacturingYear,
  });

  @override
  _ExtraInformationPageState createState() => _ExtraInformationPageState();
}

class _ExtraInformationPageState extends State<ExtraInformationPage> {
  double price = 0.0;

  @override
  void initState() {
    super.initState();
    fetchPrice();
  }

  Future<void> fetchPrice() async {
    final url = Uri.parse('http://192.168.1.12:5000/get_price');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_type": widget.productType,
          "condition": widget.condition,
          "model_name": widget.modelName,
          "manufacturing_year": widget.manufacturingYear,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          price = jsonDecode(response.body)['estimated_price'];
        });
      } else {
        print('Failed to fetch price: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Price Information")),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Estimated Price: ₹${price.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate to AddressDetailsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddressDetailsPage()),
                  );
                },
                child: Text("Go to Address Details"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Navigate to UserHomePage
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserHomePage()),
                  );
                },
                child: Text("Go to Home Page"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
