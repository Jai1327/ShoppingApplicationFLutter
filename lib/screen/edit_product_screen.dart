import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/product.dart';
import '../provider/products_provider.dart';

class EditProductScreen extends StatefulWidget {
  // const EditProductScreen({Key? key}) : super(key: key);

  static const routename = '/editProduct';

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageURLController = TextEditingController();
  final _imageURLFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedProduct = Product(
    id: '',
    description: '',
    imageURL: '',
    price: 0,
    title: '',
  );

  var _isLoading = false;

  // a map to store the values saved
  // this focus node can be assigned to a text field widget

  var _isInit = true;
  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageURL': ''
  };

  @override
  void initState() {
    // TODO: implement initState
    _imageURLFocusNode.addListener(updateImageURL);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // this is run before build
    if (_isInit) {
      final ProductID = ModalRoute.of(context)?.settings.arguments == null
          ? null
          : ModalRoute.of(context)!.settings.arguments as String;
      if (ProductID != null) {
        _editedProduct =
            Provider.of<ProductsP>(context, listen: false).getbyId(ProductID);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
          'imageURL': '',
        };
        _imageURLController.text = _editedProduct.imageURL;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
  }

  void updateImageURL() {
    if (!_imageURLFocusNode.hasFocus) {
      if (_imageURLController.text.isEmpty ||
          (!_imageURLController.text.startsWith('http') &&
              !_imageURLController.text.startsWith('https')) ||
          (!_imageURLController.text.endsWith('.png') &&
              !_imageURLController.text.endsWith('.jpg') &&
              !_imageURLController.text.endsWith('.jpeg'))) {
        return;
      }

      setState(
        () {},
      );
    }
  }

  void dispose() {
    _imageURLFocusNode.removeListener(updateImageURL);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageURLController.dispose();
    _imageURLFocusNode.dispose();
  }

  Future<void> _saveForm() async {
    final isValidated = _form.currentState!.validate();
    // the above returns a bool value hence
    if (!isValidated) {
      return;
    }
    _form.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    if (_editedProduct.id != '') {
      await Provider.of<ProductsP>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
    } else {
      Provider.of<ProductsP>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError(
        (error) {
          return showDialog<void>(
              //added this <void> as we wanted to use the future
              context: context,
              builder: (ctx) => AlertDialog(
                    title: const Text("An Error occured"),
                    content: const Text("Something Went Wrong"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Okay!'))
                    ],
                  ));
        },
      ).then(
        (_) {
          setState(() {
            _isLoading = false;
          });
          Navigator.of(context).pop();
        },
      );
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        actions: [
          IconButton(
            onPressed: _saveForm,
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: _initValues['title'],
                      decoration: const InputDecoration(
                        label: Text('Title'),
                      ),
                      textInputAction: TextInputAction.next,
                      // shows with the bottom right button in the soft keyboard
                      // will show
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      // this will fire once the bottom right button is pressed
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            price: _editedProduct.price,
                            title: value.toString());
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        }
                        return null;
                      },
                      // validator takes the value as the input
                      // and returns a string
                      //
                    ),
                    TextFormField(
                      initialValue: _initValues['price'],
                      decoration: const InputDecoration(
                        label: Text('Price'),
                      ),
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context)
                            .requestFocus(_descriptionFocusNode);
                      },
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            description: _editedProduct.description,
                            imageURL: _editedProduct.imageURL,
                            price: double.parse(value!),
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a value.';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Enter a valid number';
                          // check for invalid numbers
                        }
                        if (double.parse(value) <= 0) {
                          return 'Enter a valid price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['description'],
                      decoration: const InputDecoration(
                        label: Text('Description'),
                      ),

                      focusNode: _descriptionFocusNode,
                      maxLines: 3,
                      keyboardType: TextInputType.multiline,
                      // multiline automatically gives an enter symbol
                      onSaved: (value) {
                        _editedProduct = Product(
                            id: _editedProduct.id,
                            isFavourite: _editedProduct.isFavourite,
                            description: value.toString(),
                            imageURL: _editedProduct.imageURL,
                            price: _editedProduct.price,
                            title: _editedProduct.title);
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a description.';
                        }
                        // if(value.length < 10){
                        //   return 'Enter minimum 10 characters '
                        // }
                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // for th preview of the image uploaded
                        Container(
                          width: 100,
                          height: 100,
                          margin: const EdgeInsets.only(top: 8, right: 10),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.grey),
                          ),
                          child: _imageURLController.text.isEmpty
                              ? const Text("Enter URL")
                              : FittedBox(
                                  child: Image.network(
                                    _imageURLController.text,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                            // initialValue: _initValues['imageURL'],
                            decoration: const InputDecoration(
                              label: Text('Image URL'),
                            ),
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.url,
                            controller: _imageURLController,
                            focusNode: _imageURLFocusNode,
                            onFieldSubmitted: (_) {
                              _saveForm();
                            },
                            onSaved: (value) {
                              _editedProduct = Product(
                                  id: _editedProduct.id,
                                  isFavourite: _editedProduct.isFavourite,
                                  description: _editedProduct.description,
                                  imageURL: value.toString(),
                                  price: _editedProduct.price,
                                  title: _editedProduct.title);
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter an Image URL.';
                              }
                              if (!value.startsWith('http') &&
                                  !value.startsWith('https')) {
                                return 'Enter a valid Image URL';
                              }
                              if (!value.endsWith('.png') &&
                                  !value.endsWith('.jpg') &&
                                  !value.endsWith('.jpeg')) {
                                return 'Enter a valid Image URL';
                              }
                              return null;
                            },
                          ),
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
