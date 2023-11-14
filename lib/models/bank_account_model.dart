class BankAccountModel {
  dynamic id;
  String bank_name;
  String account_no;
  String stripe_id;
  int app_user_id;
  String iban;
  int status;

  BankAccountModel({required this.id, required this.account_no, required this.stripe_id, required this.bank_name, required this.app_user_id, required this.iban,required this.status});

  factory BankAccountModel.fromJson(Map<String, dynamic> json) {
    return BankAccountModel(id: json['id'].toString(),
        account_no: json['account_no'],
        stripe_id: json['stripe_id'],
        bank_name: json['bank_name'],
        app_user_id: json['app_user_id'],
        iban: json['iban'],
        status: json['status']);
  }
      // : id = json['id'],
      //   account_no = json['account_no'],
      //   bank_name = json['bank_name'],
      //   stripe_id = json['stripe_id'];

  // Map<String, dynamic> toJson() =>
  //     {
  //       'id' : id,
  //       'account_no': account_no,
  //       'stripe_id': stripe_id,
  //       'bank_name': bank_name,
  //     };
}
