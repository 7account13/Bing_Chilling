import 'package:flutter/material.dart';

class RecyclerProfilePage extends StatefulWidget {
  @override
  _RecyclerProfilePageState createState() => _RecyclerProfilePageState();
}

class _RecyclerProfilePageState extends State<RecyclerProfilePage> {
  bool isEditing = false;
  TextEditingController nameController = TextEditingController(text: "John Doe");
  TextEditingController emailController = TextEditingController(text: "john.doe@example.com");
  TextEditingController phoneController = TextEditingController(text: "+1234567890");

  void _toggleEdit() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void _saveChanges() {
    setState(() {
      isEditing = false;
    });
    // Save changes logic here
  }

  void _cancelChanges() {
    setState(() {
      isEditing = false;
      nameController.text = "John Doe";
      emailController.text = "john.doe@example.com";
      phoneController.text = "+1234567890";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recycler Profile"),
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save, color: Colors.green),
              onPressed: _saveChanges,
            ),
          if (isEditing)
            IconButton(
              icon: Icon(Icons.cancel, color: Colors.red),
              onPressed: _cancelChanges,
            ),
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue),
              onPressed: _toggleEdit,
            ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Name Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: isEditing
                  ? TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: "Name",
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      nameController.text,
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
            ),
            // Email Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: isEditing
                  ? TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      emailController.text,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
            ),
            // Phone Field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: isEditing
                  ? TextField(
                      controller: phoneController,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        border: OutlineInputBorder(),
                      ),
                    )
                  : Text(
                      phoneController.text,
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    ),
            ),
          ],
        ),
      ),
      // Logout icon in the bottom left
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logout logic here
        },
        child: Icon(Icons.logout, color: Colors.white),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}