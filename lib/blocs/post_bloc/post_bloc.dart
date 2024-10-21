import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';


part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository _postRepository;
  StreamSubscription<List<Post>>? _postSubscription;
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
  
     // Stream dinleyerek post verisini almak
     await emit.forEach<List<Post>>(
     _postRepository.getPost(), // Stream<List<Post>> dönüyor
     onData: (posts) => GetPostSuccess(posts), // Stream'den veri geldiğinde
     onError: (_, __) => GetPostFailUre(), // Hata durumunda
  );
    });
    
      on<UpdatePosts>((event, emit) {
      emit(GetPostSuccess(event.posts)); // Yeni post verisi alındığında güncelle
    });
  }
  @override
  Future<void> close() {
    _postSubscription?.cancel(); // Bloc kapanırken stream dinleyicisini iptal et
    return super.close();
  }
}
