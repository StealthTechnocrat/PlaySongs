class VisitedVenue {
  bool? status;
  List<VisitedVenues>? visitedVenues;

  VisitedVenue({this.status, this.visitedVenues});

  VisitedVenue.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['visited_venues'] != null) {
      visitedVenues = <VisitedVenues>[];
      json['visited_venues'].forEach((v) {
        visitedVenues!.add(VisitedVenues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (visitedVenues != null) {
      data['visited_venues'] =
          visitedVenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class VisitedVenues {
  int? clubId;
  String? clubName;
  String? address;
  double? lat;
  double? lon;
  String? lastVisitedOn;
  int? numPlayed;
  int? numRejected;
  int? totalRequests;
  int? totalEarnings;

  VisitedVenues(
      {this.clubId,
      this.clubName,
      this.address,
      this.lat,
      this.lon,
      this.lastVisitedOn,
      this.numPlayed,
      this.numRejected,
      this.totalRequests,
      this.totalEarnings});

  VisitedVenues.fromJson(Map<String, dynamic> json) {
    clubId = json['club_id'];
    clubName = json['club_name'];
    address = json['address'];
    lat = json['lat'];
    lon = json['lon'];
    lastVisitedOn = json['last_visited_on'];
    numPlayed = json['num_played'];
    numRejected = json['num_rejected'];
    totalRequests = json['total_requests'];
    totalEarnings = json['total_earnings'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['club_id'] = clubId;
    data['club_name'] = clubName;
    data['address'] = address;
    data['lat'] = lat;
    data['lon'] = lon;
    data['last_visited_on'] = lastVisitedOn;
    data['num_played'] = numPlayed;
    data['num_rejected'] = numRejected;
    data['total_requests'] = totalRequests;
    data['total_earnings'] = totalEarnings;
    return data;
  }
}
