import 'dart:io';

import 'package:clothes_shop/services/sql_service.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  const AllProducts({
    super.key,
    required this.databaseHelper,
  });
  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts>{
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.databaseHelper.getData,
      builder: (context, snapshot) {
        if(snapshot.data?.isEmpty == true) {
          return Center(
          child: Text(
            'No Products',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 30.0,
            ),
          ),
        );
        }
        return (snapshot.hasData)
        ? GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemCount: snapshot.data?.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.all(10.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,
                )]
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                      alignment: Alignment.center,
                      child: Image.file(File(snapshot.data?.elementAtOrNull(index)?['image'] as String)),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(snapshot.data?.elementAtOrNull(index)?['name'].toString() as String),
                  ),
                ],
              ),
            );
          },
        )
        : const Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }
}