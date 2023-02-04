import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:withytcode/model/model.dart';
import 'package:localstorage/localstorage.dart';
import 'package:intl/intl.dart';

class CustomState with ChangeNotifier {
  LocalStorage storage = LocalStorage('usertoken');

  List<Post> _posts = [];
  List<Club> _clubs = [];
  List<Event> _events = [];
  List<LFitem> _lfitems = [];
  List<Issue> _issues = [];

  Future<bool> getPostData({bool specific = false}) async {
    try {
      var token = storage.getItem('token');
      String url = specific
          ? "http://10.0.2.2:8000/api/specificPosts/"
          : "http://10.0.2.2:8000/api/posts/";
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});
      var data = json.decode(response.body) as List;

      List<Post> temp = [];
      data.forEach((element) {
        Post post = Post.fromJson(element);
        temp.add(post);
      });
      _posts = temp;

      notifyListeners();
      return true;
    } catch (e) {
      print("getPostData error");
      print(e);
      return false;
    }
  }

  List<Post>? get post {
    if (_posts != null) {
      return [..._posts];
    }
    return null;
  }

  Future<void> addLike(int id) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addLike/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
        body: json.encode(
          {
            'id': id,
          },
        ),
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getPostData();
      }
    } catch (e) {
      print("addLike error");
      print(e);
    }
  }

  Future<void> addComment(int postId, commentText) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addComment/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
        body: json.encode(
          {'postId': postId, 'commentText': commentText},
        ),
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getPostData();
      }
    } catch (e) {
      print("addComment error");
      print(e);
    }
  }

  Future<bool> loginNow(String username, String password) async {
    try {
      String url = 'http://10.0.2.2:8000/api/login/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
        },
        body: json.encode(
          {'username': username, 'password': password},
        ),
      );
      var data = json.decode(response.body) as Map;
      if (data.containsKey('token')) {
        storage.setItem('token', data['token']);
        return false;
      }
    } catch (e) {
      print('login error');
      print(e);
      return false;
    }
    return true;
  }

  Future<void> addPost(String issueDescription, String imageUrl) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addPost/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'issueDescription': issueDescription, 'imageUrl': imageUrl},
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getPostData();
      }
    } catch (e) {
      print('add Post error');
      print(e);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/getCurrentUser/';
      http.Response response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );

      var data = json.decode(response.body);
      print(data);
      if (data['error'] == false) {
        return User.fromJson(data['userDetails']);
      }
      return User(
          email: '',
          id: 0,
          profilePicId: 1,
          profilePicture: '',
          username: 'none',
          isStaff: false,
          isSuperuser: false);
    } catch (e) {
      print("get Current User error");
      print(e);
      return User(
          email: '',
          id: 0,
          profilePicId: 1,
          profilePicture: '',
          username: 'none',
          isStaff: false,
          isSuperuser: false);
    }
  }

  Future<bool> getClubsData() async {
    try {
      var token = storage.getItem('token');
      var url = "http://10.0.2.2:8000/api/getClubs/";
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});
      print(response.body);
      var response_data = json.decode(response.body) as Map<String, dynamic>;
      var data = response_data['clubdetails'] as List;

      print(data);

      List<Club> temp = [];
      data.forEach((element) {
        Club club = Club.fromJson(element);
        temp.add(club);
      });
      _clubs = temp;

      notifyListeners();
      return true;
    } catch (e) {
      print("getClubsData error");
      print(e);
      return false;
    }
  }

  List<Club>? get clubs {
    if (_clubs != null) {
      return [..._clubs];
    }
    return null;
  }

  Future<bool> getEventsData() async {
    try {
      var token = storage.getItem('token');
      var url = "http://10.0.2.2:8000/api/getEvents/";
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});
      // print(response.body);
      var response_data = json.decode(response.body) as Map<String, dynamic>;
      var data = response_data['events'] as List;

      // print(data);

      List<Event> temp = [];
      data.forEach((element) {
        Event event = Event.fromJson(element);
        temp.add(event);
      });
      _events = temp;

      notifyListeners();
      return true;
    } catch (e) {
      print("getEventsData error");
      print(e);
      return false;
    }
  }

  List<Event>? get events {
    if (_clubs != null) {
      return [..._events];
    }
    return null;
  }

  Future<void> addEvent(String eventDescription, String eventName, String host,
      DateTime dateOfEvent, String imageUrl) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addEvent/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'host': host,
            'imageUrl': imageUrl,
            'eventName': eventName,
            'eventDescription': eventDescription,
            'eventDate': DateFormat('yyyy-MM-dd').format(dateOfEvent)
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getEventsData();
      }
    } catch (e) {
      print('add Event error');
      print(e);
    }
  }

  Future<bool> getLFItemsData() async {
    try {
      var token = storage.getItem('token');
      var url = "http://10.0.2.2:8000/api/getLFitems/";
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});
      print(response.body);
      var response_data = json.decode(response.body) as Map<String, dynamic>;
      var data = response_data['items'] as List;

      print(data);

      List<LFitem> temp = [];
      data.forEach((element) {
        LFitem tempLFitem = LFitem.fromJson(element);
        temp.add(tempLFitem);
      });
      _lfitems = temp;

      notifyListeners();
      return true;
    } catch (e) {
      print("getEventsData error");
      print(e);
      return false;
    }
  }

  List<LFitem>? get lfitems {
    if (_clubs != null) {
      return [..._lfitems];
    }
    return null;
  }

  Future<void> addLFItem(String description, String contact, DateTime lostDate,
      String imageUrl, String location) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addLFitem/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'imageUrl': imageUrl,
            'contact': contact,
            'description': description,
            'location': location,
            'lostDate': DateFormat('yyyy-MM-dd').format(lostDate)
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getLFItemsData();
      }
    } catch (e) {
      print('add LFitem error');
      print(e);
    }
  }

  Future<bool> deletePost(
    String id,
  ) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/deletePost/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'id': id,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getPostData(specific: true);
      }
      return true;
    } catch (e) {
      print('post Delete error');
      print(e);
      return false;
    }
  }

  Future<dynamic> updateUser(String username, int profilePicId, String email,
      String profilePicture) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/updateUser/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'username': username,
            'profilePicId': profilePicId,
            'profilePicture': profilePicture,
            'email': email
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getCurrentUser();
        return true;
      }
      return false;
    } catch (e) {
      print('add LFitem error');
      print(e);
      return false;
    }
  }

  Future<bool> deleteLFitem(
    int id,
  ) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/deleteLFitem/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'id': id,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getPostData(specific: true);
      }
      return true;
    } catch (e) {
      print('LF item Delete error');
      print(e);
      return false;
    }
  }

  Future<bool> getIssuesData() async {
    try {
      var token = storage.getItem('token');
      String url = "http://10.0.2.2:8000/api/getIssues/";
      http.Response response = await http
          .get(Uri.parse(url), headers: {'Authorization': 'token $token'});
      var data = json.decode(response.body) as List;

      List<Issue> temp = [];
      data.forEach((element) {
        Issue issue = Issue.fromJson(element);
        temp.add(issue);
      });
      _issues = temp;

      notifyListeners();
      return true;
    } catch (e) {
      print("getIssuesData error");
      print(e);
      return false;
    }
  }

  List<Issue>? get issue {
    if (_issues != null) {
      return [..._issues];
    }
    return null;
  }

  Future<void> addSupportReaction(int id) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/showSupport/';
      http.Response response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
        body: json.encode(
          {
            'id': id,
          },
        ),
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getIssuesData();
      }
    } catch (e) {
      print("addSupportReaction error");
      print(e);
    }
  }

  Future<void> addIssue(String issueDescription, String imageUrl) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/addIssue/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {'issueDescription': issueDescription, 'imageUrl': imageUrl},
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getIssuesData();
      }
    } catch (e) {
      print('add Issue error');
      print(e);
    }
  }

  Future<bool> deleteIssue(
    int id,
  ) async {
    try {
      var token = storage.getItem('token');
      String url = 'http://10.0.2.2:8000/api/deleteIssueItem/';
      http.Response response = await http.post(
        Uri.parse(url),
        body: json.encode(
          {
            'id': id,
          },
        ),
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'token $token'
        },
      );
      var data = json.decode(response.body);
      if (data['error'] == false) {
        getIssuesData();
      }
      return true;
    } catch (e) {
      print('issue Delete error');
      print(e);
      return false;
    }
  }
}
