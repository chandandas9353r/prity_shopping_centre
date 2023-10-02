import 'dart:convert';

import 'package:clothes_shop/common/components.dart';
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
  bool isBuying = false;
  int totalPrice = 0;
  FocusNode nameFocus = FocusNode(), mobileFocus = FocusNode();
  TextEditingController nameController = TextEditingController(),
      mobileController = TextEditingController();
  Widget? centerCard;

  @override
  void initState() {
    super.initState();
    getItems();
  }

  Future<void> getItems() async {
    items = await widget.localStorage.getItems;
    if (!mounted) return;
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
              : Stack(
                  children: [
                    ListView.separated(
                      itemCount: items?.length as int,
                      separatorBuilder: (context, index) {
                        return const Divider();
                      },
                      itemBuilder: (context, index) {
                        Map<String, String> data = Map.from(jsonDecode(
                            items?.elementAtOrNull(index) as String));
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                    ),
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            items?.forEach((element) {
                              final data = json.decode(element);
                              totalPrice += int.parse(data['price']);
                            });
                            setState(() {
                              isBuying = true;
                              centerCard = centerWidget();
                            });
                          },
                          child: Container(
                            padding: EdgeInsets.all(
                                MediaQuery.of(context).size.width * 0.02),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(
                                  MediaQuery.of(context).size.width * 0.01),
                            ),
                            child: const Text(
                              'BUY NOW',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isBuying) centerCard ?? Container(),
                  ],
                )),
    );
  }

  Widget centerWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black45,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              height: 10.0,
            ),
            CustomTextField(
              hint: 'Your Name',
              focusNode: nameFocus,
              onChange: (value) => setState(() => nameController.text = value),
            ),
            CustomTextField(
              hint: 'Your Mobile Number',
              focusNode: mobileFocus,
              onChange: (value) =>
                  setState(() => mobileController.text = value),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price: $totalPrice'),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      if (nameController.text.isEmpty) {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              child: const Text(
                                'Enter Your Name',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            );
                          },
                        );
                        nameFocus.requestFocus();
                        return;
                      }
                      if (mobileController.text.isEmpty) {
                        await showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return Container(
                              padding: const EdgeInsets.all(20.0),
                              child: const Text(
                                'Enter Your Mobile Number',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 20.0),
                              ),
                            );
                          },
                        );
                        mobileFocus.requestFocus();
                        return;
                      }
                      await Future.delayed(
                          const Duration(seconds: 3), () {
                            centerCard = thanksPageWidget();
                            if(!mounted) return;
                            setState(() {});
                          });
                    },
                    child: const Button(text: 'ORDER', color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget thanksPageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.black45,
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * .8,
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.03,
            vertical: MediaQuery.of(context).size.height * 0.01),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(MediaQuery.of(context).size.width * 0.01),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.network(
              'assets/images/thanks.png',
              width: MediaQuery.of(context).size.width * 0.3,
            ),
            const Text(
              'Orders Placed Successfully',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Button(text: 'MY ORDERS'),
          ],
        ),
      ),
    );
  }
}
