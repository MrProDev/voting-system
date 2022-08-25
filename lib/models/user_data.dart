class UserData {
  String? uid;
  String? email;
  String? name;
  String? constituency;
  String? cnic;
  String? imageUrl;
  String? userType;
  bool? hasVoted;

  UserData({
    required this.uid,
    required this.email,
    required this.name,
    required this.constituency,
    required this.cnic,
    required this.imageUrl,
    required this.userType,
    required this.hasVoted,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) => UserData(
        name: json!["name"],
        constituency: json["constituency"],
        cnic: json["cnic"],
        email: json["email"],
        uid: json["uid"],
        imageUrl: json["imageUrl"],
        userType: json["userType"],
        hasVoted: json["hasVoted"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "cnic": cnic,
        "constituency": constituency,
        "imageUrl": imageUrl,
        "userType": userType,
        "hasVoted": hasVoted,
      };
}
