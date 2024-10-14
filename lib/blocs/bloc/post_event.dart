part of 'post_bloc.dart';

abstract class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}
class CreatePost extends PostEvent{
  final Post post;
  const CreatePost(this.post);
   
  
}
class GetPost extends PostEvent{}