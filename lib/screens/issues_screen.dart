import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:withytcode/screens/home_screen.dart';
import 'package:withytcode/widgets/single_issue.dart';

import '../model/model.dart';
import '../state/state.dart';
import 'add_issue_screen.dart';

class IssueScreen extends StatefulWidget {
  const IssueScreen({super.key});

  @override
  State<IssueScreen> createState() => _IssueScreenState();
}

class _IssueScreenState extends State<IssueScreen> {
  bool _init = true;
  bool _isLoading = false;

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (_init) {
      _isLoading = await Provider.of<CustomState>(context, listen: false)
          .getIssuesData();

      setState(() {});
    }
    _init = false;
  }

  @override
  Widget build(BuildContext context) {
    var issues = Provider.of<CustomState>(context).issue;
    return _isLoading == false || issues == null
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
                            builder: (context) => IssueScreen()));
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
              title: Text("Issues Raised"),
              actions: [
                IconButton(
                    onPressed: () => Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => HomeScreen())),
                    icon: Icon(Icons.home)),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: issues.length,
                    itemBuilder: (context, index) => SingleIssue(
                      issue: issues[index],
                    ),
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => AddIssueScreen()));
              },
              child: Icon(Icons.add),
            ),
          );
  }
}
