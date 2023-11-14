class NotificationModel {
  bool? status;
  List<Notifications>? notifications;

  NotificationModel({this.status, this.notifications});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['notifications'] != null) {
      notifications = <Notifications>[];
      json['notifications'].forEach((v) {
        notifications!.add(Notifications.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (notifications != null) {
      data['notifications'] =
          notifications!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Notifications {
  int? id;
  int? appUserId;
  String? text;
  String? uniqueKey;
  Payload? payload;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;

  Notifications(
      {this.id,
      this.appUserId,
      this.text,
      this.uniqueKey,
      this.payload,
      this.createdAt,
      this.updatedAt,
      this.deletedAt});

  Notifications.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appUserId = json['app_user_id'];
    text = json['text'];
    uniqueKey = json['unique_key'];
    payload =
        json['payload'] != null ? Payload.fromJson(json['payload']) : null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_user_id'] = appUserId;
    data['text'] = text;
    data['unique_key'] = uniqueKey;
    if (payload != null) {
      data['payload'] = payload!.toJson();
    }
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    return data;
  }
}

class Payload {
  int? id;
  int? requestedBy;
  dynamic requestedTo;
  int? eventId;
  String? status;
  String? song;
  String? validTill;
  String? createdAt;
  String? updatedAt;

  Payload(
      {this.id,
      this.requestedBy,
      this.requestedTo,
      this.eventId,
      this.status,
      this.song,
      this.validTill,
      this.createdAt,
      this.updatedAt});

  Payload.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    requestedBy = json['requested_by'];
    requestedTo = json['requested_to'];
    eventId = json['event_id'];
    status = json['status'];
    song = json['song'];
    validTill = json['valid_till'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['requested_by'] = requestedBy;
    data['requested_to'] = requestedTo;
    data['event_id'] = eventId;
    data['status'] = status;
    data['song'] = song;
    data['valid_till'] = validTill;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
