class StudentData {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? gender;
  double? lat;
  double? long;

  StudentData({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.gender,
    this.lat,
    this.long,
  });

  StudentData.fromJson(Map<String, dynamic> json) {
    id = json['id'] as int?;
    firstName = json['first_name'] as String?;
    lastName = json['last_name'] as String?;
    email = json['email'] as String?;
    gender = json['gender'] as String?;
    lat = json['lat'] as double?;
    long = json['long'] as double?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = id;
    json['first_name'] = firstName;
    json['last_name'] = lastName;
    json['email'] = email;
    json['gender'] = gender;
    json['lat'] = lat;
    json['long'] = long;
    return json;
  }
}
