class MyStats {
  bool? status;
  int? noRequested;
  int? noAccepted;
  int? noRejected;
  int? noPlacesVisited;
  int? totalAmount;

  MyStats(
      {this.status,
      this.noRequested,
      this.noAccepted,
      this.noRejected,
      this.noPlacesVisited,
      this.totalAmount});

  MyStats.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    noRequested = json['no_requested'];
    noAccepted = json['no_accepted'];
    noRejected = json['no_rejected'];
    noPlacesVisited = json['no_places_visited'];
    totalAmount = json['total_amount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['status'] = status;
    data['no_requested'] = noRequested;
    data['no_accepted'] = noAccepted;
    data['no_rejected'] = noRejected;
    data['no_places_visited'] = noPlacesVisited;
    data['total_amount'] = totalAmount;
    return data;
  }
}