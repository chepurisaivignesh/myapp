import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';

import '../state/state.dart';
import '../validator.dart';

class AddIssueScreen extends StatefulWidget {
  const AddIssueScreen({super.key});

  @override
  State<AddIssueScreen> createState() => _AddIssueScreenState();
}

class _AddIssueScreenState extends State<AddIssueScreen> {
  final _addItemFormKey = GlobalKey<FormState>();
  bool _isProcessing = false;
  final TextEditingController _issueDescriptionController =
      TextEditingController();
  var _image;
  String imageUrl = '';

  void imageUpload(File file, String fileName) async {
    setState(() {
      _isProcessing = true;
    });
    LocalStorage storage = LocalStorage('usertoken');
    var token = storage.getItem('token');
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://10.0.2.2:8000/api/addImage/'));
    request.fields['title'] = 'file';
    request.fields['directory'] = 'issuePics/';
    request.headers['Authorization'] = 'token $token';

    var picture = http.MultipartFile.fromBytes('image', file.readAsBytesSync(),
        filename: fileName);

    request.files.add(picture);
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseDatajson = json.decode(String.fromCharCodes(responseData));
    setState(() {
      imageUrl = responseDatajson['imageUrl'];
      print(
        "Saved on flutter ${imageUrl}",
      );
      _isProcessing = false;
    });
  }

  void addIssue(postDesc, url) {
    Provider.of<CustomState>(context, listen: false).addIssue(postDesc, url);
    _issueDescriptionController.text = '';
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
                  controller: _issueDescriptionController,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validator: (value) => Validator.validateField(value: value!),
                  decoration: InputDecoration(
                    label: Text("Description"),
                    hintText: "Description of the Post",
                  ),
                  maxLength: 1000,
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
                          Icons.add_a_photo_rounded,
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
                _isProcessing == false
                    ? ElevatedButton(
                        onPressed: () async {
                          if (_addItemFormKey.currentState!.validate()) {
                            if (mounted) {
                              addIssue(
                                  _issueDescriptionController.text, imageUrl);

                              Navigator.of(context).pop();
                            }
                          }
                        },
                        child: Text("Submit"),
                      )
                    : CircularProgressIndicator(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
