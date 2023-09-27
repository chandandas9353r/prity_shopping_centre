import 'package:clothes_shop/services/sql_service.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class AllProducts extends StatefulWidget {
  final DatabaseHelper databaseHelper;
  final void Function(int index) onSuccess;
  const AllProducts({
    super.key,
    required this.databaseHelper,
    required this.onSuccess,
  });
  @override
  State<AllProducts> createState() => _AllProductsState();
}

class _AllProductsState extends State<AllProducts>{
  FirebaseDatabase database = FirebaseDatabase.instance..databaseURL = 'https://prity-shopping-centre-default-rtdb.asia-southeast1.firebasedatabase.app/';
  int? id;

  @override
  void initState() {
    super.initState();
  }

  _checkData() async {
    DatabaseReference ref = database.ref('products/');
    DataSnapshot data = await ref.get();
    if(!mounted) return;
    setState(() => id = data.children.length);
    widget.onSuccess(id as int);
    return data.children.toList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _checkData(),
      builder: (context, snapshot) {
        if(id == 0) {
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
          itemCount: id,
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
                      child: Image.network((((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['image'].toString()),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Text((((snapshot.data as List).elementAtOrNull(index) as DataSnapshot).value as Map<Object?,Object?>)['title'].toString()),
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