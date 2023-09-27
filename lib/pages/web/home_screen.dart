// import 'package:clothes_shop/pages/web/all_products.dart';

import 'package:clothes_shop/pages/web/cart_page.dart';
import 'package:clothes_shop/pages/web/show_product.dart';
import 'package:clothes_shop/services/storage_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  int crossAxisCount = 2;
  int? id;
  double childAspectRatio = 1;
  LocalStorage localStorage = LocalStorage();
  FirebaseApp? app = Firebase.app();
  FirebaseDatabase database = FirebaseDatabase.instance..databaseURL = 'https://prity-shopping-centre-default-rtdb.asia-southeast1.firebasedatabase.app/';

  @override
  void initState(){
    super.initState();
    setState(() => isLoading = true);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() => isLoading = false),
    );
  }

  _checkData() async {
    DatabaseReference ref = database.ref('products/');
    DataSnapshot data = await ref.get();
    if(!mounted) return;
    setState(() => id = data.children.length);
    return data.children.toList();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    crossAxisCount = (width > 800) ? (width > 1280) ? 5 : 3 : 2;
    childAspectRatio = (width > 800) ? 1.25 : 1.25;
    if(isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          actions: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartPage(
                        localStorage: localStorage,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: const Icon(Icons.shopping_cart_outlined),
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: FutureBuilder(
            future: _checkData(),
            builder: (context, snapshot) {
              if(id == 0) {
                return Center(
                  child: Text(
                    'No Products',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 30.0,
                    ),
                  ),
                );
              }
              return (snapshot.hasData)
              ? GridView.builder(
                itemCount: id,
                padding: const EdgeInsets.all(10.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                  childAspectRatio: childAspectRatio,
                ),
                itemBuilder: (context, index) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ShowProduct(
                                    productImageLocation: (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['image'].toString(),
                                    productName: (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['title'].toString(),
                                    productPrice: (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['price'].toString(),
                                    localStorage: localStorage,
                                  ),
                                ),
                              );
                            },
                            child: Image.network(
                              (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['image'].toString(),
                              fit: BoxFit.scaleDown,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        color: Colors.blue,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              child: Text(
                                (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['title'].toString(),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Stack(
                              children: [
                                Text(
                                  (((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['price'].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              )
              : const Center(
                child: CircularProgressIndicator(),
              );
            }
          ),
        ),
      );
    }
  }
}