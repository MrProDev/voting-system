class CandidateData {
  String? partyName;
  String? imageUrl;
  String? constituency;
  bool? isApproved;

  CandidateData({
    required this.partyName,
    required this.imageUrl,
    required this.constituency,
    required this.isApproved,
  });

  factory CandidateData.fromJson(Map<String, dynamic>? json) => CandidateData(
        partyName: json!["partyName"],
        imageUrl: json["imageUrl"],
        constituency: json["constituency"],
        isApproved: json["isApproved"],
      );

  Map<String, dynamic> toJson() => {
        "partyName": partyName,
        "imageUrl": imageUrl,
        "constituency": constituency,
        "isApproved": isApproved,
      };
}
