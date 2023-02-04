import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/screens/home_screen.dart';
import 'package:withytcode/state/state.dart';
import '../model/model.dart';
import 'add_LF_screen.dart';

class LFScreen extends StatefulWidget {
  @override
  State<LFScreen> createState() => _LFScreenState();
}

class _LFScreenState extends State<LFScreen> {
  bool _init = true;
  bool _isLoading = false;
  User userDetails = User(
      email: '', id: 0, profilePicId: 1, profilePicture: '', username: 'none');

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      _isLoading = await Provider.of<CustomState>(context, listen: false)
          .getLFItemsData();

      userDetails = await Provider.of<CustomState>(context, listen: false)
          .getCurrentUser();
      setState(() {});
    }
    _init = false;
  }

  void deleteLFitem(idToBeDeleted) async {
    var isDeleted = await Provider.of<CustomState>(context, listen: false)
        .deleteLFitem(idToBeDeleted);
    if (isDeleted) {
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) => LFScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("There is an error")));
    }
  }

  @override
  Widget build(BuildContext context) {
    var items = Provider.of<CustomState>(context).lfitems;
    return _isLoading == false || items == null
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
                            builder: (context) => LFScreen()));
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
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        ),
                    icon: Icon(Icons.home))
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: 48,
                                          width: 48,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/${items[index].user!.profilePicId!}.png'))),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Text(
                                          items[index].user!.username!,
                                          style: TextStyle(
                                            color: Colors.lightBlueAccent,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 16),
                                      child: Text(
                                        items[index].description!,
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 4),
                                      child: Text(
                                        'At ${items[index].location!}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 4),
                                      child: Text(
                                        'On ${items[index].lostDate!}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, top: 4),
                                      child: Text(
                                        'Contact Details: ${items[index].contact!}',
                                        style: TextStyle(
                                          color: Colors.lightBlueAccent,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    items[index].pic != null
                                        ? AspectRatio(
                                            aspectRatio: 1,
                                            child: GestureDetector(
                                              onTap: () => Navigator.of(context)
                                                  .push(MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                  body: GestureDetector(
                                                    child: Center(
                                                      child: Hero(
                                                        tag: 'imageHero',
                                                        child: Image.network(
                                                          items[index]
                                                              .pic!
                                                              .split('?')[0]
                                                              .split('?')[0],
                                                        ),
                                                      ),
                                                    ),
                                                    onTap: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              )),
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                    image:
                                                        // image: NetworkImage(widget.post.postImageUrl!),
                                                        NetworkImage(
                                                            items[index]
                                                                .pic!
                                                                .split('?')[0]),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(),
                                    userDetails.id == items[index].user!.id!
                                        ? ElevatedButton(
                                            onPressed: () =>
                                                deleteLFitem(items[index].id),
                                            child: Text("Found"),
                                            style: ButtonStyle(
                                                elevation:
                                                    MaterialStatePropertyAll(
                                                        0)),
                                          )
                                        : Container()
                                  ],
                                ),
                              ),
                            ),
                          )),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddLFScreen()));
              },
              child: Icon(Icons.add),
            ),
          );
  }
}
