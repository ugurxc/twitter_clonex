part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();
  
  @override
  List<Object> get props => [];
}

class UpdateUserInfoInitial extends UpdateUserInfoState {}

class UploadPictureFailure extends UpdateUserInfoState {}

class UploadPictureLoading extends UpdateUserInfoState {}

class UploadPictureSuccses extends UpdateUserInfoState {
  final String userImage;

  const UploadPictureSuccses(this.userImage);
  @override
  List<Object> get props => [userImage];
}


