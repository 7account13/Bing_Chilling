import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart'; // Ensure BASE_URL is defined here

class SellScrapPage extends StatefulWidget {
  @override
  _SellScrapPageState createState() => _SellScrapPageState();
}

class _SellScrapPageState extends State<SellScrapPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate() && _selectedDate != null) {
      final Map<String, dynamic> data = {
        "user_id": 1, // Replace with actual user ID
        "product_id": 2, // Replace with actual product ID
        "scrap_weight": double.tryParse(_quantityController.text) ?? 0.0,
        "estimated_price": double.tryParse(_priceController.text) ?? 0.0,
        "pick_up_date": _selectedDate!.toIso8601String().split('T')[0], // Convert to YYYY-MM-DD
      };

      final response = await http.post(
        Uri.parse('$BASE_URL/sell_scrap'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Scrap details submitted successfully!")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to submit data. Please try again.")),
        );
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sell Scrap"),
        backgroundColor: Colors.green.shade700,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Scrap Weight (kg)"),
                  validator: (value) => value!.isEmpty ? "Enter a weight" : null,
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(labelText: "Estimated Price"),
                  validator: (value) => value!.isEmpty ? "Enter a price" : null,
                ),
                SizedBox(height: 16),
                Text("Pick Up Date", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  children: [
                    Text(_selectedDate == null ? "Select a date" : _selectedDate!.toLocal().toString().split(' ')[0]),
                    SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: Text("Pick Date"),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      child: Text(
                        "Submit",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
