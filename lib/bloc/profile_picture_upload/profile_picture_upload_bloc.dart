import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

part 'profile_picture_upload_event.dart';
part 'profile_picture_upload_state.dart';

class ProfilePictureUploadBloc extends Bloc<ProfilePictureUploadEvent, ProfilePictureUploadState> {
  ProfilePictureUploadBloc() : super(ProfilePictureUploadAwaiting()) {
    on<ProfilePictureUploadInitialize>((event, emit) {
      emit(ProfilePictureUploadAwaiting());
    });

    on<ProfilePictureUploadValidate>((event, emit) async {
      // do things here

      try {
        if (event.file != null) {
          if (await event.file!.length() / (1048 * 1048) < 3) {
            emit(ProfilePictureUploadSuccess(validatedImage: event.file, imageFileSize: await event.file!.length(), imageLastModifiedDate: await event.file!.lastModified()), );
          } else {
            emit(
              const ProfilePictureUploadFailure(
                errorList: ["File size too large. Please reupload."],
              ),
            );
          }
        } else {
          emit(const ProfilePictureUploadFailure(errorList: ["Failed to capture image data."]));
        }
      } catch (e) {
        print("error: ${e.toString()}");
        emit(ProfilePictureUploadFailure(errorList: [e.toString()]));
      }
    });
  }
}
