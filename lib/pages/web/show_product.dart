import 'dart:convert';

import 'package:clothes_shop/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShowProduct extends StatefulWidget {
  final String productImageLocation, productName, productPrice;
  final LocalStorage localStorage;
  const ShowProduct({
    super.key,
    required this.productImageLocation,
    required this.productName,
    required this.productPrice,
    required this.localStorage,
  });

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
  SharedPreferences? _sharedPreferences;

  @override
  void initState(){
    super.initState();
    _initialise;
  }

  get _initialise async {
    if(_sharedPreferences != null) return;
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                  alignment: Alignment.topCenter,
                  width: double.maxFinite,
                  child: Image.network(
                    widget.productImageLocation,
                    fit: BoxFit.scaleDown,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Text(widget.productName),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(widget.productPrice),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () async {
                            String currentData = jsonEncode({
                              'image' : widget.productImageLocation,
                              'name' : widget.productName,
                              'price' : widget.productPrice,
                            });
                            List<String> totalDataAsList = await widget.localStorage.getItems ?? [];
                            totalDataAsList.add(currentData);
                            await _sharedPreferences?.setStringList('item', totalDataAsList);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.red.shade200,
                              borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: const Text('Add To Cart'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(10.0),
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.green.shade400,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: const Text('Buy Now'),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}