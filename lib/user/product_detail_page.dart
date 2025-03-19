import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'extra_information_page.dart';
import '../config.dart';

class ProductDetailPage extends StatefulWidget {
  final File image;
  final IconData icon;
  final String title;
  final String description;
  final String rate;

  const ProductDetailPage({
    required this.image,
    required this.icon,
    required this.title,
    required this.description,
    required this.rate,
  });

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final _formKey = GlobalKey<FormState>();
  String _selectedType = "Smartphone";
  String _selectedCondition = "Working";
  File? _selectedImage;
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _manufacturingYearController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendDataToServer() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    var uri = Uri.parse('$BASE_URL/add_product');
    var request = http.MultipartRequest('POST', uri);

    request.fields['title'] = widget.title;
    request.fields['description'] = widget.description;
    request.fields['rate'] = widget.rate;
    request.fields['type'] = _selectedType;
    request.fields['condition'] = _selectedCondition;
    request.fields['model_name'] = _modelNameController.text;
    request.fields['manufacturing_year'] = _manufacturingYearController.text;

    if (_selectedImage != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _selectedImage!.path),
      );
    }

    try {
      var response = await request.send();
      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("✅ Product uploaded successfully!")),
        );
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("❌ Failed to upload product.")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠️ Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(widget.icon, size: 80, color: Colors.green),
              SizedBox(height: 20),

              // Product Type Dropdown
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

              // Model Name Input
              TextFormField(
                controller: _modelNameController,
                decoration: InputDecoration(labelText: "Model Name"),
                validator: (value) =>
                value!.isEmpty ? "Please enter model name" : null,
              ),
              SizedBox(height: 10),

              // Manufacturing Year Input
              TextFormField(
                controller: _manufacturingYearController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Manufacturing Year"),
                validator: (value) =>
                value!.isEmpty ? "Please enter manufacturing year" : null,
              ),
              SizedBox(height: 10),

              // Product Condition Dropdown
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

              // Image Picker
              _selectedImage != null
                  ? Image.file(_selectedImage!, width: 200, height: 200)
                  : Text("No Image Selected"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: Icon(Icons.camera),
                    label: Text("Camera"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: Icon(Icons.image),
                    label: Text("Gallery"),
                  ),
                ],
              ),
              SizedBox(height: 20),

              // Upload Button
              ElevatedButton(
                onPressed: _sendDataToServer,
                child: Text("Upload"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
