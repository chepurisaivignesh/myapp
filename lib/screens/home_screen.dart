import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/screens/LF_screen.dart';
import 'package:withytcode/screens/add_event_screen.dart';
import 'package:withytcode/screens/add_post_screen.dart';
import 'package:withytcode/screens/club_screen.dart';
import 'package:withytcode/screens/issues_screen.dart';
import 'package:withytcode/screens/login_screen.dart';
import 'package:withytcode/screens/user_profile_screen.dart';
import 'package:withytcode/state/state.dart';
import 'package:states_rebuilder/states_rebuilder.dart';
import 'package:withytcode/widgets/single_post.dart';

import '../model/model.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home-screen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _init = true;
  bool _isLoading = false;
  User userDetails = User(
      email: '', id: 0, profilePicId: 1, profilePicture: '', username: 'none');
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserDetails();
  }

  void getUserDetails() async {
    var user =
        await Provider.of<CustomState>(context, listen: false).getCurrentUser();
    setState(() {
      userDetails = user;
      print(user);
    });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      _isLoading = await Provider.of<CustomState>(context, listen: false)
              .getPostData(specific: false) &
          await Provider.of<CustomState>(context, listen: false)
              .getEventsData();
    }
    _init = false;
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
    var events = Provider.of<CustomState>(context).events;
    return _isLoading == false || posts == null || events == null
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
                      if (!mounted) {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => HomeScreen()));
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
              title: Text("Hi, ${userDetails.username!}"),
              actions: [
                if (userDetails.isStaff! || userDetails.isSuperuser!)
                  ElevatedButton.icon(
                    style: ButtonStyle(elevation: MaterialStatePropertyAll(0)),
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => AddEventScreen())),
                    icon: Icon(Icons.add),
                    label: Text("Event"),
                  ),
                IconButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => UserProfileScreen())),
                    icon: Icon(Icons.person)),
                IconButton(
                    onPressed: () {
                      logoutNow();
                    },
                    icon: Icon(Icons.logout)),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () => {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                IssueScreen()))
                                  },
                              child: Text(
                                "Raise an Issue",
                                style: TextStyle(fontSize: 24),
                              )),
                        ),
                        Container(
                          width: 24,
                        ),
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () => {
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) => LFScreen()))
                                  },
                              child: Text(
                                "L & F",
                                style: TextStyle(fontSize: 24),
                              )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0),
                    child: Text(
                      'Events',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemCount: events.length,
                          itemBuilder: (context, index) => AspectRatio(
                                aspectRatio: 1,
                                child: Card(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            events[index].eventName!,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'By ${events[index].host!}',
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontSize: 16),
                                          ),
                                          Text(
                                            events[index].eventDescription!,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                            overflow: TextOverflow.fade,
                                          ),
                                          Text(
                                            'On ${events[index].eventDate!}',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16),
                                          ),
                                          events[index].eventPicture != null
                                              ? Expanded(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: GestureDetector(
                                                      onTap: () => Navigator.of(
                                                              context)
                                                          .push(
                                                              MaterialPageRoute(
                                                        builder: (context) =>
                                                            Scaffold(
                                                          body: GestureDetector(
                                                            child: Center(
                                                              child: Hero(
                                                                tag:
                                                                    'imageHero',
                                                                child: Image
                                                                    .network(
                                                                  events[index]
                                                                      .eventPicture!
                                                                      .split(
                                                                          '?')[0],
                                                                ),
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                      )),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                image:
                                                                    DecorationImage(
                                                          fit: BoxFit.cover,
                                                          // image: NetworkImage(widget.post.postImageUrl!),
                                                          image: NetworkImage(
                                                              events[index]
                                                                  .eventPicture!
                                                                  .split(
                                                                      '?')[0]),
                                                        )),
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              // )
                                              : Container(),
                                        ]),
                                  ),
                                ),
                              )),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 12.0, top: 8),
                    child: Text(
                      'Posts',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 36,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: posts.length,
                    itemBuilder: (context, index) => SinglePost(
                      deleteOption: false,
                      post: posts[index],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddPostScreen()));
              },
              child: Icon(Icons.add),
            ),
          );
  }
}
