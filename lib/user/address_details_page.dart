import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddressDetailsPage extends StatefulWidget {
  @override
  _AddressDetailsPageState createState() => _AddressDetailsPageState();
}

class _AddressDetailsPageState extends State<AddressDetailsPage> {
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _addressLine1Controller = TextEditingController();
  final TextEditingController _addressLine2Controller = TextEditingController();
  final TextEditingController _districtController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  DateTime? _selectedDate;

  Future<void> _submitData() async {
    if (_streetNameController.text.isEmpty ||
        _addressLine1Controller.text.isEmpty ||
        _addressLine2Controller.text.isEmpty ||
        _districtController.text.isEmpty ||
        _stateController.text.isEmpty ||
        _phoneNumberController.text.isEmpty ||
        _selectedDate == null) {
      _showSubmissionDialog('Error', 'Please fill all the fields.');
      return;
    }

    int? districtPincode = int.tryParse(_districtController.text);
    if (districtPincode == null) {
      _showSubmissionDialog('Error', 'Invalid district pincode.');
      return;
    }

    String formattedDate =
        "${_selectedDate!.year}-${_selectedDate!.month.toString().padLeft(2, '0')}-${_selectedDate!.day.toString().padLeft(2, '0')}";

    var addressData = {
      "street_name": _streetNameController.text,
      "address_line1": _addressLine1Controller.text,
      "address_line2": _addressLine2Controller.text,
      "district_pincode": districtPincode,
      "state": _stateController.text,
      "phone_number": _phoneNumberController.text,
      "pickup_date": formattedDate,
    };

    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.12:5000/add_address'),
        headers: {"Content-Type": "application/json"},
        body: json.encode(addressData),
      );

      if (response.statusCode == 201) {
        _showSubmissionDialog('Success', 'Your address details have been submitted.');
      } else {
        Map<String, dynamic> errorData = json.decode(response.body);
        _showSubmissionDialog('Error', errorData['message'] ?? 'Failed to submit address details.');
      }
    } catch (e) {
      _showSubmissionDialog('Error', 'An error occurred: $e');
    }
  }

  void _showSubmissionDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null) {
      setState(() => _selectedDate = selectedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Pickup Details")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Address Details", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green.shade700)),
            SizedBox(height: 20),
            _buildTextField("Street Name", _streetNameController),
            SizedBox(height: 20),
            _buildTextField("Address (line 1)", _addressLine1Controller),
            SizedBox(height: 20),
            _buildTextField("Address (line 2)", _addressLine2Controller),
            SizedBox(height: 20),
            _buildTextField("District (pincode)", _districtController),
            SizedBox(height: 20),
            _buildTextField("State", _stateController),
            SizedBox(height: 20),
            _buildTextField("Phone Number", _phoneNumberController),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: Text("Select Pickup Date"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700, foregroundColor: Colors.white),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _submitData,
        icon: Icon(Icons.arrow_forward),
        label: Text("Submit"),
        backgroundColor: Colors.green.shade700,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
        SizedBox(height: 8),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}
