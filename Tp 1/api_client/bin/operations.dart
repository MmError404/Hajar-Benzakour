import 'dart:convert'; // For converting JSON data to Dart objects and vice versa
import 'dart:io'; // For handling I/O, especially HTTP requests
import 'package:http/http.dart' as http; // For making HTTP requests (GET, POST, etc.)

// Fetch all products
Future<void> getProducts(String baseUrl) async {
  final response = await http.get(Uri.parse('$baseUrl/products'));

  if (response.statusCode == 200) {
    List<dynamic> products = jsonDecode(response.body);
    print('Available Products:');
    for (var product in products) {
      print('Name: ${product['name']}, Price: ${product['price']}, Stock: ${product['stock']},Catégorie: ${product['categorie']}');
    }
  } else {
    print('Error fetching products');
  }
}

// Add a new product
Future<void> addProduct(String baseUrl, Map<String, dynamic> product) async {
  final response = await http.post(
    Uri.parse('$baseUrl/products'),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: jsonEncode(product),
  );

  if (response.statusCode == 201) {
    print('Product added successfully');
  } else {
    print('Error adding product');
  }
}

// Fetch all orders
Future<void> getOrders(String baseUrl) async {
  final response = await http.get(Uri.parse('$baseUrl/orders'));

  if (response.statusCode == 200) {
    List<dynamic> orders = jsonDecode(response.body);
    print('Available Orders:');

  for (var order in orders) {
      print("ID : ${order['id']}");
      order['products'].entries.map((element) {
        return " -> ${element.key} ------------ ${element.value} unité(s)";
      }).forEach(print);
      print("Total : ${order['total']} DH");
    }

  } else {
    print('Error fetching orders');
  }
}

// Add a new order
Future<void> addOrder(String baseUrl, Map<String, dynamic> order) async {
  final response = await http.post(
    Uri.parse('$baseUrl/orders'),
    headers: {HttpHeaders.contentTypeHeader: 'application/json'},
    body: jsonEncode(order),
  );

  if (response.statusCode == 201) {
    print('Order created successfully');
  } else {
    print('Error creating order');
  }
}