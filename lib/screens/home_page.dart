import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopee/riverpod/base_state.dart';
import '../app_router/route_constants.dart';
import '../modal/product_modal.dart';
import '../riverpod/data_provider.dart';
import 'add_product.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    ref.read(productNotifierProvider.notifier).loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Icon(
                Icons.logout,
              color: Colors.red,
            ),
            onPressed: () {
              openLogoutDialog(context);
            }
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Products...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (query) {
                ref.read(productNotifierProvider.notifier).searchProducts(query);
              },
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'Hi-Fi Shop & Service',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22.sp,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text('Audio shop on Rustaveli Ave 57'),
            SizedBox(
              height: 5.h,
            ),
            Text('This shop offers both products and services'),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                    'Products',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                    productState.data != null && productState.data!.isNotEmpty
                        ? productState.data!.length.toString()
                        : '0',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    )
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
                child: productState.status == DataStatus.loading
                    ? const Center(child: CircularProgressIndicator())
                    : productState.status == DataStatus.error
                        ? Center(
                            child: Text(
                                'Error: ${productState.message ?? 'Unknown error'}'),
                          )
                        : productState.data == null ||
                                productState.data!.isEmpty
                            ? const Center(child: Text('No Products Found'))
                            : SingleChildScrollView(
                              child: GridView.builder(
                                  itemCount: productState.data!.length,
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, // 2 columns
                                    crossAxisSpacing:
                                        12.0, // spacing between columns
                                    mainAxisSpacing: 0.0, // spacing between rows
                                    mainAxisExtent: 180,
                                  ),
                                  itemBuilder: (context, index) {
                                    final product = productState.data![index];
                                    return ProductCard(
                                      product: product,
                                      onDelete: () {
                                        ref
                                            .read(
                                                productNotifierProvider.notifier)
                                            .deleteProduct(product);
                                      },
                                    );
                                  }),
                            )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );

  }

  Future<void> _logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('authToken'); // Removing token from shared preferences

    context.go('/${Routes.signIn}');

  }

  void openLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async{
                await _logout(context);
                Navigator.of(context).pop();
              },
              child: Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;

  const ProductCard({super.key, required this.product, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.red,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('tapped!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: Container(
              height: 110,
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 2,
                      ),
                      GestureDetector(
                          onTap: onDelete,
                          child: Icon(
                              Icons.delete_outline_outlined
                          )
                      ),
                    ],
                  ),
                  Positioned(
                    top: 15.0,
                    bottom: 15.0,
                    left: 30.0,
                    right: 30.0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: product.imagePath != null
                          ? Image.file(
                              File(product.imagePath!),
                              fit: BoxFit.fill,
                            )
                          : Icon(Icons.image),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Text(
            product.name,
            style: TextStyle(
                fontSize: 16.sp,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          Text(
            '₹ ${product.price}',
            style: TextStyle(
                fontSize: 14.sp,
                fontFamily: 'Rubik',
                fontWeight: FontWeight.w500,
                color: Colors.grey),
          ),
        ],
      ),
    );

  }

}