import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/state.dart';
import 'home_screen.dart';

class ClubsScreen extends StatefulWidget {
  ClubsScreen({super.key});

  @override
  State<ClubsScreen> createState() => _ClubsScreenState();
}

class _ClubsScreenState extends State<ClubsScreen> {
  bool _init = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      _isLoading =
          await Provider.of<CustomState>(context, listen: false).getClubsData();
      setState(() {});
    }
    _init = false;
  }

  @override
  Widget build(BuildContext context) {
    var clubs = Provider.of<CustomState>(context).clubs;
    return _isLoading == false || clubs == null
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
                            builder: (context) => ClubsScreen()));
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
              title: Text("Welcome"),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                    icon: Icon(Icons.home)),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: clubs.length,
                        itemBuilder: (context, index) => Card(
                              color: Colors.grey,
                              child: Column(
                                children: [
                                  Text(
                                    clubs[index].name!,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Heads",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: clubs[index].heads?.length,
                                      itemBuilder: (context, memberindex) =>
                                          Container(
                                        color: Colors.greenAccent,
                                        child: Column(children: [
                                          Text(clubs[index]
                                              .heads![memberindex]
                                              .username!)
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Members",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: clubs[index].members?.length,
                                      itemBuilder: (context, memberindex) =>
                                          Container(
                                        color: Colors.orangeAccent,
                                        child: Column(children: [
                                          Text(clubs[index]
                                              .members![memberindex]
                                              .username!)
                                        ]),
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "Faculty Mentor",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: clubs[index]
                                          .supervisingFaculty
                                          ?.length,
                                      itemBuilder: (context, memberindex) =>
                                          Container(
                                        color: Colors.yellowAccent,
                                        child: Column(children: [
                                          Text(clubs[index]
                                              .supervisingFaculty![memberindex]
                                              .username!)
                                        ]),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                  ),
                ],
              ),
            ),
          );
  }
}
