import 'package:baba/config.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

class BuyPage extends StatefulWidget {
  @override
  _BuyPageState createState() => _BuyPageState();
}

class _BuyPageState extends State<BuyPage> {
  late Future<List<Map<String, dynamic>>> _productsFuture;
  List<Map<String, dynamic>> products = [];
  List<Map<String, dynamic>> filteredProducts = [];
  String searchQuery = "";
  String sortBy = "product_name";

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

  // 🔹 Place Order
  Future<void> placeOrder(String productId) async {
    final response = await http.post(
      Uri.parse("$BASE_URL/place_order"),
      body: jsonEncode({"product_id": productId}),
      headers: {"Content-Type": "application/json"},
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Order placed successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("✅ Order placed successfully!")),
      );
    }
  }

  // 🔹 Show Product Details in Modal
  void showProductDetails(BuildContext context, Map<String, dynamic> product) {
    Uint8List? imageBytes;
    try {
      imageBytes = base64Decode(product["image_path"]);
    } catch (e) {
      imageBytes = null;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: imageBytes != null
                    ? Image.memory(imageBytes, width: 200, height: 200, fit: BoxFit.cover)
                    : Icon(Icons.image, size: 200, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                product["product_name"],
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                product["description"],
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
              SizedBox(height: 16),
              Text(
                "Price: ₹${product["price"]}/piece",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close modal
                    placeOrder(product["id"].toString()); // Call placeOrder function
                  },
                  child: Text("Buy Now"),
                ),
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Buy By-Products"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
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
                            showProductDetails(context, product);
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
