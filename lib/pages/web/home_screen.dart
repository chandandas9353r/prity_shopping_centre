// import 'package:clothes_shop/pages/web/all_products.dart';

import 'package:clothes_shop/pages/web/cart_page.dart';
import 'package:clothes_shop/pages/web/show_product.dart';
import 'package:clothes_shop/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoading = true;
  int crossAxisCount = 2;
  double childAspectRatio = 1;
  LocalStorage localStorage = LocalStorage();
  @override
  void initState(){
    super.initState();
    setState(() => isLoading = true);
    Future.delayed(
      const Duration(seconds: 1),
      () => setState(() => isLoading = false),
    );
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
          child: GridView.builder(
            itemCount: 10,
            padding: const EdgeInsets.all(10.0),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              childAspectRatio: childAspectRatio,
            ),
            itemBuilder: (context, index) {
              int price = Random().nextInt(100);
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
                                productImageLocation: 'https://raw.githubusercontent.com/chandandas9353r/prity_shopping_centre/master/assets/images/no_image.jpg',
                                productName: 'PRODUCT ${index+1}',
                                productPrice: '₹${price.toString()}',
                                localStorage: localStorage,
                              ),
                            ),
                          );
                        },
                        child: Image.network('https://raw.githubusercontent.com/chandandas9353r/prity_shopping_centre/master/assets/images/no_image.jpg'),
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
                            'PRODUCT ${index+1}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Stack(
                          children: [
                            Text(
                              '₹${price.toString()}',
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
          ),
        ),
      );
    }
  }
}