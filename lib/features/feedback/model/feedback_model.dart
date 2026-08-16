class FeedbackModel {
  final String userId;
  final String userName;
  final int rating;
  final String message;
  final DateTime createdAt;

  FeedbackModel({
    required this.userId,
    required this.userName,
    required this.rating,
    required this.message,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'userName': userName,
      'rating': rating,
      'message': message,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FeedbackModel.fromMap(Map<String, dynamic> map) {
    return FeedbackModel(
      userId: map['userId']?.toString() ?? '',
      userName: map['userName']?.toString() ?? '',
      rating: int.tryParse(
            map['rating']?.toString() ?? '0',
          ) ??
          0,
      message: map['message']?.toString() ?? '',
      createdAt: DateTime.tryParse(
            map['createdAt']?.toString() ?? '',
          ) ??
          DateTime.now(),
    );
  }
}