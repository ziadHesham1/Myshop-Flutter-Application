import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'product_provider.dart';
import 'package:http/http.dart' as http;

class ProductsProvider with ChangeNotifier {
  ProductsProvider() {
    print('ProductsProvider is called');
  }

  final url = Uri.parse(
      'https://myshop-flutter-app-9477e-default-rtdb.firebaseio.com/products.json');
  // ignore: prefer_final_fields
  List<ProductProvider> _products = [];

  List<ProductProvider> get productItems {
    return [..._products];
  }

  List<ProductProvider> get favoriteProductItems {
    return _products.where((element) => element.isFavorite).toList();
  }

  ProductProvider findProductById(productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  String sameTitleCounter(String newString) {
    bool nameExist = _products.firstWhereOrNull((ProductProvider element) =>
                element.title.contains(newString)) !=
            null
        ? true
        : false;

    int sameNameCounter = nameExist
        ? _products
            .where(
                (ProductProvider element) => element.title.contains(newString))
            .length
        : 0;

    if (sameNameCounter > 0) {
      return '$newString ($sameNameCounter)';
    } else {
      return newString;
    }
  }

  Future<void> fetchAndSetProducts() async {
    try {
      final http.Response response = await http.get(url);
      final Map<String, dynamic> extractedData =
          json.decode(response.body) as Map<String, dynamic>;
      List<ProductProvider> loadedData = [];
      extractedData.forEach((key, value) {
        print('Product : ${value['title']} is fetched from the database');
        loadedData.add(
          ProductProvider(
              id: key,
              title: value['title'],
              description: value['description'],
              price: value['price'],
              imageUrl: value['imageUrl']),
        );
      });
      _products = loadedData;
      notifyListeners();
    } catch (error) {
      print(
          'Error catched in the fetchAndSetProducts function in the ProductsProvider ${error.toString()}');
      rethrow;
    }
  }

  Future<void> addProduct(title, description, double price, imageUrl) async {
    title = sameTitleCounter(title);
    // pushing new product to database
    Map<String, dynamic> newProductMap = {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': false,
    };

    try {
      final http.Response response =
          await http.post(url, body: json.encode(newProductMap));
      // .then((response) {
      _products.add(ProductProvider(
          id: json.decode(response.body)['name'],
          title: title,
          description: description,
          price: price,
          imageUrl: imageUrl));
      notifyListeners();
    } catch (error) {
      print(error);
      rethrow;
    }
  }

  void pushDummyProduct() {
    List<ProductProvider> dummyProducts = [
      ProductProvider(
        id: 'p1',
        title: 'Red Shirt',
        description: 'A red shirt - it is pretty red!',
        price: 29.99,
        imageUrl:
            'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
      ),
      ProductProvider(
        id: 'p2',
        title: 'Trousers',
        description: 'A nice pair of trousers.',
        price: 59.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
      ),
      ProductProvider(
        id: 'p3',
        title: 'Yellow Scarf',
        description: 'Warm and cozy - exactly what you need for the winter.',
        price: 19.99,
        imageUrl:
            'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
      ),
      ProductProvider(
        id: 'p4',
        title: 'A Pan',
        description: 'Prepare any meal you want.',
        price: 49.99,
        imageUrl:
            'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
      ),
    ];
    for (var product in dummyProducts) {
      addProduct(
          product.title, product.description, product.price, product.imageUrl);
    }
    notifyListeners();
  }

  void updateProduct(
      productId, title, description, price, imageUrl, isFavorite) {
    var productIndex =
        _products.indexWhere((product) => product.id == productId);
    _products[productIndex] = ProductProvider(
      id: _products[productIndex].id,
      title: title,
      description: description,
      price: price,
      imageUrl: imageUrl,
      isFavorite: isFavorite,
    );
    notifyListeners();
  }

  void deleteProduct(productId) {
    var productIndex =
        _products.indexWhere((element) => element.id == productId);

    _products.removeAt(productIndex);
    notifyListeners();
  }
}
