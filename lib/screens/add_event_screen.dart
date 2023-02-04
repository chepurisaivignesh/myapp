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

class AddEventScreen extends StatefulWidget {
  const AddEventScreen({super.key});

  @override
  State<AddEventScreen> createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final TextEditingController _eventDescriptionController =
      TextEditingController();
  final TextEditingController _hostController = TextEditingController();
  final TextEditingController _eventNameController = TextEditingController();
  var _image;
  String imageUrl = '';
  DateTime selectedDate = DateTime(2023, 1, 1, 0, 0);

  void imageUpload(File file, String fileName) async {
    LocalStorage storage = LocalStorage('usertoken');
    var token = storage.getItem('token');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/addImage/'));
    request.fields['title'] = 'file';
    request.fields['directory'] = 'eventPics/';

    request.headers['Authorization'] = 'token $token';

    var picture = http.MultipartFile.fromBytes('image', file.readAsBytesSync(),
        filename: fileName);

    request.files.add(picture);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseDatajson = json.decode(String.fromCharCodes(responseData));
    setState(() {
      if (responseDatajson['imageUrl'] != null) {
        imageUrl = responseDatajson['imageUrl'];
      }
      _isProcessing = false;
    });
  }

  void addEvent(host, eventName, eventDescription, dateOfEvent, imageUrl) {
    Provider.of<CustomState>(context, listen: false).addEvent(
      eventDescription,
      eventName,
      host,
      dateOfEvent,
      imageUrl,
    );
    _eventDescriptionController.text = '';
    _eventNameController.text = '';
    _hostController.text = '';
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Event"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _addItemFormKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: _hostController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Host Name"),
                    hintText: "Name of the Host",
                  ),
                  maxLength: 1000,
                ),
                TextFormField(
                  controller: _eventNameController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Event Name"),
                    hintText: "Name of the Event",
                  ),
                  maxLength: 1000,
                ),
                TextFormField(
                  controller: _eventDescriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Event Description"),
                    hintText: "Description to share",
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
                      _isProcessing = true;
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
                      _isProcessing = false;
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
                        _isProcessing = true;
                      });
                      addEvent(
                          _hostController.text,
                          _eventNameController.text,
                          _eventDescriptionController.text,
                          selectedDate,
                          imageUrl);
                      setState(() {
                        _isProcessing = false;
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
