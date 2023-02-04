class Post {
  int? id;
  String? description;
  String? createdDate;
  int? likeCount;
  int? commentCount;
  String? postPicture;
  User? user;
  bool? myLike;
  List<Comments>? comments;

  Post(
      {this.id,
      this.description,
      this.createdDate,
      this.likeCount,
      this.commentCount,
      this.postPicture,
      this.user,
      this.myLike,
      this.comments});

  Post.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    createdDate = json['createdDate'];
    likeCount = json['likeCount'];
    commentCount = json['commentCount'];
    postPicture = json['postPicture'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    myLike = json['myLike'];
    if (json['comments'] != null) {
      comments = <Comments>[];
      json['comments'].forEach((v) {
        comments!.add(new Comments.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['createdDate'] = this.createdDate;
    data['likeCount'] = this.likeCount;
    data['commentCount'] = this.commentCount;
    data['postPicture'] = this.postPicture;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['myLike'] = this.myLike;
    if (this.comments != null) {
      data['comments'] = this.comments!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class User {
  int? id;
  String? username;
  String? email;
  String? profilePicture;
  int? profilePicId;
  bool? isStaff;
  bool? isSuperuser;

  User(
      {this.id,
      this.username,
      this.email,
      this.profilePicture,
      this.profilePicId,
      this.isStaff,
      this.isSuperuser});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    profilePicture = json['profilePicture'];
    profilePicId = json['profilePicId'];
    isStaff = json['is_staff'];
    isSuperuser = json['is_superuser'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['email'] = this.email;
    data['profilePicture'] = this.profilePicture;
    data['profilePicId'] = this.profilePicId;
    data['is_staff'] = this.isStaff;
    data['is_superuser'] = this.isSuperuser;
    return data;
  }
}

class Comments {
  int? id;
  String? commentDescription;
  String? createdDate;
  User? user;
  int? post;

  Comments(
      {this.id,
      this.commentDescription,
      this.createdDate,
      this.user,
      this.post});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    commentDescription = json['commentDescription'];
    createdDate = json['createdDate'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    post = json['post'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['commentDescription'] = this.commentDescription;
    data['createdDate'] = this.createdDate;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['post'] = this.post;
    return data;
  }
}

class Club {
  int? id;
  List<User>? heads;
  List<User>? members;
  List<User>? supervisingFaculty;
  String? name;
  String? description;
  String? websiteLink;
  String? imagesDirectory;

  Club(
      {this.id,
      this.heads,
      this.members,
      this.supervisingFaculty,
      this.name,
      this.description,
      this.websiteLink,
      this.imagesDirectory});

  Club.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    if (json['heads'] != null) {
      heads = <User>[];
      json['heads'].forEach((v) {
        heads!.add(new User.fromJson(v));
      });
    }
    if (json['members'] != null) {
      members = <User>[];
      json['members'].forEach((v) {
        members!.add(new User.fromJson(v));
      });
    }
    if (json['supervising_faculty'] != null) {
      supervisingFaculty = <User>[];
      json['supervising_faculty'].forEach((v) {
        supervisingFaculty!.add(new User.fromJson(v));
      });
    }
    name = json['name'];
    description = json['description'];
    websiteLink = json['websiteLink'];
    imagesDirectory = json['images_directory'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.heads != null) {
      data['heads'] = this.heads!.map((v) => v.toJson()).toList();
    }
    if (this.members != null) {
      data['members'] = this.members!.map((v) => v.toJson()).toList();
    }
    if (this.supervisingFaculty != null) {
      data['supervising_faculty'] =
          this.supervisingFaculty!.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['description'] = this.description;
    data['websiteLink'] = this.websiteLink;
    data['images_directory'] = this.imagesDirectory;
    return data;
  }
}

class Event {
  int? id;
  String? host;
  String? eventName;
  String? eventDescription;
  String? eventDate;
  String? eventPicture;

  Event(
      {this.id,
      this.host,
      this.eventName,
      this.eventDescription,
      this.eventDate,
      this.eventPicture});

  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    host = json['host'];
    eventName = json['eventName'];
    eventDescription = json['eventDescription'];
    eventDate = json['eventDate'];
    eventPicture = json['eventPicture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['host'] = this.host;
    data['eventName'] = this.eventName;
    data['eventDescription'] = this.eventDescription;
    data['eventDate'] = this.eventDate;
    data['eventPicture'] = this.eventPicture;
    return data;
  }
}

class LFitem {
  int? id;
  String? description;
  String? contact;
  String? pic;
  String? lostDate;
  String? location;
  User? user;

  LFitem(
      {this.id,
      this.description,
      this.contact,
      this.pic,
      this.lostDate,
      this.location,
      this.user});

  LFitem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    contact = json['contact'];
    pic = json['pic'];
    lostDate = json['lostDate'];
    location = json['location'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['contact'] = this.contact;
    data['pic'] = this.pic;
    data['lostDate'] = this.lostDate;
    data['location'] = this.location;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    return data;
  }
}

class Issue {
  int? id;
  String? description;
  String? pic;
  bool? isSolved;
  String? createdDate;
  int? supportCount;
  User? user;
  bool? mySupport;

  Issue(
      {this.id,
      this.description,
      this.pic,
      this.isSolved,
      this.createdDate,
      this.supportCount,
      this.user,
      this.mySupport});

  Issue.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    description = json['description'];
    pic = json['pic'];
    isSolved = json['isSolved'];
    createdDate = json['createdDate'];
    supportCount = json['supportCount'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    mySupport = json['mySupport'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['description'] = this.description;
    data['pic'] = this.pic;
    data['isSolved'] = this.isSolved;
    data['createdDate'] = this.createdDate;
    data['supportCount'] = this.supportCount;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    data['mySupport'] = this.mySupport;
    return data;
  }
}
