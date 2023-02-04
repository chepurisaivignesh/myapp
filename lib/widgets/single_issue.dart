// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:provider/provider.dart';

import '../model/model.dart';
import '../state/state.dart';

class SingleIssue extends StatefulWidget {
  final Issue issue;
  SingleIssue({
    Key? key,
    required this.issue,
  }) : super(key: key);

  @override
  State<SingleIssue> createState() => _SingleIssueState();
}

class _SingleIssueState extends State<SingleIssue> {
  User userDetails = User(
      email: '', id: 0, profilePicId: 1, profilePicture: '', username: 'none');

  void deleteIssue(int id) async {
    bool isDeleted =
        await Provider.of<CustomState>(context, listen: false).deleteIssue(id);

    if (isDeleted == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully deleted Post"),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    var user =
        await Provider.of<CustomState>(context, listen: false).getCurrentUser();

    setState(() {
      userDetails = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 4,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/${widget.issue.user!.profilePicId!}.png'))),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.issue.user!.username!,
                          style:
                              TextStyle(fontSize: 24, color: Colors.lightBlue),
                        ),
                        ElevatedButton.icon(
                            style: ButtonStyle(
                                elevation: MaterialStatePropertyAll(0),
                                backgroundColor: MaterialStatePropertyAll(
                                    Colors.transparent)),
                            onPressed: () => deleteIssue(widget.issue.id!),
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            label: Text('')),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: Text(widget.issue.description!),
              ),
              SizedBox(
                height: 16,
              ),
              widget.issue.pic != null
                  ? GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: GestureDetector(
                            child: Center(
                              child: Hero(
                                tag: 'imageHero',
                                child: Image.network(
                                  widget.issue.pic!.split('?')[0],
                                ),
                              ),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      )),
                      child: Image(
                        width: double.infinity,
                        // image: NetworkImage(widget.post.postImageUrl!),
                        image: NetworkImage(widget.issue.pic!.split('?')[0]),
                      ),
                    )
                  : Container(),
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        elevation: MaterialStatePropertyAll(0.0),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    onPressed: () {
                      Provider.of<CustomState>(context, listen: false)
                          .addSupportReaction(widget.issue.id!);
                    },
                    label: Text("Support (" +
                        widget.issue.supportCount!.toString() +
                        ')'),
                    icon: Icon(widget.issue.mySupport!
                        ? Icons.do_not_touch
                        : Icons.back_hand),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.issue.user!.isStaff! == true ||
                      widget.issue.user!.isSuperuser! == true)
                    ElevatedButton.icon(
                        onPressed: () => deleteIssue(widget.issue.id!),
                        icon: Icon(Icons.thumb_up),
                        label: Text("Solved!")),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
