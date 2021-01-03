import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart' as storage;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/providers/products_provider.dart';

class EditProduct extends StatefulWidget {
  static const routName = '/editproduct';
  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  //final pricefocusnode = FocusNode();
  //final descfocusnode = FocusNode();
  // final imageUrlController = TextEditingController();
  // final imagefocusnode = FocusNode();
  final form = GlobalKey<FormState>();
  //String _filename;
  File _image;
  bool uploading = false;

  final picker = ImagePicker();
  static String imageUrl;
  var initvalues = {
    'id': '',
    'title': '',
    'description': '',
    'price': '',
    'imgurl': ''
  };
  bool isinit = true;
  var editedProduct =
      Product(id: null, title: '', description: '', imagUrl: '', price: 0);
  bool isloading = false;

  getimage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      _image = File(pickedFile.path);
      // print(_image.path);
    });
  }

  Future<void> uploadImageToFirebase() async {
    //print('inittt ${initvalues['id']}');
    String fileName = path.basename(_image.path);

    storage.Reference firebaseStorageRef =
        storage.FirebaseStorage.instance.ref().child(fileName);

    storage.UploadTask uploadTask = firebaseStorageRef.putFile(_image);

    await (await uploadTask).ref.getDownloadURL().then((value) {
      setState(() {
        print("Done: $value");
        imageUrl = value;
      });
      // storage.TaskSnapshot taskSnapshot = await uploadTask;
      // taskSnapshot.ref.getDownloadURL().then((value) {
      //   setState(() {
      //     print("Done: $value");
      //     imageUrl = value;
      //     // return value;
      //     print('urlllll gwa$imageUrl');
      //   });
    });
  }

  @override
  void dispose() {
    //imageUrlController.dispose();
    // pricefocusnode.dispose();
    // descfocusnode.dispose();
    // imagefocusnode.dispose();
    // imagefocusnode.removeListener(updateimageurl);
    super.dispose();
  }

  @override
  void initState() {
    //imageUrlController.addListener(updateimageurl);

    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isinit) {
      final productId = ModalRoute.of(context).settings.arguments as String;
      if (productId != null) {
        editedProduct = Provider.of<Products>(context).finbyId(productId);
        initvalues = {
          'id': productId,
          'title': editedProduct.title,
          'description': editedProduct.description,
          'price': editedProduct.price.toString(),
          'imgurl': editedProduct.imagUrl
        };
        //  imageUrlController.text = editedProduct.imagUrl;
      }
    }
    isinit = false;

    super.didChangeDependencies();
  }

  void updateimageurl() {
    // if (!imagefocusnode.hasFocus) {
    //   if ((!imageUrlController.text.startsWith('http') &&
    //           !imageUrlController.text.startsWith('https')) ||
    //       (!imageUrlController.text.endsWith('.png') &&
    //           !imageUrlController.text.endsWith('.jpg') &&
    //           !imageUrlController.text.endsWith('.jpeg'))) {
    //     return;
    //   }
    //   setState(() {});
    // }
  }
  Future<void> saveform() async {
    final isvalid = form.currentState.validate();
    if (!isvalid) {
      return;
    }

    form.currentState.save();

    setState(() {
      uploading = true;
    });
    _image != null ? await uploadImageToFirebase() : print('no image selected');
    print('urllll $imageUrl');
    setState(() {
      uploading = false;
    });
    editedProduct = Product(
        id: editedProduct.id,
        isFavorite: editedProduct.isFavorite,
        title: editedProduct.title,
        description: editedProduct.description,
        imagUrl: imageUrl,
        price: editedProduct.price);

    if (mounted)
      setState(() {
        isloading = true;
      });

    if (editedProduct.id != null) {
      await Provider.of<Products>(context, listen: false)
          .updateProduct(editedProduct.id, editedProduct);
    } else {
      try {
        await Provider.of<Products>(context, listen: false)
            .addProduct(editedProduct);
      } catch (e) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('An error occurred !'),
                  content: Text('Something Went Wrong'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          print('gwa el alert');
                          Navigator.pop(context);
                        },
                        child: Text('Ok'))
                  ],
                ));
      }
      // finally {
      //   print('gwa el finally');
      //   setState(() {
      //     isloading = false;
      //   });
      //   Navigator.pop(context);
      // }
    }
    setState(() {
      isloading = false;
    });
    Navigator.pop(context);
  }

  // Future<void> upload() async {
  //   setState(() {
  //     uploading = true;
  //   });
  //   uploadImageToFirebase();

  //   setState(() {
  //     uploading = false;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final prodId = ModalRoute.of(context).settings.arguments as String;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit Product'),
          actions: [
            Container(
              child: uploading
                  ? Center(child: CircularProgressIndicator())
                  : IconButton(
                      icon: Icon(
                        Icons.save,
                      ),
                      onPressed: () {
                        saveform();
                      }),
            )
          ],
        ),
        body: isloading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                    key: form,
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: initvalues['title'],
                          decoration: InputDecoration(
                            labelText: 'Title',
                          ),
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (_) {
                            // FocusScope.of(context).requestFocus(pricefocusnode);
                          },
                          onSaved: (value) {
                            editedProduct = Product(
                                id: editedProduct.id,
                                isFavorite: editedProduct.isFavorite,
                                title: value,
                                description: editedProduct.description,
                                imagUrl: editedProduct.imagUrl,
                                price: editedProduct.price);
                          },
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter a title.';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          initialValue: initvalues['price'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter a price.';
                            }
                            if (double.tryParse(value) == null) {
                              return 'please enter a valid number';
                            }
                            if (double.tryParse(value) <= 0) {
                              return 'please enter a number greater than zero.';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Price'),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.number,
                          //  focusNode: pricefocusnode,
                          onFieldSubmitted: (_) {
                            //      FocusScope.of(context).requestFocus(descfocusnode);
                          },
                          onSaved: (value) {
                            editedProduct = Product(
                                id: editedProduct.id,
                                isFavorite: editedProduct.isFavorite,
                                title: editedProduct.title,
                                description: editedProduct.description,
                                imagUrl: editedProduct.imagUrl,
                                price: double.parse(value));
                          },
                        ),
                        TextFormField(
                          initialValue: initvalues['description'],
                          validator: (value) {
                            if (value.isEmpty) {
                              return 'please enter a description.';
                            }
                            if (value.length < 10) {
                              return 'should be at least 10 characters long';
                            }
                            return null;
                          },
                          decoration: InputDecoration(labelText: 'Description'),
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.next,
                          //  focusNode: descfocusnode,
                          onSaved: (value) {
                            editedProduct = Product(
                                id: editedProduct.id,
                                isFavorite: editedProduct.isFavorite,
                                title: editedProduct.title,
                                description: value,
                                imagUrl: editedProduct.imagUrl,
                                price: editedProduct.price);
                          },
                        ),
                        // Row(
                        //   crossAxisAlignment: CrossAxisAlignment.end,
                        //   children: [
                        //     Padding(
                        //       padding: const EdgeInsets.only(top: 9, right: 10),
                        //       child: Container(
                        //         width: 100,
                        //         height: 100,
                        //         decoration: BoxDecoration(
                        //             border: Border.all(
                        //                 width: 1, color: Colors.grey)),
                        //         child: imageUrlController.text.isEmpty
                        //             ? Center(child: Text('Enter URL'))
                        //             : FittedBox(
                        //                 child: Image.network(
                        //                   imageUrlController.text,
                        //                   fit: BoxFit.cover,
                        //                 ),
                        //               ),
                        //       ),
                        //     ),
                        //     Expanded(
                        //       child: TextFormField(
                        //         validator: (value) {
                        //           if (value.isEmpty) {
                        //             return 'Please enter an image URL.';
                        //           }
                        //           if (!value.startsWith('http') &&
                        //               !value.startsWith('https')) {
                        //             return 'Please enter a valid URL.';
                        //           }
                        //           if (!value.endsWith('.png') &&
                        //               !value.endsWith('.jpg') &&
                        //               !value.endsWith('.jpeg')) {
                        //             return 'Please enter a valid image URL.';
                        //           }
                        //           return null;
                        //         },
                        //         decoration:
                        //             InputDecoration(labelText: 'Image URL'),
                        //         keyboardType: TextInputType.url,
                        //         textInputAction: TextInputAction.done,
                        //         controller: imageUrlController,
                        //         focusNode: imagefocusnode,
                        //         onFieldSubmitted: (_) => saveform(),
                        //         onSaved: (value) {
                        //           editedProduct = Product(
                        //               id: editedProduct.id,
                        //               isFavorite: editedProduct.isFavorite,
                        //               title: editedProduct.title,
                        //               description: editedProduct.description,
                        //               imagUrl: value,
                        //               price: editedProduct.price);
                        //         },
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: AssetImage(
                                          'assets/images/imagepick.jpg'),
                                      fit: BoxFit.fill)),
                              height: 100,
                              width: 100,
                              child: InkWell(
                                onTap: getimage,
                                child: Image(
                                  image: prodId != null
                                      ? _image == null
                                          ? NetworkImage(editedProduct.imagUrl)
                                          : FileImage(File(_image.path))
                                      : _image == null
                                          ? AssetImage(
                                              'assets/images/imagepick.jpg')
                                          : FileImage(File(_image.path)),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
              ),
      ),
    );
  }
}
