import 'package:clothes_shop/common/components.dart';
import 'package:clothes_shop/pages/android/add_product.dart';
import 'package:clothes_shop/pages/android/all_products.dart';
import 'package:clothes_shop/pages/android/nav_bar.dart';
import 'package:clothes_shop/pages/android/show_cart.dart';
import 'package:clothes_shop/services/sql_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<IconData> items = [
    Icons.home,
    Icons.add,
    Icons.shopping_cart,
  ];
  String currentPage = 'home';
  bool isAddingProduct = false;
  DatabaseHelper databaseHelper = DatabaseHelper();
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(isAddingProduct) {
          setState((){isAddingProduct = false;});
          return false;
        }
        else if(currentPage == 'cart') {
          setState((){currentPage = 'home';});
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(isAddingProduct ? 'ADD PRODUCT' : currentPage == 'home' ? 'HOME' : 'CART'),
          centerTitle: true,
          leading: (currentPage == 'cart' && !isAddingProduct)
          ? GestureDetector(
            onTap: () => setState(() => currentPage = 'home'),
            child: const SizedBox(
              child: Icon(Icons.arrow_back),
            ),
          )
          : null,
          actions: [
            GestureDetector(
              onTap: () async {
                await showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return Container(
                      padding: const EdgeInsets.all(20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Expanded(
                            child: Text(
                              'Delete all products',
                              style: TextStyle(
                                fontSize: 20.0,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  await databaseHelper.deleteData;
                                  if(!mounted) return;
                                  setState(() {});
                                  Navigator.pop(context);
                                },
                                child: const Button(text: 'YES'),
                              ),
                              GestureDetector(
                                onTap: () => Navigator.pop(context),
                                child: Button(
                                  text: 'NO',
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Icon(Icons.delete_forever_outlined),
              ),
            ),
          ],
        ),
        extendBody: true,
        body: SafeArea(
          child: (!isAddingProduct)
          ? Stack(
            children: [
              Column(
                children: [
                  if(currentPage == 'home') Flexible(
                    child: AllProducts(
                      databaseHelper: databaseHelper,
                    ),
                  ),
                  if(currentPage == 'cart') const Flexible(
                    child: ShowCart(),
                  ),
                  NavBar(
                    items: items,
                    currentPage: currentPage,
                    onTap: (selectedPage, addPage) => setState(() {
                      currentPage = selectedPage;
                      isAddingProduct = addPage;
                    },),
                  ),
                ],
              ),
            ],
          )
          : AddProduct(
            onTap: (isDone) => setState(() {
              if(isDone) isAddingProduct = false;
            }),
            databaseHelper: databaseHelper,
          ),
        ),
      ),
    );
  }
}