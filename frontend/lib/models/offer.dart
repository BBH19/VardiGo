
class Offer {
  String? id;
  String? title;
  String? place;
  String? pay;
  String? logo;
  String? district;
  String? when;
  String? status;
  String? remain;
  String? expiresAt;

  Offer({
    this.id,
    this.title,
    this.place,
    this.pay,
    this.logo,
    this.district,
    this.when,
    this.status,
    this.remain,
    this.expiresAt,
  });

  Offer.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    place = json['place'];
    pay = json['pay'];
    logo = json['logo'];
    district = json['district'];
    when = json['when'];
    status = json['status'];
    remain = json['remain'];
    expiresAt = json['expiresAt'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    data['id'] = id;
    data['title'] = title;
    data['place'] = place;
    data['pay'] = pay;
    data['logo'] = logo;
    data['district'] = district;
    data['when'] = when;
    data['status'] = status;
    data['remain'] = remain;
    data['expiresAt'] = expiresAt;

    return data;
  }
}

