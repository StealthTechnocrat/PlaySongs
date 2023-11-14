class RequestedSong {
  bool? status;
  List<RequestList>? requestList;

  RequestedSong({this.status, this.requestList});

  RequestedSong.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['request_list'] != null) {
      requestList = <RequestList>[];
      json['request_list'].forEach((v) {
        requestList!.add(RequestList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (requestList != null) {
      data['request_list'] = requestList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RequestList {
  int? priceOfThisSong;
  String? status;
  String? song;
  String? requestedOn;
  int? clubId;
  String? clubName;
  String? clubAddress;
  double? clubLat;
  double? clubLon;
  String? avatar;
  int? userId;
  String? userName;
  String? userEmail;
  String? userPhone;

  RequestList(
      {this.priceOfThisSong,
      this.status,
      this.song,
      this.requestedOn,
      this.clubId,
      this.clubName,
      this.clubAddress,
      this.clubLat,
      this.clubLon,
      this.avatar,
      this.userId,
      this.userName,
      this.userEmail,
      this.userPhone});

  RequestList.fromJson(Map<String, dynamic> json) {
    priceOfThisSong = json['price_of_this_song'];
    status = json['status'];
    song = json['song'];
    requestedOn = json['requested_on'];
    clubId = json['club_id'];
    clubName = json['club_name'];
    clubAddress = json['club_address'];
    clubLat = json['club_lat'];
    clubLon = json['club_lon'];
    avatar = json['avatar'];
    userId = json['user_id'];
    userName = json['user_name'];
    userEmail = json['user_email'];
    userPhone = json['user_phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price_of_this_song'] = priceOfThisSong;
    data['status'] = status;
    data['song'] = song;
    data['requested_on'] = requestedOn;
    data['club_id'] = clubId;
    data['club_name'] = clubName;
    data['club_address'] = clubAddress;
    data['club_lat'] = clubLat;
    data['club_lon'] = clubLon;
    data['avatar'] = avatar;
    data['user_id'] = userId;
    data['user_name'] = userName;
    data['user_email'] = userEmail;
    data['user_phone'] = userPhone;
    return data;
  }
}