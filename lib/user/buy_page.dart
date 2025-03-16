import 'package:flutter/material.dart';
import 'product_detail_page.dart';

class BuyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Product Sell"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Product Sell",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildProductItem(
              context,
              Icons.article,
              "News paper",
              "Used for recycling and packaging.",
              "Rs 8/kg",
            ),
            _buildProductItem(
              context,
              Icons.book,
              "Notebook",
              "Old notebooks for recycling.",
              "Rs 5/kg",
            ),
            _buildProductItem(
              context,
              Icons.menu_book,
              "New book",
              "Unused books for resale.",
              "Rs 4/kg",
            ),
            _buildProductItem(
              context,
              Icons.library_books,
              "Old book",
              "Old books for recycling.",
              "Rs 3/kg",
            ),
            _buildProductItem(
              context,
              Icons.article,
              "Magazine",
              "Old magazines for recycling.",
              "Rs 1/kg",
            ),
            _buildProductItem(
              context,
              Icons.local_movies,
              "Cartoons",
              "Old cartoon books for recycling.",
              "Rs 3/kg",
            ),
            _buildProductItem(
              context,
              Icons.local_drink,
              "Plastic Bottles",
              "Used plastic bottles for recycling.",
              "Rs 5/kg",
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
    String rate,
  ) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailPage(
                icon: icon,
                title: title,
                description: description,
                rate: rate,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: Colors.green, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(description, style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    Text(
                      rate,
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
  }
}