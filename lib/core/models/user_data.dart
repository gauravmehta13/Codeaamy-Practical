class UserData {
  String? profilePic;
  String? name;
  String? emailId;

  UserData({
    this.profilePic,
    this.name,
    this.emailId,
  });

  UserData.fromJson(Map<String, dynamic> json) {
    profilePic = json['profile_pic'] as String?;
    name = json['name'] as String?;
    emailId = json['email_id'] as String?;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['profile_pic'] = profilePic;
    json['name'] = name;
    json['email_id'] = emailId;
    return json;
  }
}
