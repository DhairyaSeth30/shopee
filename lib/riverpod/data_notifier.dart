import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../modal/product_modal.dart';
import 'base_state.dart';

class ProductNotifier extends StateNotifier<DataState<List<Product>>> {
  ProductNotifier() : super(DataState(status: DataStatus.loading)) {
    loadProducts();
  }

  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  // Fetch existing products from SharedPreferences
  Future<void> loadProducts() async {
    try {
      state = DataState(status: DataStatus.loading);
      final prefs = await SharedPreferences.getInstance();
      final productList = prefs.getString('products');
      if (productList != null) {
        final List<dynamic> decodedProducts = jsonDecode(productList);
        final products = decodedProducts
            .map((product) => Product(
                  name: product['name'],
                  price: product['price'],
                  imagePath: product['imagePath'],
                ))
            .toList();

        allProducts = products;
        // print('All products are ');
        // print(allProducts);

        state = DataState(
            status: DataStatus.success,
            data: products);
      } else {
        allProducts = [];
        state = DataState(
            status: DataStatus.success,
            data: []); // No products found, but still success
      }
    } catch (e) {
      state = DataState(
          status: DataStatus.error,
          message: 'Failed to load load products');
    }
  }

  // Filter products based on the query
  void searchProducts(String query) {
    if (query.isEmpty) {
      state = DataState(status: DataStatus.success, data: allProducts);
      // print(state.data);
    } else {
      // Filter based on query
      // print(query);
      final filtered = allProducts.where((p) {
        return p.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
      state = DataState(status: DataStatus.success, data: filtered);
      // print('filtered data');
      // print(filtered);
    }
  }


  // Future<void> loadProducts() async {
  //   try {
  //     state = DataState(status: DataStatus.loading); // Set state to loading
  //     final prefs = await SharedPreferences.getInstance();
  //     final productList = prefs.getString('products');
  //     if (productList != null) {
  //       final List<dynamic> decodedProducts = jsonDecode(productList);
  //       final products = decodedProducts.map((product) => Product(
  //         name: product['name'],
  //         price: product['price'],
  //         imagePath: product['imagePath'],
  //       )).toList();
  //
  //       // Populate both allProducts and filteredProducts
  //       allProducts = products;
  //       filteredProducts = List.from(allProducts);
  //
  //       state = DataState(
  //         status: DataStatus.success,
  //         data: filteredProducts, // Set state to success with filteredProducts
  //       );
  //     } else {
  //       allProducts = [];
  //       filteredProducts = [];
  //
  //       state = DataState(
  //         status: DataStatus.success,
  //         data: filteredProducts, // No products found
  //       );
  //     }
  //   } catch (e) {
  //     state = DataState(
  //       status: DataStatus.error,
  //       message: 'Failed to load products',
  //     );
  //   }
  // }
  //
  // void searchProducts(String query) {
  //   if (query.isEmpty) {
  //     // If no search query, reset filteredProducts to all products
  //     filteredProducts = List.from(allProducts);
  //   } else {
  //     // Filter based on query
  //     filteredProducts = allProducts.where((p) {
  //       return p.name.toLowerCase().contains(query.toLowerCase());
  //     }).toList();
  //   }
  //
  //   // Update state with filteredProducts
  //   state = DataState(status: DataStatus.success, data: filteredProducts);
  // }


  // Add a new product
  Future<void> addProduct(Product product) async {
    try {
      // If state.data is null, initialize it as an empty list
      final currentProducts = state.data ?? [];

      if (!_isDuplicate(currentProducts, product)) {
        final updatedProducts = [...currentProducts, product];

        // Update both allProducts and state data with the new product
        allProducts = updatedProducts;
        state = DataState(status: DataStatus.success, data: allProducts);

        // print('Updated products');
        // print(allProducts);
        _saveProducts(allProducts);
        // _saveProducts(updatedProducts);
      } else {
        state = DataState(status: DataStatus.error, message: 'Duplicate Product');
      }
    } catch (e) {
      state = DataState(status: DataStatus.error, message: 'Failed to add product');
    }
  }

  // Delete a product
  void deleteProduct(Product product) {
    // try {
    //   if (state.data != null) {
    //     final updatedProducts =
    //         state.data!.where((p) => p.name != product.name).toList();
    //     state = DataState(status: DataStatus.success, data: updatedProducts);
    //     _saveProducts(updatedProducts);
    //   }
    // } catch (e) {
    //   state = DataState(
    //       status: DataStatus.error, message: 'Failed to delete product');
    // }

    try {
      if (state.data != null) {
        final updatedProducts = allProducts.where((p) => p.name != product.name).toList();

        // Update both allProducts and state
        allProducts = updatedProducts;
        state = DataState(status: DataStatus.success, data: allProducts);

        _saveProducts(allProducts);
      }
    } catch (e) {
      state = DataState(
          status: DataStatus.error, message: 'Failed to delete product'
      );
    }

    // try {
    //   if (state.data != null) {
    //     // Remove the product from both allProducts and filteredProducts
    //     allProducts = allProducts.where((p) => p.name != product.name).toList();
    //     filteredProducts = filteredProducts.where((p) => p.name != product.name).toList();
    //
    //     // Update the state with the updated filteredProducts
    //     state = DataState(status: DataStatus.success, data: filteredProducts);
    //
    //     // Save the updated allProducts list to SharedPreferences
    //     _saveProducts(allProducts);
    //   }
    // } catch (e) {
    //   state = DataState(
    //       status: DataStatus.error, message: 'Failed to delete product');
    // }

  }

  // Check for duplicates
  bool _isDuplicate(List<Product> products, Product product) {
    return products.any((p) => p.name == product.name);
  }

  // Save products to SharedPreferences
  Future<void> _saveProducts(List<Product> products) async {
    final prefs = await SharedPreferences.getInstance();
    final productList = jsonEncode(products
        .map((product) => {
              'name': product.name,
              'price': product.price,
              'image': product.imagePath,
            })
        .toList());
    // print(productList);
    await prefs.setString('products', productList);
  }

}
