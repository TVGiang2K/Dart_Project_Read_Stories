import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;

  Product({required this.name, required this.price});
}

class CommentedProduct {
  final String name;
  final String comment;

  CommentedProduct({required this.name, required this.comment});
}

class UserInfoScreen extends StatelessWidget {


  final List<Product> favoriteProducts = [
    Product(name: 'Sản phẩm 1', price: 500.0),
    Product(name: 'Sản phẩm 2', price: 1000.0),
    Product(name: 'Sản phẩm 3', price: 750.0),
  ];

  final List<CommentedProduct> commentedProducts = [
    CommentedProduct(name: 'Sản phẩm A', comment: 'Rất tốt, đáng mua!'),
    CommentedProduct(name: 'Sản phẩm B', comment: 'Chất lượng chưa như mong đợi.'),
    CommentedProduct(name: 'Sản phẩm C', comment: 'Hài lòng với sản phẩm này.'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thông Tin Người Dùng'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.account_circle,
                size: 100.0,
                color: Colors.deepPurple,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Tên người dùng: Nguyen Van A',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Text(
              'Email: nguyenvana@example.com',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Sản phẩm yêu thích:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: favoriteProducts.length,
                itemBuilder: (context, index) {
                  final product = favoriteProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.favorite, color: Colors.red),
                      title: Text(product.name),
                      subtitle: Text('Giá: ${product.price} VND'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Sản phẩm đã bình luận:',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: commentedProducts.length,
                itemBuilder: (context, index) {
                  final commentedProduct = commentedProducts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Icon(Icons.comment, color: Colors.blue),
                      title: Text(commentedProduct.name),
                      subtitle: Text('Bình luận: "${commentedProduct.comment}"'),
                    ),
                  );
                },
              ),
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Thực hiện hành động khi người dùng nhấn nút, ví dụ đăng xuất
                  print('Người dùng đã nhấn nút');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 80.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: Text(
                  'Thực hiện hành động',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

