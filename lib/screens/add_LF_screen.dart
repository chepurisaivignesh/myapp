import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/model/model.dart';
import 'package:withytcode/state/state.dart';
import '../validator.dart';
import 'package:http/http.dart' as http;

import 'package:localstorage/localstorage.dart';

class AddLFScreen extends StatefulWidget {
  const AddLFScreen({super.key});

  @override
  State<AddLFScreen> createState() => _AddLFScreenState();
}

class _AddLFScreenState extends State<AddLFScreen> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcesssing = false;

  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  var _image;
  String imageUrl = '';
  DateTime selectedDate = DateTime(2023, 1, 1, 0, 0);

  void imageUpload(File file, String fileName) async {
    LocalStorage storage = LocalStorage('usertoken');
    var token = storage.getItem('token');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/addImage/'));
    request.fields['title'] = 'file';
    request.fields['directory'] = 'LFpics/';

    request.headers['Authorization'] = 'token $token';

    var picture = http.MultipartFile.fromBytes('image', file.readAsBytesSync(),
        filename: fileName);

    request.files.add(picture);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseDatajson = json.decode(String.fromCharCodes(responseData));
    setState(() {
      imageUrl = responseDatajson['imageUrl'];
    });
  }

  void addLFitem(desc, contact, lostDate, imageUrl, location) {
    Provider.of<CustomState>(context, listen: false)
        .addLFItem(desc, contact, lostDate, imageUrl, location);
    _descriptionController.text = '';
    _contactController.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Post"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addItemFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _descriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Description"),
                    hintText: "Add details of the item you lost",
                  ),
                  maxLength: 1000,
                ),
                TextFormField(
                  controller: _locationController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Location"),
                    hintText: "Specify location where you lost",
                  ),
                  maxLength: 1000,
                ),
                TextFormField(
                  controller: _contactController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Contact"),
                    hintText: "Enter the contact number",
                  ),
                  maxLength: 1000,
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime(2023, 1, 1),
                    onDateTimeChanged: (DateTime newDateTime) {
                      setState(() {
                        selectedDate = newDateTime;
                      });
                    },
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      _isProcesssing = true;
                    });
                    ImagePicker imagePicker = ImagePicker();
                    var file = await imagePicker.pickImage(
                        source: ImageSource.gallery);

                    if (file == null) return;
                    setState(() {
                      _image = File(file.path);
                    });

                    String uniqueFileName =
                        DateTime.now().toIso8601String().toString();
                    // uploadImage(_image, uniqueFileName);
                    imageUpload(_image, uniqueFileName);
                    setState(() {
                      _isProcesssing = false;
                    });
                  },
                  child: _image == null
                      ? Icon(
                          Icons.camera_alt,
                        )
                      : AspectRatio(
                          aspectRatio: 1,
                          child: Container(
                            color: Colors.transparent,
                            child: Image.file(_image),
                          ),
                        ),
                ),
                SizedBox(
                  height: 20,
                ),
                _image != null
                    ? Text(
                        "Image is selected and ready to submit.",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "No Image is selected.",
                        style: TextStyle(color: Colors.red),
                      ),
                if (_image != null)
                  ElevatedButton.icon(
                    onPressed: () {
                      setState(() {
                        _image = null;
                      });
                    },
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    label: Text("Delete image"),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    if (_addItemFormKey.currentState!.validate()) {
                      setState(() {
                        _isProcesssing = true;
                      });
                      addLFitem(
                          _descriptionController.text,
                          _contactController.text,
                          selectedDate,
                          imageUrl,
                          _locationController.text);
                      setState(() {
                        _isProcesssing = false;
                      });
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("Post"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
