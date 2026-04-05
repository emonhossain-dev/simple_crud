import 'dart:convert';

import 'package:curd_tudo/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateData extends StatefulWidget {
  const UpdateData({super.key, required this.products, required this.onUpdate});

  static const String name = "update_screen";


  final Product products;

  final Function(Product) onUpdate;


  @override
  State<UpdateData> createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  final TextEditingController _productNameController = TextEditingController();
  final TextEditingController _productPriceController = TextEditingController();
  final TextEditingController _productTotalController = TextEditingController();
  final TextEditingController _productQuantityController = TextEditingController();
  final TextEditingController _productCodeController = TextEditingController();
  final TextEditingController _productImageController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  String? imageUrl;
  bool _isLoading = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    _productNameController.text = widget.products.productName ?? '';
    _productPriceController.text = widget.products.UnitPrice ?? '';
    _productTotalController.text = widget.products.totalPrice ?? '';
    _productQuantityController.text = widget.products.qty ?? '';
    _productCodeController.text = widget.products.productCode ?? '';
    _productImageController.text = widget.products.img ?? '';

    imageUrl = widget.products.img;



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Update Data", style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formkey,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Center(
                      child: GestureDetector(
                        onTap: _showImageUrlDialog,
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade200,
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: ClipOval(
                            child: imageUrl == null
                                ? const Center(
                              child: Icon(
                                Icons.add_a_photo,
                                size: 45,
                                color: Colors.grey,
                              ),
                            )
                                : Image.network(
                              imageUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Center(
                                  child: Icon(
                                    Icons.broken_image,
                                    size: 45,
                                    color: Colors.red,
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
        
                    SizedBox(height: 16),
        
                    TextFormField(
                      controller: _productNameController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Name",
                        hintText: "Product Name",
                      ),
        
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Product Name";
                        }
                        return null;
                      },
                    ),
        
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _productPriceController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Price",
                        hintText: "Product Price",
                      ),
        
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Product Price";
                        }
                        return null;
                      },
                    ),
        
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _productTotalController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Total",
                        hintText: "Product Total",
                      ),
        
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Product Total";
                        }
                        return null;
                      },
                    ),
        
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _productQuantityController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Quantity",
                        hintText: "Product Quantity",
                      ),
        
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Product Quantity";
                        }
                        return null;
                      },
                    ),
        
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _productCodeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Product Code",
                        hintText: "Product Code",
                      ),
        
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return "Please Enter Product Code";
                        }
                        return null;
                      },
                    ),
        
        
                    SizedBox(height: 24),
        
                    ElevatedButton(
                      onPressed: _isLoading
                          ? null // 👈 loading থাকলে disable
                          : () {
                        if (_formkey.currentState!.validate()) {
                          _UpdateData(widget.products.id.toString());
                        }
                      },
        
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
        
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isLoading
                            ? SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                            : Text(
                          "Update Data",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> _UpdateData(String id) async {

    _isLoading = true; // 👈 loading start
    setState(() {
    });


    Uri url = Uri.parse("https://crud.teamrabbil.com/api/v1/UpdateProduct/$id");
    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    Map<String, dynamic> body = {
      "ProductName": _productNameController.text,
      "UnitPrice": _productPriceController.text,
      "TotalPrice": _productTotalController.text,
      "Qty": _productQuantityController.text,
      "ProductCode": _productCodeController.text,
      "Img": _productImageController.text,
    };

    Response response = await post(url, body: jsonEncode(body), headers: headers);

    print(response.body);

    _isLoading = false;
    setState(() {
    });

    if (response.statusCode == 200) {
      _clearEditText();
      Navigator.pop(context, true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data added successfully")),
      );
    }

  }

  Future<void> _showImageUrlDialog() async {

    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Image URL"),
          content: Form(
            key: _formkey,
            child: TextFormField(
              controller: _productImageController,
              decoration: const InputDecoration(
                hintText: "Enter image URL",
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return "Please enter image URL";
                }

              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState!.validate()) {
                  Navigator.pop(context, _productImageController.text.trim());
                }
              },
              child: const Text("Update Data"),
            ),
          ],
        );
      },
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        imageUrl = result;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _productNameController.dispose();
    _productPriceController.dispose();
    _productTotalController.dispose();
    _productQuantityController.dispose();
    _productCodeController.dispose();
    _productImageController.dispose();
    super.dispose();
  }
  
  void _clearEditText() {
    _productNameController.clear();
    _productPriceController.clear();
    _productTotalController.clear();
    _productQuantityController.clear();
    _productCodeController.clear();
    _productImageController.clear();
  }
  

}