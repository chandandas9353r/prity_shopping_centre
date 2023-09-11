import 'package:flutter/material.dart';

class ShowProduct extends StatefulWidget {
  final String productImageLocation, productName, productPrice;
  const ShowProduct({
    super.key,
    required this.productImageLocation,
    required this.productName,
    required this.productPrice,
  });

  @override
  State<ShowProduct> createState() => _ShowProductState();
}

class _ShowProductState extends State<ShowProduct> {
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
              Container(
                alignment: Alignment.topCenter,
                width: double.maxFinite,
                child: Image.network(
                  widget.productImageLocation,
                  fit: BoxFit.scaleDown,
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
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.red.shade200,
                          borderRadius: BorderRadius.circular(10.0)
                        ),
                        child: const Text('Add To Cart'),
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