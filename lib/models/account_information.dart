class AccountInformationModel {
  final String businessRole;
  final String createdBy;
  final DateTime createdOn;
  final String emailAddress;
  final String rideId;
  final String status;
  final String uuid;
  final String fcmToken;

  AccountInformationModel({
    required this.businessRole,
    required this.createdBy,
    required this.createdOn,
    required this.emailAddress,
    required this.rideId,
    required this.status,
    required this.uuid,
    required this.fcmToken,
  });

  factory AccountInformationModel.fromJson(Map<String, dynamic> json) {
    return AccountInformationModel(
      businessRole: json['business_role'] as String? ?? '',
      createdBy: json['created_by'] as String? ?? '',
      createdOn: DateTime.parse(json["created_on"].toDate().toString()),
      emailAddress: json['email_address'] as String? ?? '',
      rideId: json['ride_id'] as String? ?? '',
      status: json['status'] as String? ?? '',
      uuid: json['uuid'] as String? ?? '',
      fcmToken: json['fcm_token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'business_role': businessRole,
      'created_by': createdBy,
      'created_on': createdOn.toIso8601String(),
      'email_address': emailAddress,
      'ride_id': rideId,
      'status': status,
      'uuid': uuid,
      'fcm_token': fcmToken,
    };
  }
}
