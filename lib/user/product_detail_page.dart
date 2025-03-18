import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'extra_information_page.dart';
import '../config.dart';
class ProductDetailPage extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final String rate;
  final String? imagePath;

  const ProductDetailPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.rate,
    this.imagePath,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  String _selectedType = "Smartphone";
  String _selectedCondition = "Working";
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _manufacturingYearController = TextEditingController();

  final List<String> productTypes = [
    "Air Conditioner", "Bar Phone", "Battery", "Blood Pressure Monitor",
    "Boiler", "CRT Monitor", "CRT TV", "Calculator", "Camera",
    "Ceiling Fan", "Christmas Lights", "Clothes Iron", "Coffee Machine",
    "Compact Fluorescent Lamps", "Computer Keyboard", "Computer Mouse",
    "Cooled Dispenser", "Cooling Display", "Dehumidifier", "Desktop PC",
    "Digital Oscilloscope", "Dishwasher", "Drone", "Electric Bicycle",
    "Electric Guitar", "Electrocardiograph Machine", "Electronic Keyboard",
    "Exhaust Fan", "Flashlight", "Flat Panel Monitor", "Flat Panel TV",
    "Floor Fan", "Freezer", "Glucose Meter", "HDD", "Hair Dryer",
    "Headphone", "LED Bulb", "Laptop", "Microwave", "Music Player",
    "Neon Sign", "Network Switch", "Non-Cooled Dispenser", "Oven", "PCB",
    "Patient Monitoring System", "Photovoltaic Panel", "PlayStation 5",
    "Power Adapter", "Printer", "Projector", "Pulse Oximeter", "Range Hood",
    "Refrigerator", "Rotary Mower", "Router", "SSD", "Server",
    "Smart Watch", "Smartphone", "Smoke Detector", "Soldering Iron",
    "Speaker", "Stove", "Straight Tube Fluorescent Lamp", "Street Lamp",
    "TV Remote Control", "Table Lamp", "Tablet", "Telephone Set",
    "Toaster", "Tumble Dryer", "USB Flash Drive", "Vacuum Cleaner",
    "Washing Machine", "Xbox Series X"
  ];


  Future<void> _sendDataToServer() async {
    String? imagePath = widget.imagePath;

    Map<String, dynamic> data = {
      "title": widget.title,
      "description": widget.description,
      "rate": widget.rate,
      "type": _selectedType,
      "condition": _selectedCondition,
      "model_name": _modelNameController.text,
      "manufacturing_year": _manufacturingYearController.text,
      "image_path": imagePath ?? "",
    };

    try {
      var response = await http.post(
        Uri.parse('$BASE_URL/add_product'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode == 201) {
        print("✅ Product uploaded successfully");
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ExtraInformationPage(
              productType: _selectedType,
              condition: _selectedCondition,
              modelName: _modelNameController.text,
              manufacturingYear: _manufacturingYearController.text,
            ),
          ),
        );
      } else {
        print("❌ Failed to upload product: ${response.body}");
      }
    } catch (e) {
      print("⚠️ Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 80, color: Colors.green),
            SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: productTypes.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedType = newValue!;
                });
              },
              decoration: InputDecoration(labelText: "Type of Product"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _modelNameController,
              decoration: InputDecoration(labelText: "Model Name"),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _manufacturingYearController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: "Manufacturing Year"),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedCondition,
              items: ["Working", "Repairable", "Scrap"].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _selectedCondition = newValue!;
                });
              },
              decoration: InputDecoration(labelText: "Working Condition"),
            ),
            SizedBox(height: 20),
            if (widget.imagePath != null)
              Image.file(File(widget.imagePath!), width: 200, height: 200),
            Spacer(),
            ElevatedButton(
              onPressed: _sendDataToServer,
              child: Text("Upload"),
            ),
          ],
        ),
      ),
    );
  }
}