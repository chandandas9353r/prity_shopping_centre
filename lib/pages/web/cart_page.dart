import 'dart:convert';

import 'package:clothes_shop/services/storage_service.dart';
import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  final LocalStorage localStorage;
  const CartPage({
    super.key,
    required this.localStorage,
  });

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<String>? items = [];

  @override
  void initState(){
    super.initState();
    items = widget.localStorage.getItems;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: (items == null)
        ? const Center(
          child: Text('No Products'),
        )
        : ListView.separated(
          itemCount: items?.length as int,
          separatorBuilder: (context, index) {
            return const Divider();
          },
          itemBuilder: (context, index) {
            Map<String,String> data = Map.from(jsonDecode(items?.elementAtOrNull(index) as String));
            return Container(
              margin: const EdgeInsets.all(10.0),
              padding: const EdgeInsets.all(10.0),
              width: double.maxFinite,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                    child: Image.network(
                      data['image'] as String,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 100,
                      padding: const EdgeInsets.all(10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['name'] as String),
                            Text(data['price'] as String),
                          ],
                        ),
                    ),
                  ),
                ],
              ),
            );
          },
        )
      ),
    );
  }
}