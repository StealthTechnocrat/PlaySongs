
class Transaction {
  bool? status;
  String? message;
  dynamic totalAmount;
  dynamic totalEarning;
  List<Transactions>? transactions;
  List<AdminTransactions>? adminTransactions;

  Transaction(
      {this.status,
      this.message,
      this.totalAmount,
      this.totalEarning,
      this.transactions,
      this.adminTransactions});

  Transaction.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalAmount = json['total_amount'];
    totalEarning = json['total_earning'];
    if (json['transactions'] != null) {
      transactions = <Transactions>[];
      json['transactions'].forEach((v) {
        transactions!.add(Transactions.fromJson(v));
      });
    }
    if (json['admin_transactions'] != null) {
      adminTransactions = <AdminTransactions>[];
      json['admin_transactions'].forEach((v) {
        adminTransactions!.add(AdminTransactions.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['total_amount'] = totalAmount;
    data['total_earning'] = totalEarning;
    if (transactions != null) {
      data['transactions'] = transactions!.map((v) => v.toJson()).toList();
    }
    if (adminTransactions != null) {
      data['admin_transactions'] =
          adminTransactions!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Transactions {
  int? appUserId;
  String? paymentType;
  dynamic djPart;
  dynamic totalAmount;
  int? id;
  String? createdAt;
  String? name;
  int? usedCredit;
  String? song;
  String? venue;

  Transactions(
      {this.appUserId,
      this.paymentType,
      this.djPart,
      this.totalAmount,
      this.id,
      this.createdAt,
      this.name,
        this.song,
        this.venue,
      this.usedCredit});

  Transactions.fromJson(Map<String, dynamic> json) {
    appUserId = json['app_user_id'];
    paymentType = json['payment_type'];
    djPart = json['dj_part'];
    totalAmount = json['total_amount'];
    id = json['id'];
    createdAt = json['created_at'];
    name = json['name'];
    usedCredit = json['used_credit'];
    venue = json['venue'];
    song = json['song'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['app_user_id'] = appUserId;
    data['payment_type'] = paymentType;
    data['dj_part'] = djPart;
    data['total_amount'] = totalAmount;
    data['id'] = id;
    data['created_at'] = createdAt;
    data['name'] = name;
    data['used_credit'] = usedCredit;
    return data;
  }
}

class AdminTransactions {
  int? id;
  int? appUserId;
  String? amount;
  String? transactionId;
  String? accountNo;
  String? bankName;
  String? createdAt;
  String? updatedAt;

  AdminTransactions(
      {this.id,
      this.appUserId,
      this.amount,
      this.transactionId,
      this.accountNo,
      this.bankName,
      this.createdAt,
      this.updatedAt});

  AdminTransactions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    appUserId = json['app_user_id'];
    amount = json['amount'];
    transactionId = json['transaction_id'];
    accountNo = json['account_no'];
    bankName = json['bank_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['app_user_id'] = appUserId;
    data['amount'] = amount;
    data['transaction_id'] = transactionId;
    data['account_no'] = accountNo;
    data['bank_name'] = bankName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}
