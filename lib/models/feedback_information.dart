class FeedbackInformation {
  final String feedbackId;
  final String rideId;
  final String passengerId;
  final String feedbackComment;
  final int feedbackRating;
  final DateTime feedbackSubmittedOn;

  FeedbackInformation({
    required this.feedbackId,
    required this.rideId,
    required this.passengerId,
    required this.feedbackComment,
    required this.feedbackRating,
    required this.feedbackSubmittedOn,
  });

  factory FeedbackInformation.fromJson(Map<String, dynamic> json) {
    print("tangina gumagana ba talaga");
    return FeedbackInformation(
      feedbackId: json['feedback_id'] ?? "N/A",
      rideId: json['ride_id'] ?? "N/A",
      passengerId: json['passenger_id'] ?? "N/A",
      feedbackComment: json['feedback_comment'] ?? "N/A",
      feedbackRating: int.parse(json['feedback_rating'] ?? "1"),
      feedbackSubmittedOn: DateTime.parse(json["feedback_submitted_on"].toDate().toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'feedback_id': feedbackId,
      'ride_id': rideId,
      'passenger_id': passengerId,
      'feedback_comment': feedbackComment,
      'feedback_rating': feedbackRating,
      'feedback_submitted_on': feedbackSubmittedOn.toIso8601String(),
    };
  }
}
