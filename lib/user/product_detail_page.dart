import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'extra_information_page.dart';

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
    "Smartphone", "Laptop", "Tablet", "Desktop Computer",
    "Monitor", "Television", "Refrigerator", "Washing Machine",
    "Air Conditioner", "Microwave Oven", "Printer", "Scanner",
    "Keyboard", "Mouse", "Game Console", "Smartwatch",
    "Digital Camera", "DVD Player", "Router", "Modem",
    "Speakers", "Headphones", "Power Bank", "Electric Kettle",
    "Induction Stove", "Vacuum Cleaner", "Hair Dryer",
    "Electric Iron", "Charger", "Projector", "Set-Top Box",
    "CCTV Camera", "UPS", "Server", "Graphics Card",
    "Motherboard", "HDD", "SSD", "RAM Stick",
    "Circuit Boards", "Battery Pack", "LED Bulbs",
    "Electric Vehicle Battery", "eBike Charger",
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
        Uri.parse("http://192.168.1.12:5000/add_product"),
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
