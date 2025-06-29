class ContactInformationModel {
  final String contactName;
  final String emailAddress;
  final String mobileNumber;
  String? plateImageUrl;
  String? plateNumber;
  final String uuid;
  String? vehicleImageUrl;
  String? vehicleModel;

  ContactInformationModel({
    required this.contactName,
    required this.emailAddress,
    required this.mobileNumber,
    required this.plateImageUrl,
    required this.plateNumber,
    required this.uuid,
    required this.vehicleImageUrl,
    required this.vehicleModel,
  });

  factory ContactInformationModel.fromJson(Map<String, dynamic> json) {
    return ContactInformationModel(
      contactName: json['contact_name'] ?? '',
      emailAddress: json['email_address'] ?? '',
      mobileNumber: json['mobile_number'] ?? '',
      plateImageUrl: json['plate_image_url'],
      plateNumber: json['plate_number'],
      uuid: json['uuid'] ?? '',
      vehicleImageUrl: json['vehicle_image_url'],
      vehicleModel: json['vehicle_model'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'contact_name': contactName,
      'email_address': emailAddress,
      'mobile_number': mobileNumber,
      'plate_image_url': plateImageUrl,
      'plate_number': plateNumber,
      'uuid': uuid,
      'vehicle_image_url': vehicleImageUrl,
      'vehicle_model': vehicleModel,
    };
  }
}
