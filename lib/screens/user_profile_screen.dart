import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/model/model.dart';
import 'package:withytcode/screens/home_screen.dart';
import '../validator.dart';
import '../widgets/single_post.dart';
import './login_screen.dart';

import '../state/state.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _init = true;
  bool _isLoading = false;
  bool showEditSection = false;
  int picIndex = 0;
  User userDetails = User(
      email: '', id: 0, profilePicId: 1, profilePicture: '', username: 'none');
  TextEditingController _newUserNameController = TextEditingController();
  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      _isLoading = await Provider.of<CustomState>(context, listen: false)
          .getPostData(specific: true);
      var user = await Provider.of<CustomState>(context, listen: false)
          .getCurrentUser();

      setState(() {
        userDetails = user;
      });
    }
    _init = false;
  }

  void updateUser(String newUserName, int index, String email,
      String profilePicture) async {
    var isUpdated = await Provider.of<CustomState>(context, listen: false)
        .updateUser(newUserName, index, email, profilePicture);
    if (isUpdated == true) {
      setState(() {
        showEditSection = false;
        _newUserNameController.text = '';
      });
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => UserProfileScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("There is an error updating the user")));
    }
  }

  void logoutNow() {
    LocalStorage storage = LocalStorage('usertoken');
    storage.clear();
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: ((context) => LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    var posts = Provider.of<CustomState>(context).post;
    return _isLoading == false || posts == null
        ? Scaffold(
            body: Container(
              width: MediaQuery.of(context).size.width,
              // color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  ElevatedButton(
                    onPressed: () {
                      if (mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => UserProfileScreen()));
                      }
                    },
                    child: Icon(Icons.replay_outlined),
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Profile"),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                    icon: Icon(Icons.home)),
                IconButton(
                    onPressed: () {
                      logoutNow();
                    },
                    icon: Icon(Icons.logout))
              ],
            ),
            body: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(
                                    'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/${userDetails.profilePicId}.png'))),
                      ),
                    ),
                  ),
                  Text(
                    userDetails.username!,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 36),
                  ),
                  Text(
                    userDetails.email!,
                    style: TextStyle(color: Colors.blueAccent, fontSize: 16),
                  ),
                  IconButton(
                      onPressed: () {
                        setState(() {
                          showEditSection = true;
                        });
                      },
                      icon: Icon(Icons.edit)),
                  showEditSection == true
                      ? Column(
                          children: [
                            Text("Select a Profile Picture"),
                            DropdownButton(
                                itemHeight: 150,
                                items: [
                                  DropdownMenuItem(
                                    value: 1,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/1.png'))),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 2,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/2.png'))),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 3,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/3.png'))),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 4,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/4.png'))),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 5,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/5.png'))),
                                    ),
                                  ),
                                  DropdownMenuItem(
                                    value: 6,
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/6.png'))),
                                    ),
                                  )
                                ],
                                onChanged: (value) => setState(() {
                                      value != null ? picIndex = value : null;
                                    })),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: TextFormField(
                                controller: _newUserNameController,
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                  label: Text("New Username"),
                                ),
                                maxLength: 50,
                              ),
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  updateUser(
                                      _newUserNameController.text.length != 0
                                          ? _newUserNameController.text
                                          : userDetails.username!,
                                      picIndex,
                                      userDetails.email!,
                                      userDetails.profilePicture!);
                                },
                                child: Text(
                                  "Submit",
                                ),
                                style: ButtonStyle(
                                    elevation: MaterialStatePropertyAll(0))),
                          ],
                        )
                      : Container(),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: posts.length,
                    itemBuilder: (context, index) => SinglePost(
                      deleteOption: true,
                      post: posts[index],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
