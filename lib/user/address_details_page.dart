import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config.dart';

class AddressDetailsPage extends StatefulWidget {
  final String productType;
  final String condition;
  final String modelName;
  final String manufacturingYear;
  final double price;

  AddressDetailsPage({
    required this.productType,
    required this.condition,
    required this.modelName,
    required this.manufacturingYear,
    required this.price,
  });

  @override
  _AddressDetailsPageState createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final TextEditingController streetController = TextEditingController();
  final TextEditingController addressLine1Controller = TextEditingController();
  final TextEditingController addressLine2Controller = TextEditingController();
  final TextEditingController districtPincodeController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController pickupDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        pickupDateController.text =
        "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> storeData() async {
    if (streetController.text.isEmpty ||
        addressLine1Controller.text.isEmpty ||
        addressLine2Controller.text.isEmpty ||
        districtPincodeController.text.isEmpty ||
        stateController.text.isEmpty ||
        phoneController.text.isEmpty ||
        pickupDateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("All fields are required!")),
      );
      return;
    }

    final url = Uri.parse('$BASE_URL/store_product_address');

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "title": widget.productType,
        "description": "This is a test product",
        "rate": widget.price.toString(), // Ensure it's a string
        "type": "Electronics",
        "condition": widget.condition,
        "model_name": widget.modelName,
        "manufacturing_year": widget.manufacturingYear, // Keep as string
        "image_path": "path/to/image.jpg",
        "street_name": streetController.text,
        "address_line1": addressLine1Controller.text,
        "address_line2": addressLine2Controller.text,
        "district_pincode": districtPincodeController.text,
        "state": stateController.text,
        "phone_number": phoneController.text,
        "pickup_date": pickupDateController.text,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Data stored successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to store data! ${response.body}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Enter Address Details")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Product: ${widget.productType}"),
            Text("Condition: ${widget.condition}"),
            Text("Model: ${widget.modelName}"),
            Text("Year: ${widget.manufacturingYear}"),
            Text(
              "Estimated Price: ₹${widget.price.toStringAsFixed(2)}",
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green.shade700),
            ),
            SizedBox(height: 20),

            TextField(
              controller: streetController,
              decoration: InputDecoration(labelText: "Street Name"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: addressLine1Controller,
              decoration: InputDecoration(labelText: "Address Line 1"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: addressLine2Controller,
              decoration: InputDecoration(labelText: "Address Line 2"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: districtPincodeController,
              decoration: InputDecoration(labelText: "District & Pincode"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 10),

            TextField(
              controller: stateController,
              decoration: InputDecoration(labelText: "State"),
            ),
            SizedBox(height: 10),

            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: "Phone Number"),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 10),

            TextField(
              controller: pickupDateController,
              decoration: InputDecoration(
                labelText: "Pickup Date (YYYY-MM-DD)",
                suffixIcon: IconButton(
                  icon: Icon(Icons.calendar_today),
                  onPressed: () => _selectDate(context),
                ),
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),

            ElevatedButton(
              onPressed: storeData,
              child: Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
