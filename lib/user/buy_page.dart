import 'package:baba/config.dart';
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
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = "";
  String sortBy = "product_name"; // Default sorting

  @override
  void initState() {
    super.initState();
    _productsFuture = fetchProducts();
  }

  // Fetch Products from API
  Future<List<Map<String, dynamic>>> fetchProducts() async {
    final response = await http.get(Uri.parse("$BASE_URL/get_collector_products"));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      List<Map<String, dynamic>> productList = List<Map<String, dynamic>>.from(data["products"]);

      setState(() {
        products = productList;
        filteredProducts = List.from(products);
      });

      return productList;
    } else {
      throw Exception("Failed to load products");
    }
  }

  // 🔹 Search Functionality
  void searchProducts(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
      filteredProducts = products.where((product) {
        return product['product_name'].toLowerCase().contains(searchQuery) ||
            product['description'].toLowerCase().contains(searchQuery);
      }).toList();
    });
  }

  // 🔹 Sorting Functionality
  void sortProducts(String key) {
    setState(() {
      sortBy = key;
      filteredProducts.sort((a, b) => a[key].toString().compareTo(b[key].toString()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy By-Products"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Back button functionality
        ),
      ),
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

          return RefreshIndicator(
            onRefresh: fetchProducts,
            child: Column(
              children: [
                // 🔹 Search Bar
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: searchProducts,
                    decoration: InputDecoration(
                      labelText: "Search Products",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                // 🔹 Sorting Options
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Sort by:"),
                      DropdownButton<String>(
                        value: sortBy,
                        items: [
                          DropdownMenuItem(value: "product_name", child: Text("Name")),
                          DropdownMenuItem(value: "price", child: Text("Price")),
                        ],
                        onChanged: (value) {
                          if (value != null) sortProducts(value);
                        },
                      ),
                    ],
                  ),
                ),
                // 🔹 Product List
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: filteredProducts.length,
                    itemBuilder: (context, index) {
                      final product = filteredProducts[index];

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
                                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 4),
                                      Text(product["description"], style: TextStyle(color: Colors.grey)),
                                      SizedBox(height: 8),
                                      Text(
                                        "₹${product["price"]}/piece",
                                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
