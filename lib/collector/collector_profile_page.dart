import 'package:flutter/material.dart';
import '/common/login_page.dart'; // Ensure this is the correct path

class CollectorProfilePage extends StatefulWidget {
  @override
  _CollectorProfilePageState createState() => _CollectorProfilePageState();
}

class _CollectorProfilePageState extends State<CollectorProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Initialize with placeholder data (replace with actual data)
    _nameController.text = "John Doe";
    _emailController.text = "johndoe@example.com";
    _phoneController.text = "+1.415.111.0000";
    _addressController.text = "San Francisco, CA";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Collector Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: _isEditing
            ? [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red, backgroundColor: Colors.white,
            ),
            child: Text("Cancel"),
          ),
          SizedBox(width: 10),
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = false;
              });
              _showSaveConfirmation(context);
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green, backgroundColor: Colors.white,
            ),
            child: Text("Save"),
          ),
        ]
            : [
          TextButton(
            onPressed: () {
              setState(() {
                _isEditing = true;
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.green, backgroundColor: Colors.white,
            ),
            child: Text("Edit"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTextField("Name", _nameController, 24, Colors.green.shade700),
            SizedBox(height: 20),
            _buildTextField("Email", _emailController, 16, Colors.grey.shade800),
            SizedBox(height: 20),
            _buildTextField("Phone", _phoneController, 16, Colors.grey.shade800),
            SizedBox(height: 20),
            _buildTextField("Address", _addressController, 16, Colors.grey.shade800),
            SizedBox(height: 40),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.red.shade700),
              onPressed: () {
                _showLogoutConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, double fontSize, Color color) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        enabled: _isEditing,
      ),
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: label == "Name" ? FontWeight.bold : FontWeight.normal,
        color: color,
      ),
    );
  }

  void _showSaveConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Profile Updated"),
          content: Text("Your profile has been updated successfully!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Logout"),
          content: Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()), // Redirecting to LoginPage
                );
              },
              child: Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
