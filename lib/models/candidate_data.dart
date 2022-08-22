class CandidateData {
  String? uid;
  String? partyName;
  String? imageUrl;
  String? constituency;

  CandidateData({
    required this.uid,
    required this.partyName,
    required this.imageUrl,
    required this.constituency,
  });

  factory CandidateData.fromJson(Map<String, dynamic>? json) => CandidateData(
        uid: json!["uid"],
        partyName: json["partyName"],
        imageUrl: json["imageUrl"],
        constituency: json["constituency"],
      );

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "partyName": partyName,
        "imageUrl": imageUrl,
        "constituency": constituency,
      };
}
