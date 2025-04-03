import 'operations.dart';

void main() async {
  // Base URL for the server
  final String baseUrl = 'http://localhost:3000';

  try {
    // Fetch all products
    await getProducts(baseUrl);

    // Add a new product
    final newProduct1 = {'name': 'Produit 1', 'price': 100, 'stock': 20, 'categorie': 'Categorie 1'};
    await addProduct(baseUrl, newProduct1);
    final newProduct2 = {'name': 'Produit 2', 'price': 130, 'stock': 33, 'categorie': 'Categorie 2'};
    await addProduct(baseUrl, newProduct2);


    // Fetch all orders
    await getOrders(baseUrl);

    // Add a new order
    final newOrder1 = {'id': 1, 'products': {'Produit 1': 5}, 'total': 500};
    await addOrder(baseUrl, newOrder1);
    final newOrder2 = {'id': 2, 'products': {'Produit 1': 2, 'Produit 2': 15}, 'total': 2150};
    await addOrder(baseUrl, newOrder2);


  } catch (e) {
    print('An error occurred: $e');
  }
}