// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:withytcode/model/model.dart';
import 'package:withytcode/state/state.dart';

class SinglePost extends StatefulWidget {
  final Post post;
  final bool deleteOption;

  const SinglePost({
    Key? key,
    required this.post,
    required this.deleteOption,
  }) : super(key: key);

  @override
  State<SinglePost> createState() => _SinglePostState();
}

class _SinglePostState extends State<SinglePost> {
  bool showComments = false;
  final TextEditingController commentController = TextEditingController();
  String commentDesc = '';

  void _addComment() {
    if (commentController.text.length <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Empty comment"),
        duration: const Duration(seconds: 2),
      ));
      return;
    }
    Provider.of<CustomState>(context, listen: false)
        .addComment(widget.post.id!, commentController.text);
    commentController.text = '';
    setState(() {});
  }

  void deletePost(String id) async {
    bool isDeleted =
        await Provider.of<CustomState>(context, listen: false).deletePost(id);

    if (isDeleted == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Successfully deleted Post"),
        duration: const Duration(seconds: 2),
      ));
    }
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
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  image: NetworkImage(
                                      'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/${widget.post.user!.profilePicId!}.png'))),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text(
                          widget.post.user!.username!,
                          style:
                              TextStyle(fontSize: 24, color: Colors.lightBlue),
                        ),
                      ],
                    ),
                  ),
                  widget.deleteOption == true
                      ? ElevatedButton.icon(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.transparent),
                              elevation: MaterialStatePropertyAll(0)),
                          onPressed: () =>
                              deletePost(widget.post.id.toString()),
                          icon: Icon(
                            Icons.delete,
                            color: Colors.redAccent,
                          ),
                          label: Text(''))
                      : Container()
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, top: 8),
                child: Text(widget.post.description!),
              ),
              SizedBox(
                height: 16,
              ),
              widget.post.postPicture != null
                  ? GestureDetector(
                      onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: GestureDetector(
                            child: Center(
                              child: Hero(
                                tag: 'imageHero',
                                child: Image.network(
                                  widget.post.postPicture!.split('?')[0],
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
                        image: NetworkImage(
                            widget.post.postPicture!.split('?')[0]),
                      ),
                    )
                  : Container(),
              Row(
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
                          .addLike(widget.post.id!);
                    },
                    label: Text(
                        "Love (" + widget.post.likeCount!.toString() + ')'),
                    icon: Icon(widget.post.myLike!
                        ? Icons.favorite
                        : Icons.favorite_border),
                  ),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.transparent),
                        elevation: MaterialStatePropertyAll(0.0),
                        foregroundColor:
                            MaterialStatePropertyAll(Colors.black)),
                    label: Text('Comment (' +
                        widget.post.commentCount!.toString() +
                        ')'),
                    onPressed: () {
                      setState(() {
                        showComments = !showComments;
                      });
                    },
                    icon: Icon(Icons.comment),
                  ),
                ],
              ),
              showComments
                  ? Column(
                      children: [
                        TextField(
                          autofocus: true,
                          controller: commentController,
                          decoration: InputDecoration(
                            hintText: "Comment",
                            suffix: ElevatedButton.icon(
                              label: Text(''),
                              icon: Icon(Icons.send),
                              onPressed: () {
                                _addComment();
                              },
                            ),
                          ),
                        ),
                        Column(
                          children: widget.post.comments!
                              .map((comment) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                  height: 24,
                                                  width: 24,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(
                                                              'https://examplebucketbyvignesh.s3.ap-south-1.amazonaws.com/profilePics/${widget.post.user!.profilePicId!}.png'))),
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                RichText(
                                                  text: TextSpan(
                                                    text: comment
                                                            .user!.username! +
                                                        "  ",
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                          text: 'on ' +
                                                              comment
                                                                  .createdDate!,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              fontSize: 12)),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              comment.commentDescription!,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
