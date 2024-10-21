import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import '../components/rounded_button2.dart';
import '../modal/product_modal.dart';
import '../riverpod/base_state.dart';
import '../riverpod/data_provider.dart';


class AddProductPage extends ConsumerStatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  File? _image;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveProduct() async {
    String name = _nameController.text.trim();
    String price = _priceController.text.trim();

    if (name.isEmpty || price.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please fill all fields')));
      return;
    }

    // Create a new product
    Product newProduct = Product(
      name: name,
      price: double.tryParse(price) ?? 0,
      imagePath: _image?.path,
    );

    await ref.read(productNotifierProvider.notifier).addProduct(newProduct);

    final productState = ref.watch(productNotifierProvider);
    if (productState.status == DataStatus.error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(productState.message ?? 'Error occurred')));
    } else {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final productState = ref.watch(productNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Add Product'),
      ),
      body: productState.status == DataStatus.loading
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Container(
                padding:
                    const EdgeInsets.only(left: 30.0, right: 30.0, top: 10.0),
                width: MediaQuery.of(context).size.width,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enter Product Details',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: [
                          Icon(
                            Icons.drive_file_rename_outline,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .grey),
                                ),
                                hintText: 'Product Name',
                                hintStyle: TextStyle(
                                  color: Color(0xffC4C5C4),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment
                            .center,
                        children: [
                          const Icon(
                            Icons.currency_rupee,
                            color: Colors.grey,
                          ),
                          SizedBox(width: 5),
                          Expanded(
                            child: TextField(
                              controller: _priceController,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .grey),
                                ),
                                hintText: 'Price',
                                hintStyle: TextStyle(
                                  color: Color(0xffC4C5C4),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),

                        ],
                      ),
                      SizedBox(height: 20.h,),
                      _image == null
                          ? Text('No Image Selected')
                          : Image.file(_image!),
                      SizedBox(height: 5.h),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                        onPressed: _pickImage,
                        child: Text(
                            'Upload Image',
                          style: TextStyle(
                            color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      RoundedButton2(
                        onPressed: _saveProduct,
                        title: 'Add Product',
                        textColor: const Color.fromRGBO(255, 255, 255, 1),
                        colour: Colors.blue,
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
