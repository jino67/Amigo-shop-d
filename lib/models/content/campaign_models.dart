import 'dart:convert';

class CampaignModel {
  CampaignModel({
    required this.uid,
    required this.name,
    required this.image,
    required this.startTime,
    required this.endTime,
  });

  factory CampaignModel.fromJson(String source) =>
      CampaignModel.fromMap(json.decode(source));

  factory CampaignModel.fromMap(Map<String, dynamic> map) {
    return CampaignModel(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      startTime: DateTime.parse(map['start_time']),
      endTime: DateTime.parse(map['end_time']),
    );
  }

  String toJson() => json.encode(toMap());

  Map<String, dynamic> toMap() {
    return {
      'end_time': endTime.toIso8601String(),
      'image': image,
      'name': name,
      'start_time': startTime.toIso8601String(),
      'uid': uid,
    };
  }

  @override
  String toString() {
    return 'CampaignModel(uid: $uid, name: $name, image: $image, startTime: $startTime, endTime: $endTime)';
  }

  final DateTime endTime;
  final String image;
  final String name;
  final DateTime startTime;
  final String uid;
}
