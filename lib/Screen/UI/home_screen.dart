import 'dart:convert';

import 'package:curd_tudo/Models/product.dart';
import 'package:curd_tudo/Screen/UI/update_data.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../Wedget/shimmer.dart';
import 'add_Data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String name = "home_screen";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Product> productList = [];
  final Product product = Product();

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _DataFetch();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Crud Home", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: isLoading
          ? buildShimmer()
          : productList.isEmpty
          ? Center(
              child: Lottie.asset(
                'assets/lottie/no_data.json', // 👈 তোমার lottie file
                width: 300,
                height: 300,
              ),
            )
          : RefreshIndicator(
              onRefresh: _DataFetch,
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  final product = productList[index];
                  return Column(
                    children: [
                      Dismissible(
                        key: Key(index.toString()),

                        // 👉 Background (Right swipe = Delete)
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.delete, color: Colors.white),
                        ),

                        // 👉 Secondary background (Left swipe = Edit)
                        secondaryBackground: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Icon(Icons.edit, color: Colors.white),
                        ),

                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // 👉 Right swipe (Delete)
                            _DeleteData(product.id.toString(), context);
                            return true; // remove item
                          } else {
                            // 👉 Left swipe (Edit)
                            //Navigator.pushNamed(context, UpdateData.name);

                            _EditData(index);


                            return false; // don't remove item
                          }
                        },

                        child: ListTile(


                          leading: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.grey[200],
                            child: product.img != null
                                ? ClipOval(
                              child: Image.network(
                                product.img!,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.broken_image,
                                    color: Colors.red,
                                  );
                                },
                              ),
                            )
                                : const Icon(
                              Icons.broken_image,
                              color: Colors.red,
                            ),
                          ),

                          subtitle: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.productName ?? 'N/A'),
                                Text(product.totalPrice ?? 'N/A'),
                                Text(product.UnitPrice ?? 'N/A'),
                                Text(product.productCode ?? 'N/A'),
                                Text(product.qty ?? 'N/A'),
                                Text(formatDate(product.createdDate ?? 'N/A')),
                              ],
                            ),
                          ),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: () {
                                  // Navigator push করে argument পাঠাচ্ছি

                                  _EditData(index);
                                },
                                icon: Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  _DeleteData(product.id.toString(), context);
                                },
                                icon: Icon(Icons.delete),
                                color: Colors.red,
                              ),
                            ],
                          ),
                          onTap: () {},
                        ),
                      ),






                      // 👉 Divider
                      Divider(height: 1),
                    ],
                  );
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,

        onPressed: () async {
          final result = await Navigator.pushNamed(context, AddData.name);

          if (result == true) {
            _DataFetch();
          }
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Future<void> _DataFetch() async {
    productList.clear();
    isLoading = true;
    setState(() {});

    Uri url = Uri.parse("https://crud.teamrabbil.com/api/v1/ReadProduct");
    Response response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['status']);

      for (Map<String, dynamic> i in data['data']) {
        Product products = Product(
          id: i['_id'],
          img: i['Img'],
          productName: i['ProductName'],
          totalPrice: i['TotalPrice'],
          UnitPrice: i['UnitPrice'],
          productCode: i['ProductCode'],
          qty: i['Qty'],
          createdDate: i['CreatedDate'],
        );
        productList.add(products);
      }
      isLoading = false;
      setState(() {});
    } else
      print("Error");
  }

  Future<void> _DeleteData(String id, BuildContext context) async {
    Uri url = Uri.parse("https://crud.teamrabbil.com/api/v1/DeleteProduct/$id");
    Response response = await get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print(data['status']);
      print(data['data']['deletedCount']);

      if (data['status'] == 'success' && data['data']['deletedCount'] == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Product deleted successfully")),
        );

        await _DataFetch();
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Delete failed")));
      }
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Server error")));
    }
  }


  Future<void> _EditData (int index) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateData(
          products: productList[index], // যেই product update করতে চাও
          onUpdate: (updatedProduct) {
            setState(() {
              productList[index] = updatedProduct; // Home screen refresh
            });
          },
        ),
      ),
    );

    // যদি update successful হয়, পুরো list fetch করতে চাও
    if (result == true) {
      _DataFetch();
    }
  }



}

String formatDate(String? date) {
  if (date == null) return 'N/A';
  DateTime parsedDate = DateTime.parse(date);
  return DateFormat('dd MMM yyyy, hh:mm a').format(parsedDate);
}




