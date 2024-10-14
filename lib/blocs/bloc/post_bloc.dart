import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';


part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  PostBloc({required PostRepository postRepository})  :_postRepository=postRepository, super(PostInitial()) {
            on<CreatePost>((event, emit) async{
      emit(CreatePostLoading());
     try {
      Post post = await _postRepository.createPost(event.post);
       emit(CreatePostSuccess(post));
       add(GetPost());
     } catch (e) {
       emit(CreatePostFailure());
     }
    });
        on<GetPost>((event, emit)  async{
      emit(GetPostLoading());
      try {
        List<Post> posts = await _postRepository.getPost();
        emit(GetPostSuccess(posts));
      } catch (e) {
        emit(GetPostFailUre());
      }
    });
  }
}
