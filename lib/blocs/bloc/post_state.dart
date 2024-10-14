part of 'post_bloc.dart';

abstract class PostState extends Equatable {
  const PostState();
  
  @override
  List<Object> get props => [];
}

final class PostInitial extends PostState {}



final class GetPostFailUre extends PostState {}

final class GetPostLoading extends PostState {}

 class GetPostSuccess extends PostState {
  final List<Post> posts;
  const GetPostSuccess(this.posts);
    @override
  List<Object> get props => [posts];
}
final class CreatePostFailure extends PostState {}
final class CreatePostLoading extends PostState {}
final class CreatePostSuccess extends PostState {
  final Post post;
  const CreatePostSuccess(this.post);
    @override
  List<Object> get props => [post];
}
