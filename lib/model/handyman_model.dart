class HandymanModel {
  final String uid;
  final String jobsCompleted;
  final String averageRating;
  final String responseTime;

  HandymanModel({
    required this.uid,
    required this.jobsCompleted,
    required this.averageRating,
    required this.responseTime,
  });

  factory HandymanModel.fromMap(Map<String, dynamic> data) {
    return HandymanModel(
      uid: data['uid'] ?? '',
      jobsCompleted: data['jobsCompleted'] ?? '0',
      averageRating: data['averageRating'] ?? '0',
      responseTime: data['responseTime'] ?? '0',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'jobsCompleted': jobsCompleted,
      'averageRating': averageRating,
      'responseTime': responseTime,
    };
  }
}
