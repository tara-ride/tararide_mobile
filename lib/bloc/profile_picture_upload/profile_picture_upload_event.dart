part of 'profile_picture_upload_bloc.dart';

sealed class ProfilePictureUploadEvent extends Equatable {
  const ProfilePictureUploadEvent();

  @override
  List<Object> get props => [];
}

final class ProfilePictureUploadInitialize extends ProfilePictureUploadEvent {

}

final class ProfilePictureUploadValidate extends ProfilePictureUploadEvent {
  final XFile? file;

  const ProfilePictureUploadValidate({required this.file});

  @override
  List<Object> get props => [file!];
}
