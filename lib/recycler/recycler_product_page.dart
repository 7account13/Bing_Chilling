import 'package:flutter/material.dart';

class RecyclerProductPage extends StatefulWidget {
  @override
  _RecyclerProductPageState createState() => _RecyclerProductPageState();
}

class _RecyclerProductPageState extends State<RecyclerProductPage> {
  String? selectedName;
  List<String> names = ["John Doe", "Jane Smith", "Alice Johnson", "Bob Brown"];
  Map<String, Map<String, dynamic>> productDetails = {
    "John Doe": {
      "products": [
        {"productName": "Copper", "ordered": 100, "delivered": 80},
        {"productName": "Aluminum", "ordered": 150, "delivered": 120},
      ],
      "phone": "+1234567890",
      "address": "123 Green St, E-City",
      "email": "john.doe@example.com",
    },
    "Jane Smith": {
      "products": [
        {"productName": "Mercury", "ordered": 50, "delivered": 40},
        {"productName": "Lead", "ordered": 200, "delivered": 180},
      ],
      "phone": "+0987654321",
      "address": "456 Eco Rd, Recycle Town",
      "email": "jane.smith@example.com",
    },
    "Alice Johnson": {
      "products": [
        {"productName": "Cadmium", "ordered": 75, "delivered": 60},
        {"productName": "Copper", "ordered": 90, "delivered": 85},
      ],
      "phone": "+1122334455",
      "address": "789 Recycle Ave, Green Valley",
      "email": "alice.johnson@example.com",
    },
    "Bob Brown": {
      "products": [
        {"productName": "Aluminum", "ordered": 300, "delivered": 250},
        {"productName": "Lead", "ordered": 120, "delivered": 100},
      ],
      "phone": "+5566778899",
      "address": "321 Eco Lane, Sustainable City",
      "email": "bob.brown@example.com",
    },
  };

  void _showDetailsPopup(BuildContext context, String name) {
    final details = productDetails[name];
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Contact Details"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: Icon(Icons.phone, color: Colors.green),
                title: Text("Phone: ${details!['phone']}"),
              ),
              ListTile(
                leading: Icon(Icons.location_on, color: Colors.green),
                title: Text("Address: ${details['address']}"),
              ),
              ListTile(
                leading: Icon(Icons.email, color: Colors.green),
                title: Text("Email: ${details['email']}"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Report of a Collector"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Centered dropdown with a label
            Center(
              child: Column(
                children: [
                  Text(
                    "Select the collector name",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButton<String>(
                    value: selectedName,
                    onChanged: (value) {
                      setState(() {
                        selectedName = value;
                      });
                    },
                    items: names.map((name) {
                      return DropdownMenuItem<String>(
                        value: name,
                        child: Text(name),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            // Table based on selected name
            if (selectedName != null)
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text("Name")),
                      DataColumn(label: Text("Product Name")),
                      DataColumn(label: Text("Quantity (Ordered)")),
                      DataColumn(label: Text("Quantity (Delivered)")),
                    ],
                    rows: productDetails[selectedName]!['products']
                        .map<DataRow>((product) {
                      return DataRow(
                        cells: [
                          DataCell(
                            GestureDetector(
                              onTap: () => _showDetailsPopup(context, selectedName!),
                              child: Text(selectedName!),
                            ),
                          ),
                          DataCell(Text(product['productName'])),
                          DataCell(Text(product['ordered'].toString())),
                          DataCell(Text(product['delivered'].toString())),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}