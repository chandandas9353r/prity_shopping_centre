import 'dart:io';

import 'package:clothes_shop/common/components.dart';
import 'package:clothes_shop/services/sql_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProduct extends StatefulWidget {
  final void Function(bool isDone) onTap;
  final DatabaseHelper databaseHelper;
  const AddProduct({
    super.key,
    required this.onTap,
    required this.databaseHelper,
  });
  @override
  State<AddProduct> createState() => _AddProductState();
}
class _AddProductState extends State<AddProduct>{
  String imagePath = '';
  TextEditingController nameController = TextEditingController(),
  descriptionController = TextEditingController(),
  priceController = TextEditingController();
  FocusNode nameFocus = FocusNode(),
  descriptionFocus = FocusNode(),
  priceFocus = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        margin: const EdgeInsets.all(10.0),
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 250,
                  child: (imagePath == '')
                  ? Image.asset(
                    'assets/images/no_image.jpg',
                    fit: BoxFit.contain,
                  )
                  : Image.file(
                    File(imagePath),
                    fit: BoxFit.contain,
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    XFile image = await ImagePicker().pickImage(source: ImageSource.gallery) as XFile;
                    setState(() {
                      imagePath = image.path;
                    });
                  },
                  child: const Button(text: 'Add Image',),
                ),
                CustomTextField(
                  hint: 'Product Name',
                  focusNode: nameFocus,
                  onChange: (value) => setState(() => nameController.text = value),
                ),
                CustomTextField(
                  hint: 'Product Description',
                  focusNode: descriptionFocus,
                  onChange: (value) => setState(() => descriptionController.text = value),
                ),
                CustomTextField(
                  hint: 'Product Price',
                  focusNode: priceFocus,
                  onChange: (value) => setState(() => priceController.text = value),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () async {
                      if(imagePath.isEmpty){
                        await showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            child: const Text(
                              'Add an Image',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0
                              ),
                            ),
                          );
                        },);
                        return;
                      }
                      if(nameController.text.isEmpty){
                        await showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            child: const Text(
                              'Enter Product Name',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0
                              ),
                            ),
                          );
                        },);
                        nameFocus.requestFocus();
                        return;
                      }
                      if(descriptionController.text.isEmpty){
                        await showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            child: const Text(
                              'Enter Product Description',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0
                              ),
                            ),
                          );
                        },);
                        descriptionFocus.requestFocus();
                        return;
                      }
                      if(priceController.text.isEmpty){
                        await showModalBottomSheet(context: context, builder: (context) {
                          return Container(
                            padding: const EdgeInsets.all(20.0),
                            child: const Text(
                              'Enter Product Price',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20.0
                              ),
                            ),
                          );
                        },);
                        priceFocus.requestFocus();
                        return;
                      }
                      widget.databaseHelper.insertData(
                        widget.databaseHelper.id,
                        imagePath,
                        nameController.text,
                        descriptionController.text,
                        int.parse(priceController.text)
                      );
                      widget.onTap(true);
                    },
                    child: const Button(text: 'Submit'),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                  GestureDetector(
                    onTap: () => widget.onTap(true),
                    child: Button(
                      text: 'Cancel',
                      color: Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}