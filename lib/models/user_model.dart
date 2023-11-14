class UserDetailsModel {
  bool? status;
  String? message;
  User? user;

  UserDetailsModel({this.status, this.message, this.user});

  UserDetailsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    user = json['user'] != null ? User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (user != null) {
      data['user'] = user!.toJson();
    }
    return data;
  }
}

class User {
  int? id;
  String? name;
  String? email;
  String? phone;
  String? stripeId;
  String? countryCode;
  String? avatar;
  int? status;
  int? isMobileNoVerified;
  int? maxNumRequest;
  String? lastLoggedOn;
  String? ip;
  String? qrCode;
  String? type;
  String? bio;
  int? amountPerRequest;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  int? creditBalance;

  User({
    this.id = 0,
    this.name = '',
    this.email = '',
    this.stripeId = '',
    this.phone = '',
    this.countryCode = '',
    this.avatar = '',
    this.status = 0,
    this.isMobileNoVerified = 0,
    this.maxNumRequest = 0,
    this.lastLoggedOn = '',
    this.ip = '',
    this.qrCode = '',
    this.type = '',
    this.bio = '',
    this.amountPerRequest = 0,
    this.createdAt = '',
    this.updatedAt = '',
    this.deletedAt = '',
    this.creditBalance = 0,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    stripeId = json['stripe_id'];
    phone = json['phone'];
    countryCode = json['country_code'];
    avatar = json['avatar'];
    status = json['status'];
    isMobileNoVerified = json['is_mobile_no_verified'];
    maxNumRequest = json['max_num_request'];
    lastLoggedOn = json['last_logged_on'];
    ip = json['ip'];
    qrCode = json['qr_code'];
    type = json['type'];
    bio = json['bio'];
    amountPerRequest = json['amount_per_request'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    creditBalance = json['credit_balance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['email'] = email;
    data['phone'] = phone;
    data['country_code'] = countryCode;
    data['avatar'] = avatar;
    data['status'] = status;
    data['is_mobile_no_verified'] = isMobileNoVerified;
    data['max_num_request'] = maxNumRequest;
    data['last_logged_on'] = lastLoggedOn;
    data['ip'] = ip;
    data['qr_code'] = qrCode;
    data['type'] = type;
    data['bio'] = bio;
    data['amount_per_request'] = amountPerRequest;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['credit_balance'] = creditBalance;
    return data;
  }
}
