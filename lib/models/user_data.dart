class UserData {
  String? name;
  String? constituency;
  String? cnic;
  String? email;
  String? uid;
  String? imageUrl;
  String? userType;

  UserData({
    required this.name,
    required this.constituency,
    required this.cnic,
    required this.email,
    required this.uid,
    required this.imageUrl,
    required this.userType,
  });

  factory UserData.fromJson(Map<String, dynamic>? json) => UserData(
      name: json!["name"],
      constituency: json["constituency"],
      cnic: json["cnic"],
      email: json["email"],
      uid: json["uid"],
      imageUrl: json["imageUrl"],
      userType: json["userType"]);

  Map<String, dynamic> toJson() => {
        "name": name,
        "constituency": constituency,
        "cnic": cnic,
        "email": email,
        "uid": uid,
        "imageUrl": imageUrl,
        "userType": userType,
      };
}
