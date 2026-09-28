
class Candidate {
  String? id;
  String? name;
  String? rating;
  String? attend;
  String? km;
  String? photo;
  bool? online;
  bool? perfect;
  int? score;

  Candidate({
    this.id,
    this.name,
    this.rating,
    this.attend,
    this.km,
    this.photo,
    this.online,
    this.perfect,
    this.score,
  });

  Candidate.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    rating = json['rating'];
    attend = json['attend'];
    km = json['km'];
    photo = json['photo'];
    online = json['online'];
    perfect = json['perfect'];
    score = json['score'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['name'] = name;
    data['rating'] = rating;
    data['attend'] = attend;
    data['km'] = km;
    data['photo'] = photo;
    data['online'] = online;
    data['perfect'] = perfect;
    data['score'] = score;

    return data;
  }
}

