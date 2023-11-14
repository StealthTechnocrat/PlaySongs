class User {
  var userId;
  var email;
  var name;
  var type;
  var avatar;

  User({this.userId, this.name, this.email, this.type, this.avatar});

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        userId = json['id'],
        email = json['email'],
        avatar = json['avatar'],
        type = json['type'];

  Map<String, dynamic> toJson() => {
        'id': userId,
        'name': name,
        'email': email,
        'type': type,
        'avatar': avatar,
      };
}
