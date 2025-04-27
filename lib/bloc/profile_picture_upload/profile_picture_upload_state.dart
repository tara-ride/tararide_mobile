part of 'profile_picture_upload_bloc.dart';

sealed class ProfilePictureUploadState extends Equatable {
  const ProfilePictureUploadState();

  @override
  List<Object> get props => [];
}

final class ProfilePictureUploadAwaiting extends ProfilePictureUploadState {}

final class ProfilePictureUploadSuccess extends ProfilePictureUploadState {
  final XFile? validatedImage;
  final int imageFileSize;
  final DateTime imageLastModifiedDate;

  const ProfilePictureUploadSuccess({required this.validatedImage, required this.imageFileSize, required this.imageLastModifiedDate});

  @override
  List<Object> get props => [validatedImage!];
}

final class ProfilePictureUploadFailure extends ProfilePictureUploadState {
  final List<String> errorList;

  const ProfilePictureUploadFailure({required this.errorList});

  @override
  List<Object> get props => [errorList];
}
