import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';
import 'product_detail_page.dart';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  late Future<List<Map<String, dynamic>>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  // Fetch Products from API
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(
      Uri.parse("http://192.168.1.12:5000/get_collector_products"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return List<Map<String, dynamic>>.from(data["products"]);
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Product Sell")),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No products available"));
          }

          final products = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];

              // Decode base64 image if available
              Uint8List? imageBytes;
              try {
                imageBytes = base64Decode(product["image_path"]);
              } catch (e) {
                imageBytes = null;
              }

              return Card(
                elevation: 4,
                margin: EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailPage(
                          icon: Icons.shopping_bag, // Placeholder icon
                          title: product["product_name"],
                          description: product["description"],
                          rate: "₹${product["price"]}/kg",
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Row(
                      children: [
                        imageBytes != null
                            ? Image.memory(imageBytes, width: 60, height: 60, fit: BoxFit.cover)
                            : Icon(Icons.image, size: 60, color: Colors.grey),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product["product_name"],
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(product["description"], style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 8),
                              Text(
                                "₹${product["price"]}/kg",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
